//
//  AetherIntToggleObject.swift
//  AetherCircleCore
//
//  Integer spatial toggle controls
//

// MARK: Import

import Foundation

// MARK: Flavor

/// Visual flavor used by an integer toggle.
public enum AetherIntToggleFlavor: Sendable, Equatable {

    /// Slider-style integer control.
    case `default`
}

// MARK: Class

/// A targetable integer control represented as a slider.
///
/// Until drag interaction is available, activation advances the value by one
/// step and wraps from the upper bound to the lower bound.
public final class AetherIntToggleObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Visual flavor used by the control.
    public let flavor: AetherIntToggleFlavor

    /// Current integer value.
    public private(set) var value: Int

    /// Inclusive range of permitted values.
    public let range: ClosedRange<Int>

    /// Amount added by each activation.
    public let step: Int

    /// Dimensions of the slider.
    public let toggleSize: AetherSize3D

    /// Action invoked after the user changes the value.
    public var onChange: AetherBlockInt?

    private let fillObject: AetherBasicObject
    private let thumbObject: AetherBasicObject

    // MARK: Initialization

    /// Creates an integer slider control.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        value: Int = 0,
        range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        flavor: AetherIntToggleFlavor = .default,
        size: AetherSize3D = AetherSize3D(
            x: 0.50,
            y: 0.08,
            z: 0.025
        ),
        trackMaterial: AetherMaterial = .defaultControlOff,
        fillMaterial: AetherMaterial = .defaultControlOn,
        thumbMaterial: AetherMaterial = .defaultControlOn,
        position: AetherPosition3D = .zero,
        isVisible: Bool = true,
        targetAppearance: AetherTargetAppearance = .platformDefault,
        onChange: AetherBlockInt? = nil
    ) {
        self.flavor = flavor
        self.range = range
        self.step = max(1, step)
        self.value = min(
            range.upperBound,
            max(range.lowerBound, value)
        )
        toggleSize = size
        self.onChange = onChange

        let track = AetherBasicObject(
            name: name + " Track",
            primitive: .cube,
            size: size,
            material: trackMaterial
        )
        let fill = AetherBasicObject(
            name: name + " Fill",
            primitive: .cube,
            size: AetherSize3D(
                x: 0.001,
                y: size.y * 0.55,
                z: size.z + 0.002
            ),
            material: fillMaterial
        )
        let thumb = AetherBasicObject.sphere(
            name: name + " Thumb",
            diameter: size.y * 1.35,
            material: thumbMaterial
        )
        fillObject = fill
        thumbObject = thumb

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            objects: [
                track,
                fill,
                thumb,
            ],
            position: position,
            isVisible: isVisible
        )

        self.size = size
        config = AetherInteractionConfig(
            canTarget: true,
            targetAppearance: targetAppearance,
            activateAction: { [weak self] in
                self?.advance()
            }
        )
        updateAppearance()
    }

    // MARK: Value

    /// Sets and clamps the value without invoking the user change action.
    public func setValue(
        _ newValue: Int
    ) {
        value = min(
            range.upperBound,
            max(range.lowerBound, newValue)
        )
        updateAppearance()
    }

    /// Advances by one step, wrapping at the upper range boundary.
    public func advance() {
        let proposed = value + step
        value = proposed > range.upperBound
            ? range.lowerBound
            : proposed
        updateAppearance()
        onChange?(value)
    }

    // MARK: Appearance

    private func updateAppearance() {
        let span = range.upperBound - range.lowerBound
        let progress: AetherFloat

        if span == 0 {
            progress = 1
        } else {
            progress = AetherFloat(
                value - range.lowerBound
            ) / AetherFloat(span)
        }

        let width = max(
            0.001,
            toggleSize.x * progress
        )
        let left = -toggleSize.x / 2
        fillObject.size = AetherSize3D(
            x: width,
            y: toggleSize.y * 0.55,
            z: toggleSize.z + 0.002
        )
        fillObject.position = AetherPosition3D(
            x: left + width / 2,
            y: 0,
            z: 0.002
        )
        thumbObject.position = AetherPosition3D(
            x: left + toggleSize.x * progress,
            y: 0,
            z: toggleSize.z / 2 + 0.006
        )
    }
}

