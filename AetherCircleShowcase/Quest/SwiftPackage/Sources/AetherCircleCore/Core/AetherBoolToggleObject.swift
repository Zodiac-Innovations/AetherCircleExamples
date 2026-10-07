//
//  AetherBoolToggleObject.swift
//  AetherCircleCore
//
//  Boolean spatial toggle controls
//

// MARK: Import

import Foundation

// MARK: Flavor

/// Visual flavor used by a Boolean toggle.
public enum AetherBoolToggleFlavor: Sendable, Equatable {

    /// Platform-neutral default toggle.
    case `default`

    /// Square checkbox with a check mark.
    case checkbox

    /// Radio-group style ring with a selected center.
    case radioGroup

    /// Sliding switch with a movable thumb.
    case `switch`
}

// MARK: Class

/// A targetable Boolean control that toggles between off and on.
public final class AetherBoolToggleObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Visual flavor used by the toggle.
    public let flavor: AetherBoolToggleFlavor

    /// Current Boolean value.
    public private(set) var value: Bool

    /// Dimensions of the toggle.
    public let toggleSize: AetherSize3D

    /// Material used for the off state.
    public let offMaterial: AetherMaterial

    /// Material used for the on state.
    public let onMaterial: AetherMaterial

    /// Action invoked after the user changes the value.
    public var onChange: AetherBlockFlag?

    private let backgroundObject: AetherObject
    private let indicatorObject: AetherObject

    // MARK: Initialization

    /// Creates a Boolean spatial toggle.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        value: Bool = false,
        flavor: AetherBoolToggleFlavor = .default,
        size: AetherSize3D? = nil,
        offMaterial: AetherMaterial = .defaultControlOff,
        onMaterial: AetherMaterial = .defaultControlOn,
        position: AetherPosition3D = .zero,
        isVisible: Bool = true,
        targetAppearance: AetherTargetAppearance = .platformDefault,
        onChange: AetherBlockFlag? = nil
    ) {
        self.flavor = flavor
        self.value = value
        self.offMaterial = offMaterial
        self.onMaterial = onMaterial
        self.onChange = onChange

        let resolvedSize = size ?? Self.defaultSize(
            for: flavor
        )
        toggleSize = resolvedSize

        let parts = Self.makeParts(
            name: name,
            flavor: flavor,
            size: resolvedSize,
            offMaterial: offMaterial,
            onMaterial: onMaterial
        )
        backgroundObject = parts.background
        indicatorObject = parts.indicator

        super.init(
            id: id,
            tag: tag,
            name: name,
            objects: [
                parts.background,
                parts.indicator,
            ],
            position: position,
            isVisible: isVisible
        )

        self.size = resolvedSize
        config = AetherInteractionConfig(
            canTarget: true,
            targetAppearance: targetAppearance,
            activateAction: { [weak self] in
                self?.toggle()
            }
        )
        updateAppearance()
    }

    // MARK: Value

    /// Sets the Boolean value without invoking the user change action.
    public func setValue(
        _ newValue: Bool
    ) {
        value = newValue
        updateAppearance()
    }

    /// Toggles the current value and invokes the user change action.
    public func toggle() {
        value.toggle()
        updateAppearance()
        onChange?(value)
    }

    // MARK: Appearance

    private func updateAppearance() {
        switch flavor {
        case .default:
            backgroundObject.material =
                value ? onMaterial : offMaterial
            indicatorObject.isVisible = true
            indicatorObject.position = AetherPosition3D(
                x: value
                    ? toggleSize.x * 0.22
                    : -toggleSize.x * 0.22,
                y: 0,
                z: toggleSize.z / 2 + 0.006
            )

        case .checkbox:
            backgroundObject.material = offMaterial
            indicatorObject.material = onMaterial
            indicatorObject.isVisible = value

        case .radioGroup:
            backgroundObject.material = offMaterial
            indicatorObject.material = onMaterial
            indicatorObject.isVisible = value

        case .switch:
            backgroundObject.material =
                value ? onMaterial : offMaterial
            indicatorObject.material = onMaterial
            indicatorObject.isVisible = true
            indicatorObject.position = AetherPosition3D(
                x: value
                    ? toggleSize.x * 0.25
                    : -toggleSize.x * 0.25,
                y: 0,
                z: toggleSize.z / 2 + 0.006
            )
        }
    }

    private static func defaultSize(
        for flavor: AetherBoolToggleFlavor
    ) -> AetherSize3D {
        switch flavor {
        case .checkbox, .radioGroup:
            return AetherSize3D(
                x: 0.14,
                y: 0.14,
                z: 0.025
            )

        case .default, .switch:
            return AetherSize3D(
                x: 0.30,
                y: 0.12,
                z: 0.03
            )
        }
    }

    private static func makeParts(
        name: String,
        flavor: AetherBoolToggleFlavor,
        size: AetherSize3D,
        offMaterial: AetherMaterial,
        onMaterial: AetherMaterial
    ) -> (
        background: AetherObject,
        indicator: AetherObject
    ) {
        switch flavor {
        case .default, .switch:
            let background = AetherObject(
                name: name + " Track",
                primitive: .cube,
                size: size,
                material: offMaterial
            )
            let diameter = min(size.y * 0.82, size.x * 0.32)
            let indicator = AetherObject.sphere(
                name: name + " Thumb",
                diameter: diameter,
                material: onMaterial
            )
            return (
                background: background,
                indicator: indicator
            )

        case .checkbox:
            let side = min(size.x, size.y)
            let background = AetherObject(
                name: name + " Box",
                primitive: .cube,
                size: AetherSize3D(
                    x: side,
                    y: side,
                    z: size.z
                ),
                material: offMaterial
            )
            let indicator = AetherTextObject(
                name: name + " Check",
                text: "✓",
                characterHeight: side * 0.60,
                extrusionDepth: min(size.z * 0.30, 0.008),
                material: onMaterial,
                position: AetherPosition3D(
                    x: 0,
                    y: 0,
                    z: size.z / 2 + 0.006
                )
            )
            return (
                background: background,
                indicator: indicator
            )

        case .radioGroup:
            let diameter = min(size.x, size.y)
            let background = AetherObject(
                name: name + " Ring",
                primitive: .ring,
                size: AetherSize3D(
                    x: diameter,
                    y: diameter,
                    z: size.z
                ),
                material: offMaterial
            )
            let indicator = AetherObject(
                name: name + " Selection",
                primitive: .disc,
                position: AetherPosition3D(
                    x: 0,
                    y: 0,
                    z: size.z / 2 + 0.004
                ),
                size: AetherSize3D(
                    x: diameter * 0.52,
                    y: diameter * 0.52,
                    z: size.z
                ),
                material: onMaterial
            )
            return (
                background: background,
                indicator: indicator
            )
        }
    }
}
