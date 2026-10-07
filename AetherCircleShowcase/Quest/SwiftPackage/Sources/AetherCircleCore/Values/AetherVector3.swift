//
//  AetherVector3.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Three-dimensional vector used by AetherCircle
//

// MARK: Import

import Foundation

// MARK: Struct

/// Three-dimensional vector used by AetherCircle for spatial values.
public struct AetherVector3: Sendable, Codable, Hashable {

    /// Value along the horizontal x-axis.
    public var x: AetherFloat

    /// Value along the vertical y-axis.
    public var y: AetherFloat

    /// Value along the depth z-axis.
    public var z: AetherFloat

    /// Creates a three-dimensional vector.
    ///
    /// - Parameters:
    ///   - x: Value along the horizontal x-axis.
    ///   - y: Value along the vertical y-axis.
    ///   - z: Value along the depth z-axis.
    public init(
        x: AetherFloat,
        y: AetherFloat,
        z: AetherFloat
    ) {
        self.x = x
        self.y = y
        self.z = z
    }
}

// MARK: Extensions

public extension AetherVector3 {

    /// Vector with all three components equal to zero.
    static let zero = AetherVector3(x: 0, y: 0, z: 0)

    /// Vector with all three components equal to one.
    static let one = AetherVector3(x: 1, y: 1, z: 1)

    /// Unit vector pointing upward along the positive y-axis.
    static let up = AetherVector3(x: 0, y: 1, z: 0)

    /// Unit vector pointing downward along the negative y-axis.
    static let down = AetherVector3(x: 0, y: -1, z: 0)

    /// Unit vector pointing left along the negative x-axis.
    static let left = AetherVector3(x: -1, y: 0, z: 0)

    /// Unit vector pointing right along the positive x-axis.
    static let right = AetherVector3(x: 1, y: 0, z: 0)

    /// Unit vector pointing forward along the negative z-axis.
    static let forward = AetherVector3(x: 0, y: 0, z: -1)

    /// Unit vector pointing backward along the positive z-axis.
    static let backward = AetherVector3(x: 0, y: 0, z: 1)
}

// MARK: Aliases

/// Position in three-dimensional AetherCircle space, measured in meters.
public typealias AetherPosition3D = AetherVector3

/// Euler rotation around the x, y, and z axes, measured in radians.
public typealias AetherRotation3D = AetherVector3

/// Linear velocity along the x, y, and z axes, measured in meters per second.
public typealias AetherVelocity3D = AetherVector3

/// Linear acceleration along the x, y, and z axes, measured in meters per second squared.
public typealias AetherAcceleration3D = AetherVector3

/// Angular velocity around the x, y, and z axes, measured in radians per second.
public typealias AetherRotationRate3D = AetherVector3

/// Size along the x, y, and z axes, measured in meters.
public typealias AetherSize3D = AetherVector3

