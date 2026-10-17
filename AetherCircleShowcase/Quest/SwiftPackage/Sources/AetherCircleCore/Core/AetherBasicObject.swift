//
//  AetherBasicObject.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Visible object placed within an AetherCircle scene
//

// MARK: Import

import Foundation

// MARK: Class

/// Visible object placed within an AetherCircle scene.
public class AetherBasicObject: AetherObjectProtocol, @unchecked Sendable {

    // MARK: Properties

    /// Unique identifier for the object.
    public let id: UUID

    /// Application-defined integer used to identify the object within scene interactions.
    public var tag: Int

    /// Human-readable name of the object.
    public let name: String

    /// Stable, application-assigned identifier for automation. Empty means unspecified.
    public var autoID: String

    /// Primitive shape used to create the object.
    public let primitive: AetherPrimitive

    /// Position of the object in meters within AetherCircle coordinates.
    public var position: AetherPosition3D

    /// Euler rotation of the object in radians around the x, y, and z axes.
    public var rotation: AetherRotation3D

    /// Size of the object in meters along the width, height, and depth axes.
    public var size: AetherSize3D

    /// Material used to display the object.
    public var material: AetherMaterial

    /// Indicates whether the object should be visible.
    public var isVisible: Bool

    /// Optional user-interaction configuration. A nil value disables interaction.
    public var config: AetherInteractionConfig?

    /// Indicates whether the object can receive user focus.
    public var canFocus: Bool

    /// Indicates whether the object currently has user focus.
    public var isFocused: Bool

    /// Indicates whether the object can be selected.
    public var canSelect: Bool

    /// Indicates whether the object is currently selected.
    public var isSelected: Bool

    /// Indicates whether the object can be activated.
    public var canActivate: Bool

    /// Indicates whether the object can respond to physical touch.
    public var canTouch: Bool

    /// Linear velocity of the object in meters per second.
    public var velocity: AetherVelocity3D?

    /// Linear acceleration of the object in meters per second squared.
    public var acceleration: AetherAcceleration3D?

    /// Angular velocity of the object in radians per second around each axis.
    public var rotationRate: AetherRotationRate3D?

    /// Optional action invoked when the user interacts with the object.
    public var onInteraction: ((AetherInteraction) -> Void)?

    /// Value exposed to automation; specialized editable controls override this.
    public func aetherObjectValue() -> String { "" }

    // MARK: Initialization

    /// Creates an AetherCircle object.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the object.
    ///   - tag: Application-defined integer used for scene interactions.
    ///   - name: Human-readable name of the object.
    ///   - autoID: Stable automation identifier; empty when unspecified.
    ///   - primitive: Primitive shape used to create the object.
    ///   - position: Initial position in meters.
    ///   - rotation: Initial Euler rotation in radians.
    ///   - size: Initial size in meters.
    ///   - material: Initial display material.
    ///   - isVisible: Initial visibility state.
    ///   - config: Optional user-interaction configuration.
    ///   - canFocus: Whether the object can receive user focus.
    ///   - isFocused: Initial focus state.
    ///   - canSelect: Whether the object can be selected.
    ///   - isSelected: Initial selection state.
    ///   - canActivate: Whether the object can be activated.
    ///   - canTouch: Whether the object can respond to physical touch.
    ///   - velocity: Optional initial linear velocity.
    ///   - acceleration: Optional initial linear acceleration.
    ///   - rotationRate: Optional initial angular velocity.
    ///     should be forwarded to the scene.
    ///   - onInteraction: Optional action invoked when the object is interacted with.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        primitive: AetherPrimitive,
        position: AetherPosition3D = .zero,
        rotation: AetherRotation3D = .zero,
        size: AetherSize3D = .one,
        material: AetherMaterial = .defaultObject,
        isVisible: Bool = true,
        config: AetherInteractionConfig? = nil,
        canFocus: Bool = false,
        isFocused: Bool = false,
        canSelect: Bool = false,
        isSelected: Bool = false,
        canActivate: Bool = false,
        canTouch: Bool = false,
        velocity: AetherVelocity3D? = nil,
        acceleration: AetherAcceleration3D? = nil,
        rotationRate: AetherRotationRate3D? = nil,
        onInteraction: ((AetherInteraction) -> Void)? = nil
    ) {
        self.id = id
        self.tag = tag
        self.name = name
        self.autoID = autoID
        self.primitive = primitive
        self.position = position
        self.rotation = rotation
        self.size = size
        self.material = material
        self.isVisible = isVisible
        self.config = config
        self.canFocus = canFocus
        self.isFocused = isFocused
        self.canSelect = canSelect
        self.isSelected = isSelected
        self.canActivate = canActivate
        self.canTouch = canTouch
        self.velocity = velocity
        self.acceleration = acceleration
        self.rotationRate = rotationRate
        self.onInteraction = onInteraction
    }
}

// MARK: Extensions

public extension AetherBasicObject {
    
    /// Creates a cube with equal width, height, and depth.
    static func cube(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        AetherBasicObject(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .cube,
            size: AetherSize3D(
                x: size,
                y: size,
                z: size
            ),
            material: material
        )
    }
    
    /// Creates a sphere with the specified diameter.
    static func sphere(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        AetherBasicObject(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .sphere,
            size: AetherSize3D(
                x: diameter,
                y: diameter,
                z: diameter
            ),
            material: material
        )
    }
    
    /// Creates a space with specific 3D size but no material.
    static func space(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D
    ) -> AetherBasicObject {
        AetherBasicObject(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .space,
            size: size
        )
    }

}

// MARK: extension

public extension AetherBasicObject {

    /// Processes a user interaction with the object.
    ///
    /// Unsupported interactions are ignored. Focus and selection state are
    /// updated before the interaction action is invoked.
    ///
    /// - Parameter interaction: Interaction to process.
    /// - Returns: `true` if the interaction was accepted by the object.
    @discardableResult
    func processInteraction(
        _ interaction: AetherInteraction
    ) -> Bool {

        guard canProcessInteraction(interaction) else {
            return false
        }

        switch interaction.type {

        case .focus:
            isFocused = true

        case .unfocus:
            isFocused = false

        case .select:
            isSelected = true

        case .deselect:
            isSelected = false

        case .activate, .touch:
            break
        }

        onInteraction?(interaction)

        return true
    }

    /// Indicates whether the object accepts the specified interaction.
    ///
    /// - Parameter interaction: Interaction to test.
    /// - Returns: `true` if the interaction is supported by the object.
    func canProcessInteraction(
        _ interaction: AetherInteraction
    ) -> Bool {

        switch interaction.type {

        case .focus, .unfocus:
            return canFocus

        case .select, .deselect:
            return canSelect

        case .activate:
            return canActivate

        case .touch:
            return canTouch
        }
    }
}

