//
//  AetherQuitButtonObject.swift
//  AetherCircleCore
//
//  Reusable quit button with confirmation panel
//

// MARK: Import

import Foundation

// MARK: Class

/// A spatial button that asks for confirmation before invoking a quit action.
///
/// The confirmation panel is owned by the object, starts hidden, and
/// automatically hides after either Yes or No is activated.
public final class AetherQuitButtonObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Button that presents the confirmation panel.
    public let button: AetherButtonObject

    /// Confirmation panel presented by the button.
    public let confirmationPanel: AetherPanelObject

    // MARK: Initialization

    /// Creates a self-contained quit button and confirmation panel.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "Quit",
        autoID: String = "",
        flavor: AetherButtonFlavor = .doubleSided,
        title: String = "Quit",
        confirmationTitle: String = "Quit",
        confirmationMessage: String = "Are you sure you want to quit?",
        size: AetherSize3D = AetherSize3D(
            x: 0.30,
            y: 0.12,
            z: 0.04
        ),
        sizing: AetherButtonSizing = .fitTextToButton,
        material: AetherMaterial = .defaultQuitButton,
        textMaterial: AetherMaterial = .defaultText,
        textBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        panelMaterial: AetherMaterial = .defaultPanel,
        panelTextBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        panelButtonMaterial: AetherMaterial = .defaultButton,
        position: AetherPosition3D = .zero,
        confirmationOffset: AetherPosition3D = AetherPosition3D(
            x: 0,
            y: 0.20,
            z: 0.40
        ),
        isVisible: Bool = true,
        targetAppearance: AetherTargetAppearance = .platformDefault,
        quitAction: AetherBlockSimple? = nil,
        cancelAction: AetherBlockSimple? = nil
    ) {
        let quitButton = AetherButtonObject(
            name: name + " Button",
            flavor: flavor,
            title: title,
            size: size,
            sizing: sizing,
            material: material,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            targetAppearance: targetAppearance
        )
        let panel = AetherPanelObject.yesNoPanel(
            name: name + " Confirmation",
            title: confirmationTitle,
            message: confirmationMessage,
            material: panelMaterial,
            textMaterial: textMaterial,
            textBackgroundMaterial: panelTextBackgroundMaterial,
            buttonMaterial: panelButtonMaterial,
            position: confirmationOffset,
            yesAction: {
                quitButton.isVisible = true
                quitAction?()
            },
            noAction: {
                quitButton.isVisible = true
                cancelAction?()
            }
        )
        panel.hide()

        button = quitButton
        confirmationPanel = panel

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            objects: [
                quitButton,
                panel,
            ],
            position: position,
            isVisible: isVisible
        )

        self.size = size

        quitButton.setAction { [weak panel, weak quitButton] in
            quitButton?.isVisible = false
            panel?.show()
        }
    }

    // MARK: Confirmation

    /// Presents the confirmation panel.
    public func showConfirmation() {
        button.isVisible = false
        confirmationPanel.show()
    }

    /// Hides the confirmation panel and makes the Quit button available again.
    public func hideConfirmation() {
        confirmationPanel.hide()
        button.isVisible = true
    }
}

