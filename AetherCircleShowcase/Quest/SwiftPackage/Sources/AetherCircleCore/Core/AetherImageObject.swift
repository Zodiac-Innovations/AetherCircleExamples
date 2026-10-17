//
//  AetherImageObject.swift
//  AetherCircleCore
//
//  Image displayed on a spatial surface
//

// MARK: Import

import Foundation

// MARK: Class

/// An image displayed on a flat spatial surface.
///
/// The image name is resolved by the platform from the application's bundled
/// resources. The material is used as a fallback when the image cannot load.
public final class AetherImageObject:
    AetherObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Name of the bundled image resource.
    public var imageName: String

    // MARK: Initialization

    /// Creates a spatial image.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        imageName: String,
        size: AetherSize3D = AetherSize3D(
            x: 0.30,
            y: 0.30,
            z: 0.002
        ),
        material: AetherMaterial = .defaultImage,
        position: AetherPosition3D = .zero,
        rotation: AetherRotation3D = .zero,
        isVisible: Bool = true,
        config: AetherInteractionConfig? = nil,
        velocity: AetherVelocity3D? = nil,
        acceleration: AetherAcceleration3D? = nil,
        rotationRate: AetherRotationRate3D? = nil,
        onInteraction: ((AetherInteraction) -> Void)? = nil
    ) {
        self.imageName = imageName

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .plane,
            position: position,
            rotation: rotation,
            size: size,
            material: material,
            isVisible: isVisible,
            config: config,
            velocity: velocity,
            acceleration: acceleration,
            rotationRate: rotationRate,
            onInteraction: onInteraction
        )
    }
}

