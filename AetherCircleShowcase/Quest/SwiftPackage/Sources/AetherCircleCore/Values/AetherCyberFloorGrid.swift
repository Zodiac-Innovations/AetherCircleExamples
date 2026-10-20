import Foundation

/// Shared geometry settings for a world-anchored square grid. Input is millimeters.
public struct AetherCyberFloorGrid: Sendable {
    public static let halfCellCount = 1024
    public let cellWidth: AetherFloat
    public var lineWidth: AetherFloat { min(cellWidth * 0.015, 0.02) }
    public var extent: AetherFloat { cellWidth * AetherFloat(Self.halfCellCount * 2) }
    public var floorExtent: AetherFloat { max(2048, extent + 512) }
    public var rebaseStep: AetherFloat { cellWidth * 32 }

    /// Invalid or unrepresentable widths safely fall back to 1000 mm.
    public init(squareWidth: AetherFloat) {
        let meters = squareWidth / 1000
        cellWidth = meters.isFinite && meters > 0 && meters <= 1_000_000 ? meters : 1
    }

    /// Rebase by whole grid cells, keeping lines and their texture phase stationary.
    public func centerCoordinate(for position: AetherFloat) -> AetherFloat {
        AetherFloat(floor(Double(position / rebaseStep))) * rebaseStep
    }

    /// Two strips at each coordinate: one along X and one along Z.
    /// Fixed geometry count bounds memory even for very small square widths.
    public var lineCoordinates: [AetherFloat] {
        (-Self.halfCellCount...Self.halfCellCount).map { AetherFloat($0) * cellWidth }
    }
}
