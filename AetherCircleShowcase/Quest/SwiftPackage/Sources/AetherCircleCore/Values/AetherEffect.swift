//
//  AetherEffect.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 7/20/26.
//
//  Graphical effect applied when changing visible AetherCircle content
//

// MARK: Import

import Foundation

// MARK: Structure

/// Graphical effect applied when changing visible AetherCircle content.
public struct AetherEffect: Sendable, Codable, Hashable {

    // MARK: Enumeration

    /// Type of graphical effect to apply.
    public enum EffectType: Int, Codable, Sendable {

        /// No graphical effect.
        case none = 0

        /// Fade between the previous and new graphical state.
        case fade = 1

        /// Change graphical content using a sizing transition.
        case sizing = 2
    }

    // MARK: Properties

    /// Type of graphical effect to apply.
    public var type: EffectType

    // MARK: Initialization

    /// Creates a graphical effect.
    ///
    /// - Parameter type: Type of effect to apply.
    public init(
        type: EffectType = .none
    ) {
        self.type = type
    }

}

// MARK: Extensions

public extension AetherEffect {

/// Effect that performs the graphical change without a transition.
static let none = AetherEffect()

}
