//
//  AetherObjectProtocol.swift
//  AetherCircleCore
//
//  Shared identity and spatial properties of AetherCircle scene elements.
//

import Foundation

/// Identity and spatial information shared by every AetherCircle scene element.
///
/// AetherObject supplies the implementation inherited by primitives, composites,
/// text, images, buttons, panels, toggles, and progress elements.
public protocol AetherObjectProtocol: AnyObject {
    /// Unique instance identity.
    var id: UUID { get }

    /// Application-defined numeric identifier.
    var tag: Int { get set }

    /// Human-readable object name.
    var name: String { get }

    /// Stable automation identifier. The default implementation in AetherObject
    /// initializes this to an empty string, meaning unspecified.
    /// Applications should assign unique nonempty values within an automation scope.
    var autoID: String { get set }

    /// Position in meters, relative to the containing scene or composite.
    var position: AetherPosition3D { get set }

    /// Euler rotation in radians.
    var rotation: AetherRotation3D { get set }

    /// Width, height, and depth in meters.
    var size: AetherSize3D { get set }
}
