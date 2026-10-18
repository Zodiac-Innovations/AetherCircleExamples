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
public enum AetherEnvironmentMode: Sendable, Codable, Hashable {

    /// Shows the physical environment through the platform passthrough system.
    case passthrough

    /// Replaces the physical environment with a fully virtual environment.
    /// Empty immersive space; intended for uncommon uses that supply their own surroundings.
    case blankVR

    /// An unlit inward-facing globe. Base-color textures repeat around the user.
    case materialVR(AetherMaterial)
}

