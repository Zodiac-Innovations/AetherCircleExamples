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
    case image360File(String, layout: AetherImage360Layout = .mono)

    /// A registered image key, resolved when the environment is selected.
    case image360Image(String, layout: AetherImage360Layout = .mono)

    /// A partial cylindrical panorama from a bundled file. Angle uses metadata when omitted, then falls back to 270 degrees.
    case panoramaFile(String, horizontalDegrees: AetherFloat? = nil)

    /// A partial cylindrical panorama from a registered image key.
    case panoramaImage(String, horizontalDegrees: AetherFloat? = nil)

    /// Up to eight ordinary photos on inward-facing screens at 45-degree slots.
    /// File names resolve from bundled resources; material fills the surroundings.
    case photo2DFiles([String], material: AetherMaterial)

    /// The same gallery using registered image keys (including downloaded images).
    case photo2DImages([String], material: AetherMaterial)

    /// A native Apple stereo HEIC photo, presented ahead of the user (not a 360 globe).
    /// Requires a platform whose environment engine supports this mode.
    case spatialPhotoFile(String)

    /// A registered native stereo HEIC photo; supports downloaded encoded data.
    case spatialPhotoImage(String)

    /// A world-fixed tiled floor at y=0 beneath a sky with no translation parallax.
    case floorMaterial(floor: AetherMaterial, sky: AetherMaterial)

    /// Each environment has exactly one placement behavior. This is derived
    /// from its case so an application cannot accidentally mix both behaviors.
    public var placement: AetherEnvironmentPlacement {
        switch self {
        case .passthrough, .blankVR, .floorMaterial: return .worldFixed
        case .materialVR, .image360File, .image360Image, .panoramaFile, .panoramaImage, .spatialPhotoFile, .spatialPhotoImage, .photo2DFiles, .photo2DImages: return .userCentered
        }
    }
}

/// How surroundings respond to the user's movement. Scene objects remain
/// world-fixed independently of the environment's placement.
public enum AetherEnvironmentPlacement: String, Sendable, Codable, Hashable {
    /// The user moves through the environment. Also appropriate for future
    /// world environments with an effectively infinitely distant sky.
    case worldFixed
    /// The backdrop follows translation only. Its orientation stays fixed in
    /// the world, so turning the head reveals a different part of the globe.
    case userCentered
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
