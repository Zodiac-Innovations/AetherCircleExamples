//
//  AetherButtonObject.swift
//  AetherCircleCore
//
//  Targetable spatial button composed from geometry and text
//

// MARK: Import

import Foundation

// MARK: Flavor

/// Visual flavor used by an Aether button.
public enum AetherButtonFlavor: Sendable, Equatable {

    /// Standard filled spatial button with text on its front face.
    case `default`

    /// Filled spatial button displaying the same text on its front and back.
    case doubleSided
}

/// Determines how a button reconciles its title with its requested size.
public enum AetherButtonSizing: Sendable, Equatable {

    /// Keeps the requested button size and reduces the title size as needed.
    case fitTextToButton

    /// Keeps the preferred title size and grows the button as needed.
    case fitButtonToText
}

// MARK: Class

/// A targetable spatial button with a text label.
public final class AetherButtonObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Visual flavor used by the button.
    public let flavor: AetherButtonFlavor

    /// Text displayed by the button.
    public let title: String

    /// Resolved dimensions of the button.
    public let buttonSize: AetherSize3D

    /// Sizing behavior used to reconcile the title and button.
    public let sizing: AetherButtonSizing

    // MARK: Initialization

    /// Creates a spatial button.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        flavor: AetherButtonFlavor = .default,
        title: String,
        size: AetherSize3D = AetherSize3D(
            x: 0.24,
            y: 0.10,
            z: 0.03
        ),
        sizing: AetherButtonSizing = .fitTextToButton,
        preferredCharacterHeight: AetherFloat = 0.07,
        horizontalPadding: AetherFloat = 0.04,
        material: AetherMaterial = .defaultButton,
        textMaterial: AetherMaterial = .defaultText,
        textBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        position: AetherPosition3D = .zero,
        isVisible: Bool = true,
        targetAppearance: AetherTargetAppearance = .platformDefault,
        action: AetherBlockSimple? = nil
    ) {
        self.flavor = flavor
        self.title = title
        self.sizing = sizing

        let safePadding = max(0, horizontalPadding)
        let titleUnits = max(
            AetherFloat(title.count) * 0.62,
            1
        )
        let maximumHeightForRequestedWidth = max(
            0.01,
            (size.x - safePadding * 2) / titleUnits
        )
        let requestedHeight = min(
            preferredCharacterHeight,
            size.y * 0.55
        )

        let labelHeight: AetherFloat
        let resolvedSize: AetherSize3D

        switch sizing {

        case .fitTextToButton:
            labelHeight = min(
                requestedHeight,
                maximumHeightForRequestedWidth
            )
            resolvedSize = size

        case .fitButtonToText:
            labelHeight = requestedHeight
            resolvedSize = AetherSize3D(
                x: max(
                    size.x,
                    titleUnits * labelHeight + safePadding * 2
                ),
                y: max(
                    size.y,
                    labelHeight / 0.55
                ),
                z: size.z
            )
        }

        let visualSize: AetherSize3D
        if flavor == .doubleSided {
            visualSize = AetherSize3D(
                x: resolvedSize.x,
                y: resolvedSize.y,
                z: max(
                    resolvedSize.z,
                    resolvedSize.y * 0.65
                )
            )
        } else {
            visualSize = resolvedSize
        }
        buttonSize = visualSize

        let background = AetherObject(
            name: name + " Background",
            primitive: .cube,
            size: visualSize,
            material: material
        )
        let label = AetherTextObject(
            name: name + " Front Label",
            text: title,
            characterHeight: labelHeight,
            extrusionDepth: min(visualSize.z * 0.16, 0.01),
            material: textMaterial,
            backgroundMaterial: textBackgroundMaterial,
            position: AetherPosition3D(
                x: 0,
                y: 0,
                z: visualSize.z / 2 + 0.002
            )
        )
        var objects: [AetherObject] = [
            background,
            label,
        ]

        if flavor == .doubleSided {
            let backLabel = AetherTextObject(
                name: name + " Back Label",
                text: title,
                characterHeight: labelHeight,
                extrusionDepth: min(visualSize.z * 0.16, 0.01),
                material: textMaterial,
                backgroundMaterial: textBackgroundMaterial,
                position: AetherPosition3D(
                    x: 0,
                    y: 0,
                    z: -visualSize.z / 2 - 0.002
                ),
                rotation: AetherRotation3D(
                    x: 0,
                    y: AetherFloat.pi,
                    z: 0
                )
            )
            objects.append(backLabel)
        }

        super.init(
            id: id,
            tag: tag,
            name: name,
            objects: objects,
            position: position,
            isVisible: isVisible,
            config: AetherInteractionConfig(
                canTarget: true,
                targetAppearance: targetAppearance,
                activateAction: action
            )
        )

        self.size = visualSize
    }

    // MARK: Action

    /// Replaces the action invoked when the button is activated.
    public func setAction(
        _ action: AetherBlockSimple?
    ) {
        var interaction = config ?? AetherInteractionConfig(
            canTarget: true
        )
        interaction.activateAction = action
        config = interaction
    }
}
