//
//  AetherQuaternion.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Quaternion used to represent three-dimensional orientation
//

// MARK: Import

import Foundation

// MARK: Structure

/// Quaternion used to represent three-dimensional orientation.
public struct AetherQuaternion: Sendable, Codable, Hashable {

    // MARK: Properties

    /// X component of the quaternion vector portion.
    public var x: AetherFloat

    /// Y component of the quaternion vector portion.
    public var y: AetherFloat

    /// Z component of the quaternion vector portion.
    public var z: AetherFloat

    /// W component representing the scalar portion of the quaternion.
    public var w: AetherFloat

    // MARK: Initialization

    /// Creates a quaternion from its four components.
    ///
    /// - Parameters:
    ///   - x: X component of the vector portion.
    ///   - y: Y component of the vector portion.
    ///   - z: Z component of the vector portion.
    ///   - w: Scalar component.
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

public extension AetherQuaternion {

    /// Identity quaternion representing no rotation.
    static let identity = AetherQuaternion(
        x: 0,
        y: 0,
        z: 0,
        w: 1
    )

}
