import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Encoded JPEG/PNG/HEIC bytes, or the name of a bundled image. Downloaded images
/// are registered as data after the application finishes downloading them.
public enum AetherImageResource: Sendable, Codable, Hashable {
    case file(String)
    case data(Data)
}

/// Per-asset-engine, thread-safe storage. A revision changes on replacement so
/// renderers cannot accidentally reuse an earlier image under the same key.
public final class AetherImageRegistry: @unchecked Sendable {
    public struct Entry: Sendable {
        public let image: AetherImageResource
        public let revision: UInt64
    }

    private let lock = NSLock()
    private var images: [String: Entry] = [:]
    private var revision: UInt64 = 0

    public init() {}

    @discardableResult
    public func register(key: String, image: AetherImageResource) -> Bool {
        guard !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        switch image {
        case .file(let name):
            guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        case .data(let data):
            guard !data.isEmpty else { return false }
        }
        lock.lock()
        defer { lock.unlock() }
        revision &+= 1
        images[key] = Entry(image: image, revision: revision)
        return true
    }

    public enum DownloadError: Error, Equatable {
        case invalidKey
        case unsupportedURL
        case invalidResponse
        case httpStatus(Int)
        case unsupportedImageData
    }

    /// Downloads encoded JPEG/PNG/HEIC bytes and publishes the registration only
    /// after the entire request succeeds. Failure preserves an existing image.
    @discardableResult
    public func register(key: String, from url: URL, session: URLSession = .shared) async throws -> Bool {
        guard !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw DownloadError.invalidKey }
        guard let scheme = url.scheme?.lowercased(), ["https", "http"].contains(scheme),
              url.host != nil else { throw DownloadError.unsupportedURL }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.setValue("AetherCircle/1.0", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await session.data(for: request)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else { throw DownloadError.invalidResponse }
        guard (200..<300).contains(response.statusCode) else { throw DownloadError.httpStatus(response.statusCode) }
        let jpeg = data.starts(with: [0xFF, 0xD8, 0xFF])
        let png = data.starts(with: [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        let bytes = [UInt8](data.prefix(128))
        var heif = false
        if bytes.count >= 16, String(bytes: bytes[4..<8], encoding: .ascii) == "ftyp" {
            let boxSize = Int(bytes[0]) << 24 | Int(bytes[1]) << 16 | Int(bytes[2]) << 8 | Int(bytes[3])
            if boxSize >= 16, boxSize <= data.count {
                let brands = ["heic", "heix", "hevc", "hevx", "mif1", "msf1"]
                for offset in stride(from: 8, through: min(boxSize, bytes.count) - 4, by: 4) where offset != 12 {
                    if let brand = String(bytes: bytes[offset..<(offset + 4)], encoding: .ascii), brands.contains(brand) { heif = true }
                }
            }
        }
        guard jpeg || png || heif else { throw DownloadError.unsupportedImageData }
        return register(key: key, image: .data(data))
    }

    public func entry(for key: String) -> Entry? {
        lock.lock()
        defer { lock.unlock() }
        return images[key]
    }

    public func remove(key: String) {
        lock.lock()
        defer { lock.unlock() }
        images.removeValue(forKey: key)
    }
}
