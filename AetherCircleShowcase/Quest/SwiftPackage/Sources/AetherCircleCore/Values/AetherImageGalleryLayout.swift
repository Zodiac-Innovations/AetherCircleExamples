import Foundation

/// Shared AVP/Quest arrangement for a user-centered photo gallery.
public enum AetherImageGalleryLayout {
    public static let maximumImageCount = 8
    public static let radius: AetherFloat = 4
    /// A 40-degree image width leaves a five-degree gap between adjacent slots.
    public static let maximumWidth: AetherFloat = 2 * radius * tan(20 * .pi / 180)
    public static let maximumHeight: AetherFloat = 3

    /// Positive angles are to the viewer's right. Extra input images are ignored.
    /// An empty list leaves only the supplied background material.
    public static func anglesDegrees(imageCount: Int) -> [AetherFloat] {
        let count = min(max(imageCount, 0), maximumImageCount)
        if count == 1 { return [0] }
        if count == 2 { return [-45, 45] }
        return Array([AetherFloat(0), -45, 45, -90, 90, -135, 135, 180].prefix(count))
    }

    /// Fits the whole image inside its slot without cropping or changing aspect.
    public static func imageSize(pixelWidth: Int, pixelHeight: Int) -> AetherSize3D {
        guard pixelWidth > 0, pixelHeight > 0 else { return .init(x: 0, y: 0, z: 0) }
        let aspect = AetherFloat(pixelWidth) / AetherFloat(pixelHeight)
        let width = min(maximumWidth, maximumHeight * aspect)
        return .init(x: width, y: width / aspect, z: 0)
    }
}
