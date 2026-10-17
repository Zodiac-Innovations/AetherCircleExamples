//
//  AetherPanelObject.swift
//  AetherCircleCore
//
//  Spatial panel that lays out and contains other objects
//

// MARK: Import

import Foundation

// MARK: Flavor

/// Visual and layout flavor used by an Aether panel.
public enum AetherPanelFlavor: Sendable, Equatable {

    /// Standard panel appearance and vertical content layout.
    case `default`
}

// MARK: Class

/// A spatial panel that owns and vertically lays out child objects.
public final class AetherPanelObject:
    AetherCompositeObject,
    @unchecked Sendable {

    // MARK: Properties

    /// Presentation flavor used by the panel.
    public let flavor: AetherPanelFlavor

    /// Optional title displayed at the top of the panel.
    public let title: String?

    /// Objects supplied as the panel's content.
    public let contentObjects: [AetherBasicObject]

    /// Explicit requested size, or nil when content determines the size.
    public let explicitSize: AetherSize3D?

    /// Resolved size used by the panel background.
    public let panelSize: AetherSize3D

    /// Material displayed behind panel-created text.
    public let textBackgroundMaterial: AetherMaterial

    /// Space placed between content objects.
    public let spacing: AetherFloat

    /// Indicates whether an X button is included in the title row.
    public let hideAble: Bool

    /// Optional action invoked after the panel is closed.
    public var onClose: AetherBlockSimple?

    // MARK: Initialization

    /// Creates a spatial panel.
    ///
    /// Pass a size to explicitly control the panel dimensions. Pass nil to
    /// calculate the width and height from the title, contained objects,
    /// padding, and spacing.
    public init(
        id: UUID = UUID(),
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        flavor: AetherPanelFlavor = .default,
        title: String? = nil,
        objects: [AetherBasicObject],
        size: AetherSize3D? = nil,
        spacing: AetherFloat = 0.06,
        padding: AetherFloat = 0.08,
        hideAble: Bool = false,
        material: AetherMaterial = .defaultPanel,
        textMaterial: AetherMaterial = .defaultText,
        textBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        position: AetherPosition3D = .zero,
        isVisible: Bool = true,
        onClose: AetherBlockSimple? = nil
    ) {
        self.flavor = flavor
        self.title = title
        contentObjects = objects
        explicitSize = size
        self.spacing = spacing
        self.hideAble = hideAble
        self.textBackgroundMaterial = textBackgroundMaterial
        self.onClose = onClose

        let resolvedSize = size ?? Self.automaticSize(
            title: title,
            objects: objects,
            spacing: spacing,
            padding: padding,
            hideAble: hideAble
        )
        panelSize = resolvedSize

        let layout = Self.makeLayout(
            name: name,
            title: title,
            objects: objects,
            panelSize: resolvedSize,
            spacing: spacing,
            padding: padding,
            hideAble: hideAble,
            material: material,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial
        )

        super.init(
            id: id,
            tag: tag,
            name: name,
            autoID: autoID,
            objects: layout.objects,
            position: position,
            isVisible: isVisible
        )

        self.size = resolvedSize

        layout.closeButton?.setAction { [weak self] in
            self?.hide()
            self?.onClose?()
        }
    }

    // MARK: Visibility

    /// Makes the panel visible.
    public func show() {
        isVisible = true
    }

    /// Hides the panel.
    public func hide() {
        isVisible = false
    }

    // MARK: Standard Panels

    /// Creates a message panel with a title, message, and dismissing OK button.
    public static func messagePanel(
        name: String = "Message Panel",
        autoID: String = "",
        title: String,
        message: String,
        size: AetherSize3D? = nil,
        spacing: AetherFloat = 0.06,
        material: AetherMaterial = .defaultPanel,
        textMaterial: AetherMaterial = .defaultText,
        textBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        buttonMaterial: AetherMaterial = .defaultButton,
        position: AetherPosition3D = .zero,
        onOK: AetherBlockSimple? = nil
    ) -> AetherPanelObject {
        let label = AetherTextObject(
            name: name + " Message",
            text: message,
            characterHeight: 0.055,
            extrusionDepth: 0.008,
            material: textMaterial,
            backgroundMaterial: textBackgroundMaterial
        )
        let okButton = AetherButtonObject(
            name: name + " OK",
            title: "OK",
            material: buttonMaterial,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            targetAppearance: .goldenGlow
        )
        let panel = AetherPanelObject(
            name: name,
            autoID: autoID,
            title: title,
            objects: [
                label,
                okButton,
            ],
            size: size,
            spacing: spacing,
            material: material,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            position: position
        )

        okButton.setAction { [weak panel] in
            panel?.hide()
            onOK?()
        }

        return panel
    }

    /// Creates a question panel with Yes and No buttons.
    ///
    /// Activating either button automatically hides the panel before invoking
    /// its corresponding action.
    public static func yesNoPanel(
        name: String = "Yes No Panel",
        autoID: String = "",
        title: String,
        message: String,
        size: AetherSize3D? = nil,
        spacing: AetherFloat = 0.06,
        material: AetherMaterial = .defaultPanel,
        textMaterial: AetherMaterial = .defaultText,
        textBackgroundMaterial: AetherMaterial = .defaultTextBackground,
        buttonMaterial: AetherMaterial = .defaultButton,
        position: AetherPosition3D = .zero,
        yesAction: AetherBlockSimple? = nil,
        noAction: AetherBlockSimple? = nil
    ) -> AetherPanelObject {
        let label = AetherTextObject(
            name: name + " Message",
            text: message,
            characterHeight: 0.055,
            extrusionDepth: 0.008,
            material: textMaterial,
            backgroundMaterial: textBackgroundMaterial
        )
        let buttonSize = AetherSize3D(
            x: 0.22,
            y: 0.10,
            z: 0.03
        )
        let yesButton = AetherButtonObject(
            name: name + " Yes",
            title: "Yes",
            size: buttonSize,
            material: buttonMaterial,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            targetAppearance: .goldenGlow
        )
        yesButton.position = AetherPosition3D(
            x: -0.14,
            y: 0,
            z: 0
        )

        let noButton = AetherButtonObject(
            name: name + " No",
            title: "No",
            size: buttonSize,
            material: buttonMaterial,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            targetAppearance: .goldenGlow
        )
        noButton.position = AetherPosition3D(
            x: 0.14,
            y: 0,
            z: 0
        )

        let buttonRow = AetherCompositeObject(
            name: name + " Buttons",
            objects: [
                yesButton,
                noButton,
            ]
        )
        buttonRow.size = AetherSize3D(
            x: 0.50,
            y: 0.10,
            z: 0.03
        )

        let panel = AetherPanelObject(
            name: name,
            autoID: autoID,
            title: title,
            objects: [
                label,
                buttonRow,
            ],
            size: size,
            spacing: spacing,
            material: material,
            textMaterial: textMaterial,
            textBackgroundMaterial: textBackgroundMaterial,
            position: position
        )

        yesButton.setAction { [weak panel] in
            panel?.hide()
            yesAction?()
        }
        noButton.setAction { [weak panel] in
            panel?.hide()
            noAction?()
        }

        return panel
    }

    // MARK: Layout

    private static func automaticSize(
        title: String?,
        objects: [AetherBasicObject],
        spacing: AetherFloat,
        padding: AetherFloat,
        hideAble: Bool
    ) -> AetherSize3D {
        let itemSizes = objects.map(estimatedSize)
        let contentWidth = itemSizes
            .map(\.x)
            .max() ?? 0.30
        let contentHeight = itemSizes
            .map(\.y)
            .reduce(0, +)
        let contentSpacing = spacing * AetherFloat(
            max(0, objects.count - 1)
        )
        let hasTitle = !(title ?? "").isEmpty
        let titleHeight: AetherFloat = hasTitle ? 0.10 : 0
        let titleSpacing: AetherFloat =
            hasTitle && !objects.isEmpty ? spacing : 0
        let titleWidth = estimatedTextWidth(
            title ?? "",
            characterHeight: 0.065
        ) + (hideAble ? 0.16 : 0)
        let width = max(
            0.36,
            max(contentWidth, titleWidth) + padding * 2
        )
        let height = max(
            0.20,
            padding * 2 +
            titleHeight +
            titleSpacing +
            contentHeight +
            contentSpacing
        )

        return AetherSize3D(
            x: width,
            y: height,
            z: 0.04
        )
    }

    private static func makeLayout(
        name: String,
        title: String?,
        objects: [AetherBasicObject],
        panelSize: AetherSize3D,
        spacing: AetherFloat,
        padding: AetherFloat,
        hideAble: Bool,
        material: AetherMaterial,
        textMaterial: AetherMaterial,
        textBackgroundMaterial: AetherMaterial
    ) -> (
        objects: [AetherBasicObject],
        closeButton: AetherButtonObject?
    ) {
        let background = AetherBasicObject(
            name: name + " Background",
            primitive: .cube,
            size: panelSize,
            material: material
        )
        var children: [AetherBasicObject] = [background]
        var closeButton: AetherButtonObject?
        var cursorY = panelSize.y / 2 - padding
        let titleValue = title ?? ""

        if !titleValue.isEmpty {
            let titleObject = AetherTextObject(
                name: name + " Title",
                text: titleValue,
                characterHeight: 0.065,
                extrusionDepth: 0.008,
                material: textMaterial,
                backgroundMaterial: textBackgroundMaterial
            )
            titleObject.position = AetherPosition3D(
                x: 0,
                y: cursorY - 0.05,
                z: panelSize.z / 2 + 0.012
            )
            children.append(titleObject)

            if hideAble {
                let button = AetherButtonObject(
                    name: name + " Close",
                    title: "X",
                    size: AetherSize3D(
                        x: 0.09,
                        y: 0.09,
                        z: 0.025
                    ),
                    material: textMaterial,
                    textMaterial: material,
                    targetAppearance: .goldenGlow
                )
                button.position = AetherPosition3D(
                    x: panelSize.x / 2 - padding - 0.045,
                    y: cursorY - 0.05,
                    z: panelSize.z / 2 + 0.012
                )
                closeButton = button
                children.append(button)
            }

            cursorY -= 0.10 + spacing
        }

        for object in objects {
            let objectSize = estimatedSize(object)
            object.position = AetherPosition3D(
                x: 0,
                y: cursorY - objectSize.y / 2,
                z: panelSize.z / 2 + objectSize.z / 2 + 0.006
            )
            children.append(object)
            cursorY -= objectSize.y + spacing
        }

        return (
            objects: children,
            closeButton: closeButton
        )
    }

    private static func estimatedSize(
        _ object: AetherBasicObject
    ) -> AetherSize3D {
        guard let text = object as? AetherTextObject else {
            return object.size
        }

        return AetherSize3D(
            x: estimatedTextWidth(
                text.text,
                characterHeight: text.characterHeight
            ),
            y: text.characterHeight,
            z: text.extrusionDepth
        )
    }

    private static func estimatedTextWidth(
        _ text: String,
        characterHeight: AetherFloat
    ) -> AetherFloat {
        max(
            characterHeight,
            AetherFloat(text.count) * characterHeight * 0.62
        )
    }
}

