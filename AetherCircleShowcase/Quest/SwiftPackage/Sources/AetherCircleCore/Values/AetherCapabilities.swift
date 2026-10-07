 //
//  AetherCapabilities.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Capabilities reported by an AetherCircle platform implementation
//

// MARK: Import

import Foundation

// MARK: Struct

/// Capabilities reported by an AetherCircle platform implementation.
public struct AetherCapabilities: Sendable, Codable, Hashable {

    /// Highest complete AetherCircle Core support level provided by the platform.
    public var coreLevel: AetherSupportLevel

    /// Indicates whether the platform can display the physical environment using passthrough.
    public var supportsPassthrough: Bool

    /// Indicates whether the platform can display a fully virtual environment.
    public var supportsFullVR: Bool

    /// Indicates whether the platform provides the AetherCircle heads-up display service.
    public var supportsHUD: Bool

    /// Indicates whether the platform provides the AetherCircle clock service.
    public var supportsClock: Bool

    /// Creates a platform capability report.
    ///
    /// - Parameters:
    ///   - coreLevel: Highest complete AetherCircle Core support level provided by the platform.
    ///   - supportsPassthrough: Whether the platform supports passthrough mode.
    ///   - supportsFullVR: Whether the platform supports full virtual reality mode.
    ///   - supportsHUD: Whether the platform supports the heads-up display service.
    ///   - supportsClock: Whether the platform supports the clock service.
    public init(
        coreLevel: AetherSupportLevel,
        supportsPassthrough: Bool,
        supportsFullVR: Bool,
        supportsHUD: Bool,
        supportsClock: Bool
    ) {
        self.coreLevel = coreLevel
        self.supportsPassthrough = supportsPassthrough
        self.supportsFullVR = supportsFullVR
        self.supportsHUD = supportsHUD
        self.supportsClock = supportsClock
    }
}
