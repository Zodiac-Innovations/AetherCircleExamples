//
//  AetherEnvironmentMode.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Immersion mode requested by an AetherCircle application
//

// MARK: Import

import Foundation

// MARK: Enumeration

/// Immersion mode requested by an AetherCircle application.
public enum AetherEnvironmentMode: String, Sendable, Codable, Hashable {

    /// Shows the physical environment through the platform passthrough system.
    case passthrough

    /// Replaces the physical environment with a fully virtual environment.
    case fullVR
}
