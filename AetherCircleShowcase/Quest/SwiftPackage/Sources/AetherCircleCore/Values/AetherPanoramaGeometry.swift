import Foundation

/// Cylindrical projection for a stitched camera/phone sweep. The image covers
/// its capture angle, rather than being stretched over an entire sphere.
public struct AetherPanoramaGeometry: Sendable {
    public enum GeometryError: Error { case invalidDimensions, invalidAngle }
    public let horizontalRadians: AetherFloat
    public let heightAtUnitRadius: AetherFloat

    public init(pixelWidth: Int, pixelHeight: Int, horizontalDegrees: AetherFloat = 270) throws {
        guard pixelWidth > 0, pixelHeight > 0 else { throw GeometryError.invalidDimensions }
        guard horizontalDegrees.isFinite, horizontalDegrees > 0, horizontalDegrees <= 360 else {
            throw GeometryError.invalidAngle
        }
        horizontalRadians = horizontalDegrees * .pi / 180
        heightAtUnitRadius = horizontalRadians * AetherFloat(pixelHeight) / AetherFloat(pixelWidth)
    }

    /// Normalized image coordinates: u runs left to right, v bottom to top.
    public func position(u: AetherFloat, v: AetherFloat) -> AetherVector3 {
        let angle = (u - 0.5) * horizontalRadians
        return AetherVector3(x: AetherFloat(sin(Double(angle))), y: (v - 0.5) * heightAtUnitRadius, z: -AetherFloat(cos(Double(angle))))
    }
}
