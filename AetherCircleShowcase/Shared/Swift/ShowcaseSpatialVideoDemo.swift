#if os(visionOS)
import AVFoundation
import CoreImage
import CoreMedia
import CoreVideo
import VideoToolbox
import Foundation

/// Builds a real two-layer MV-HEVC demo on the device. Linux build hosts cannot
/// encode MV-HEVC; no fake mono movie is used for the native format example.
@available(visionOS 26.0, *)
enum ShowcaseSpatialVideoDemo {
    enum ConversionError: Error { case invalidSource, unsupportedEncoder, conversion }

    static func convert(input: URL, output: URL) async throws {
        let asset = AVURLAsset(url: input)
        guard let track = try await asset.loadTracks(withMediaType: .video).first else { throw ConversionError.invalidSource }
        let size = try await track.load(.naturalSize)
        let width = Int(size.width) / 2, height = Int(size.height)
        guard width > 0, height > 0, Int(size.width) % 2 == 0 else { throw ConversionError.invalidSource }
        let reader = try AVAssetReader(asset: asset)
        let source = AVAssetReaderTrackOutput(track: track, outputSettings: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferIOSurfacePropertiesKey as String: [String: Any](),
        ])
        source.alwaysCopiesSampleData = false
        reader.add(source)
        let writer = try AVAssetWriter(outputURL: output, fileType: .mov)
        let properties: [String: Any] = [
            kVTCompressionPropertyKey_MVHEVCVideoLayerIDs as String: [0, 1],
            kVTCompressionPropertyKey_MVHEVCViewIDs as String: [0, 1],
            kVTCompressionPropertyKey_MVHEVCLeftAndRightViewIDs as String: [0, 1],
            kVTCompressionPropertyKey_HasLeftStereoEyeView as String: true,
            kVTCompressionPropertyKey_HasRightStereoEyeView as String: true,
        ]
        let settings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.hevc,
            AVVideoWidthKey: width, AVVideoHeightKey: height, AVVideoCompressionPropertiesKey: properties]
        guard writer.canApply(outputSettings: settings, forMediaType: .video) else { throw ConversionError.unsupportedEncoder }
        let inputTrack = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: width, kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferIOSurfacePropertiesKey as String: [String: Any](),
        ]
        let adaptor = AVAssetWriterInputTaggedPixelBufferGroupAdaptor(assetWriterInput: inputTrack, sourcePixelBufferAttributes: attributes)
        writer.add(inputTrack)
        var pool: CVPixelBufferPool?
        guard CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary, &pool) == kCVReturnSuccess, let pool else {
            throw ConversionError.conversion
        }
        guard reader.startReading(), writer.startWriting() else { throw ConversionError.conversion }
        writer.startSession(atSourceTime: .zero)
        let context = CIContext(options: [.cacheIntermediates: false])
        do {
            while let sample = source.copyNextSampleBuffer() {
                try Task.checkCancellation()
                while !inputTrack.isReadyForMoreMediaData {
                    guard writer.status == .writing else { throw writer.error ?? ConversionError.conversion }
                    try await Task.sleep(nanoseconds: 5_000_000)
                }
                try autoreleasepool {
                    guard let packed = CMSampleBufferGetImageBuffer(sample) else { throw ConversionError.conversion }
                    let image = CIImage(cvPixelBuffer: packed)
                    var buffers: [CMTaggedBuffer] = []
                    for eye in 0...1 {
                        var created: CVPixelBuffer?
                        guard CVPixelBufferPoolCreatePixelBuffer(nil, pool, &created) == kCVReturnSuccess,
                              let created else { throw ConversionError.conversion }
                        let x = CGFloat(eye * width)
                        let crop = image.cropped(to: CGRect(x: x, y: 0, width: CGFloat(width), height: CGFloat(height)))
                            .transformed(by: CGAffineTransform(translationX: -x, y: 0))
                        context.render(crop, to: created)
                        buffers.append(CMTaggedBuffer(tags: [.videoLayerID(Int64(eye)),
                            .stereoView(eye == 0 ? .leftEye : .rightEye)], buffer: .pixelBuffer(created)))
                    }
                    guard adaptor.appendTaggedBuffers(buffers, withPresentationTime: sample.presentationTimeStamp) else {
                        throw writer.error ?? ConversionError.conversion
                    }
                }
            }
            guard reader.status == .completed else { throw reader.error ?? ConversionError.conversion }
            inputTrack.markAsFinished()
            await writer.finishWriting()
            try Task.checkCancellation()
            guard writer.status == .completed else { throw writer.error ?? ConversionError.conversion }
        } catch {
            reader.cancelReading(); writer.cancelWriting()
            throw error
        }
    }
}
#endif
