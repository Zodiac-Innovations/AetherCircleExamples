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

    /// A complete equirectangular photograph, wrapped once around the user.
    /// Stereo layouts contain distinct left- and right-eye views.
    case image360(String, layout: AetherImage360Layout = .mono)
}


/// Explicit packing of equirectangular 360-degree photographs.
public enum AetherImage360Layout: String, Sendable, Codable, Hashable, CaseIterable {
    /// A single 2:1 panorama, shown to both eyes.
    case mono
    /// A square image: left eye on top, right eye on bottom.
    case stereoTopBottom
    /// A 4:1 image: left eye on the left, right eye on the right.
    case stereoSideBySide
}
