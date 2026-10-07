//
//  AetherPrimitive.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Primitive shapes supported directly by AetherCircle Core
//

// MARK: Import

import Foundation

// MARK: Enumeration

/// Primitive shape supported directly by AetherCircle Core.
public enum AetherPrimitive: String, Sendable, Codable, Hashable, CaseIterable {

    /// Six-sided solid with equal edge lengths unless separately sized.
    case cube

    /// Six-sided rectangular solid.
    case box

    /// Round three-dimensional sphere.
    case sphere

    /// Upper half of a sphere with a closed flat base.
    case hemisphere

    /// Sphere independently sized along its three axes.
    case ellipsoid

    /// Circular or elliptical solid with parallel end caps.
    case cylinder

    /// Circular or elliptical solid tapering to a point.
    case cone

    /// Cylinder with rounded hemispherical ends.
    case capsule

    /// Square-based solid tapering to a point.
    case pyramid

    /// Four-faced triangular solid.
    case tetrahedron

    /// Eight-faced solid resembling a three-dimensional diamond.
    case octahedron

    /// Triangular prism commonly used as a ramp.
    case wedge

    /// Regular six-sided prism.
    case prism

    /// Ring-shaped three-dimensional solid.
    case torus

    /// Flat rectangular surface.
    case plane

    /// Flat triangular surface.
    case triangle

    /// Flat filled circular surface.
    case disc

    /// Flat circular band.
    case ring

    /// Invisible three-dimensional region used for interaction.
    case space
}

// MARK: Collections

public extension AetherPrimitive {

    /// All primitives that have a visible representation.
    static var visibleCases: [AetherPrimitive] {
        allCases.filter {
            $0 != .space
        }
    }
}
