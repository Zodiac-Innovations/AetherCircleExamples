//
//  AetherAssetEngine.swift
//  AetherCircleCore
//
//  Platform engine contract for managing assets and materials
//

import Foundation

/// Surface finish applied to a material.
public enum AetherMaterialFinish: Int, Codable, Sendable, Hashable {
    case base = 0
    case glossy = 1
    case dull = 2
}

/// Platform engine contract for shared and inline materials.
public protocol AetherAssetEngine: AetherEngine {

    /// Registers or replaces a shared material.
    func registerMaterial(
        key: String,
        material: AetherMaterial
    )

    /// Returns a registered material, or nil for an unknown key.
    func registeredMaterial(
        for key: String
    ) -> AetherMaterial?
}

public extension AetherAssetEngine {

    /// Registers a color as a shared material.
    func registerColor(
        key: String,
        color: AetherColor,
        finish: AetherMaterialFinish = .base
    ) {
        registerMaterial(
            key: key,
            material: .color(
                color,
                finish: finish
            )
        )
    }

    /// Compatibility-style convenience for a base-finish color.
    func registerBaseColor(
        key: String,
        color: AetherColor
    ) {
        registerColor(
            key: key,
            color: color
        )
    }

    /// Restores all framework material keys to their original definitions.
    func resetDefaultMaterials() {
        AetherMaterial.resetDefaults(
            in: self
        )
    }
}

/// Placeholder asset engine used by Core-only environments.
public final class AetherAssetDummy: AetherAssetEngine {

    private var materials: [String: AetherMaterial] = [:]

    public init() {
        AetherMaterial.resetDefaults(
            in: self
        )
    }

    public func registerMaterial(
        key: String,
        material: AetherMaterial
    ) {
        materials[key] = material
    }

    public func registeredMaterial(
        for key: String
    ) -> AetherMaterial? {
        materials[key]
    }
}
