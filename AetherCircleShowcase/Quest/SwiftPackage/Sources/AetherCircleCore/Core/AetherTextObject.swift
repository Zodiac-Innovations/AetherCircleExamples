//
//  AetherTextObject.swift
//  AetherCircleCore
//
//  Three-dimensional text placed within an AetherCircle scene
//

// MARK: Import

import Foundation

// MARK: Class

/// Text represented as a three-dimensional object.
///
/// The platform renderer determines the native font implementation. Character
/// height and extrusion depth are expressed in meters.
public final class AetherTextObject:
    AetherObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Text displayed by the object.
    public var text: String

    /// Approximate height of the text characters in meters.
    public var characterHeight: AetherFloat

    /// Depth of the generated text geometry in meters.
    public var extrusionDepth: AetherFloat

    /// Material displayed behind the text. The framework default is clear.
    public var backgroundMaterial: AetherMaterial

    // MARK: Initialization

    /// Creates a three-dimensional text object.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        text: String,
        characterHeight: AetherFloat = 0.12,
        extrusionDepth: AetherFloat = 0.01,
        material: AetherMaterial = .defaultText,
        backgroundMaterial: AetherMaterial = .defaultTextBackground,
        position: AetherPosition3D = .zero,
        rotation: AetherRotation3D = .zero,
        isVisible: Bool = true,
        config: AetherInteractionConfig? = nil,
        velocity: AetherVelocity3D? = nil,
        acceleration: AetherAcceleration3D? = nil,
        rotationRate: AetherRotationRate3D? = nil,
        onInteraction: ((AetherInteraction) -> Void)? = nil
    ) {
        self.text = text
        self.characterHeight = characterHeight
        self.extrusionDepth = extrusionDepth
        self.backgroundMaterial = backgroundMaterial

        super.init(
            id: id,
            tag: tag,
            name: name,
            primitive: .space,
            position: position,
            rotation: rotation,
            size: AetherSize3D(
                x: characterHeight,
                y: characterHeight,
                z: extrusionDepth
            ),
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
