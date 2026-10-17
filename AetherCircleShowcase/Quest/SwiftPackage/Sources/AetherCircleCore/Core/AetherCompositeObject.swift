//
//  AetherCompositeObject.swift
//  AetherCircleCore
//
//  Object composed from other AetherCircle objects
//

// MARK: Import

import Foundation

// MARK: Class

/// An object composed from child objects that move and interact as one group.
///
/// Child positions and rotations are relative to the composite object.
public class AetherCompositeObject:
    AetherBasicObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Objects contained by the composite.
    public private(set) var children: [AetherBasicObject]

    /// Alias describing the child objects that make up the composite.
    public var objects: [AetherBasicObject] {
        children
    }

    // MARK: Initialization

    /// Creates a composite object.
    ///
    /// The composite's interaction configuration is inherited by children that
    /// do not define their own configuration. A child configuration therefore
    /// overrides the composite for that child.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        objects: [AetherBasicObject] = [],
        position: AetherPosition3D = .zero,
        rotation: AetherRotation3D = .zero,
        isVisible: Bool = true,
        config: AetherInteractionConfig? = nil,
        velocity: AetherVelocity3D? = nil,
        acceleration: AetherAcceleration3D? = nil,
        rotationRate: AetherRotationRate3D? = nil,
        onInteraction: ((AetherInteraction) -> Void)? = nil
    ) {
        children = objects

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .space,
            position: position,
            rotation: rotation,
            size: .one,
            isVisible: isVisible,
            config: config,
            velocity: velocity,
            acceleration: acceleration,
            rotationRate: rotationRate,
            onInteraction: onInteraction
        )
    }

    // MARK: Children

    /// Adds a child object to the composite.
    public func add(
        _ object: AetherBasicObject
    ) {
        children.append(object)
    }

    /// Removes every child with the specified object's identifier.
    public func remove(
        _ object: AetherBasicObject
    ) {
        children.removeAll {
            $0.id == object.id
        }
    }

    /// Removes all child objects.
    public func removeAll() {
        children.removeAll()
    }
}

