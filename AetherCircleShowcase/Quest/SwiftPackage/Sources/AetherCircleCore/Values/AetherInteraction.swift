//
//  AetherInteraction.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/12/26.
//
//  User interaction with an AetherCircle object
//

// MARK: Import

import Foundation

// MARK: Structure

/// User interaction with an AetherCircle object.
public struct AetherInteraction: Sendable, Codable, Hashable {

    // MARK: Enumeration

    /// Type of user interaction with an object.
    public enum InteractionType: Int, Codable, Sendable {

        /// Object has gained user focus.
        case focus = 0

        /// Object has lost user focus.
        case unfocus = 1

        /// Object has been selected.
        case select = 2

        /// Object has been deselected.
        case deselect = 3

        /// Object has been activated by the user.
        case activate = 4

        /// Object has been physically touched by the user.
        case touch = 5
    }

    // MARK: Properties

    /// Type of user interaction.
    public var type: InteractionType

    // MARK: Initialization

    /// Creates a user interaction.
    ///
    /// - Parameter type: Type of interaction.
    public init(
        type: InteractionType
    ) {
        self.type = type
    }
}

// MARK: Interaction Configuration

/// Appearance applied while an object is targeted by the user.
public enum AetherTargetAppearance: Sendable, Equatable {

    /// Uses the platform's standard target appearance.
    case platformDefault

    /// Applies a golden-yellow glow to the targeted object.
    case goldenGlow
}

/// Visual response applied while an object interaction is active.
public enum AetherInteractionType: Sendable, Equatable {

    /// No visual response.
    case none

    /// Makes the object glow.
    case glow

    /// Enlarges the object by the specified percentage.
    case enlarge(Int)
}

/// Configures the ways a user can interact with an AetherCircle object.
public struct AetherInteractionConfig {

    // MARK: Properties

    /// Indicates whether the object can be targeted.
    ///
    /// Each platform supplies its native targeting feedback.
    public var canTarget: Bool

    /// Visual appearance while the object is targeted.
    public var targetAppearance: AetherTargetAppearance

    /// Visual response when the object is activated.
    public var typeActivate: AetherInteractionType

    /// Action invoked when the object is activated.
    public var activateAction: AetherBlockSimple?

    /// Visual response while the object is being touched.
    public var typeTouch: AetherInteractionType

    /// Action invoked with `true` when touch begins and `false` when it ends.
    public var touchAction: AetherBlockFlag?

    // MARK: Initialization

    /// Creates an interaction configuration.
    public init(
        canTarget: Bool = false,
        targetAppearance: AetherTargetAppearance = .platformDefault,
        typeActivate: AetherInteractionType = .none,
        activateAction: AetherBlockSimple? = nil,
        typeTouch: AetherInteractionType = .none,
        touchAction: AetherBlockFlag? = nil
    ) {
        self.canTarget = canTarget
        self.targetAppearance = targetAppearance
        self.typeActivate = typeActivate
        self.activateAction = activateAction
        self.typeTouch = typeTouch
        self.touchAction = touchAction
    }
}
