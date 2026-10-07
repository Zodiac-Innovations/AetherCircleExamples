//
//  AetherVector4.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Four-dimensional vector used by AetherCircle
//

// MARK: Import

import Foundation

// MARK: Struct

/// Four-dimensional vector used by AetherCircle for four-component values.
public struct AetherVector4: Sendable, Codable, Hashable {

    /// First vector component.
    public var x: AetherFloat

    /// Second vector component.
    public var y: AetherFloat

    /// Third vector component.
    public var z: AetherFloat

    /// Fourth vector component.
    public var w: AetherFloat

    /// Creates a four-dimensional vector.
    ///
    /// - Parameters:
    ///   - x: First vector component.
    ///   - y: Second vector component.
    ///   - z: Third vector component.
    ///   - w: Fourth vector component.
    public init(
        x: AetherFloat,
        y: AetherFloat,
        z: AetherFloat,
        w: AetherFloat
    ) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}

// MARK: Extensions

public extension AetherVector4 {

    /// Vector with all four components equal to zero.
    static let zero = AetherVector4(x: 0, y: 0, z: 0, w: 0)

    /// Vector with all four components equal to one.
    static let one = AetherVector4(x: 1, y: 1, z: 1, w: 1)
}

