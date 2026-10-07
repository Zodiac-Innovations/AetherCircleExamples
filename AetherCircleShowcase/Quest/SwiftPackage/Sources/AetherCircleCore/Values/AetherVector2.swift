//
//  AetherVector2.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Two-dimensional vector used by AetherCircle
//

// MARK: Import

import Foundation

// MARK: Struct

/// Two-dimensional vector used by AetherCircle for planar values.
public struct AetherVector2: Sendable, Codable, Hashable {

    /// Value along the horizontal x-axis.
    public var x: AetherFloat

    /// Value along the vertical y-axis.
    public var y: AetherFloat

    /// Creates a two-dimensional vector.
    ///
    /// - Parameters:
    ///   - x: Value along the horizontal x-axis.
    ///   - y: Value along the vertical y-axis.
    public init(
        x: AetherFloat,
        y: AetherFloat
    ) {
        self.x = x
        self.y = y
    }
}

// MARK: Extensions

public extension AetherVector2 {

    /// Vector with both components equal to zero.
    static let zero = AetherVector2(x: 0, y: 0)

    /// Vector with both components equal to one.
    static let one = AetherVector2(x: 1, y: 1)
}

// MARK: Aliases


/// Two-dimensional size expressed as width and height.
public typealias AetherSize2D = AetherVector2

