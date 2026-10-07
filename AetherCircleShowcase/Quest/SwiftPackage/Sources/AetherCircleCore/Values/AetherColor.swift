//
//  AetherColor.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Color used by AetherCircle for all operations
//

// MARK: Import

import Foundation

// MARK: Struct

/// Color used by AetherCircle for all operations.
public struct AetherColor: Sendable, Codable, Hashable {

    /// Red color component, normally between zero and one.
    public var red: AetherFloat

    /// Green color component, normally between zero and one.
    public var green: AetherFloat

    /// Blue color component, normally between zero and one.
    public var blue: AetherFloat

    /// Alpha component, where zero is transparent and one is opaque.
    public var alpha: AetherFloat

    /// Creates an AetherCircle color.
    ///
    /// - Parameters:
    ///   - red: Red color component, normally between zero and one.
    ///   - green: Green color component, normally between zero and one.
    ///   - blue: Blue color component, normally between zero and one.
    ///   - alpha: Alpha component, where zero is transparent and one is opaque.
    public init(
        red: AetherFloat,
        green: AetherFloat,
        blue: AetherFloat,
        alpha: AetherFloat = 1
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

// MARK: Extensions

public extension AetherColor {

    /// Clear AetherColor with red, green, blue, and alpha equal to zero.
    static let clear = AetherColor(red: 0, green: 0, blue: 0, alpha: 0)

    /// Black AetherColor with full opacity.
    static let black = AetherColor(red: 0, green: 0, blue: 0)

    /// White AetherColor with full opacity.
    static let white = AetherColor(red: 1, green: 1, blue: 1)

    /// Red AetherColor with full opacity.
    static let red = AetherColor(red: 1, green: 0, blue: 0)

    /// Green AetherColor with full opacity.
    static let green = AetherColor(red: 0, green: 1, blue: 0)

    /// Blue AetherColor with full opacity.
    static let blue = AetherColor(red: 0, green: 0, blue: 1)
}
