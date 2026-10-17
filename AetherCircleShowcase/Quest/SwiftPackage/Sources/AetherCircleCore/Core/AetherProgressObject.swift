//
//  AetherProgressObject.swift
//  AetherCircleCore
//
//  Spatial progress indicator
//

// MARK: Import

import Foundation

// MARK: Flavor

/// Visual flavor used by a progress object.
public enum AetherProgressFlavor: Sendable, Equatable {

    /// Horizontal progress bar.
    case `default`
}

// MARK: Class

/// A noninteractive spatial progress indicator.
public final class AetherProgressObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Visual flavor used by the progress indicator.
    public let flavor: AetherProgressFlavor

    /// Current progress clamped between zero and one.
    public private(set) var progress: AetherFloat

    /// Dimensions of the complete progress track.
    public let progressSize: AetherSize3D

    private let fillObject: AetherObject

    // MARK: Initialization

    /// Creates a spatial progress indicator.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        progress: AetherFloat = 0,
        flavor: AetherProgressFlavor = .default,
        size: AetherSize3D = AetherSize3D(
            x: 0.50,
            y: 0.06,
            z: 0.025
        ),
        trackMaterial: AetherMaterial = .defaultProgressTrack,
        fillMaterial: AetherMaterial = .defaultProgressFill,
        position: AetherPosition3D = .zero,
        isVisible: Bool = true
    ) {
        self.flavor = flavor
        self.progress = min(1, max(0, progress))
        progressSize = size

        let track = AetherObject(
            name: name + " Track",
            primitive: .cube,
            size: size,
            material: trackMaterial
        )
        let fill = AetherObject(
            name: name + " Fill",
            primitive: .cube,
            size: AetherSize3D(
                x: 0.001,
                y: size.y * 0.60,
                z: size.z + 0.002
            ),
            material: fillMaterial
        )
        fillObject = fill

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            objects: [
                track,
                fill,
            ],
            position: position,
            isVisible: isVisible
        )

        self.size = size
        updateAppearance()
    }

    // MARK: Progress

    /// Sets and clamps progress between zero and one.
    public func setProgress(
        _ newProgress: AetherFloat
    ) {
        progress = min(
            1,
            max(0, newProgress)
        )
        updateAppearance()
    }

    // MARK: Appearance

    private func updateAppearance() {
        let width = max(
            0.001,
            progressSize.x * progress
        )
        fillObject.size = AetherSize3D(
            x: width,
            y: progressSize.y * 0.60,
            z: progressSize.z + 0.002
        )
        fillObject.position = AetherPosition3D(
            x: -progressSize.x / 2 + width / 2,
            y: 0,
            z: 0.002
        )
        fillObject.isVisible = progress > 0
    }
}

