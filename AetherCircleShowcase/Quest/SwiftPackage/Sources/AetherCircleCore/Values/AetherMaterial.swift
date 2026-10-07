//
//  AetherMaterial.swift
//  AetherCircleCore
//
//  Platform-neutral surface materials and standard material keys
//

import Foundation

/// Platform-neutral physically based surface description.
public struct AetherMaterialSurface: Sendable, Codable, Hashable {

    public var baseColor: AetherColor
    public var baseColorTexture: String?
    public var normalTexture: String?
    public var roughnessTexture: String?
    public var metallicTexture: String?
    public var ambientOcclusionTexture: String?
    public var emissiveTexture: String?
    public var opacityTexture: String?
    public var roughness: AetherFloat
    public var metallic: AetherFloat
    public var emissiveColor: AetherColor
    public var finish: AetherMaterialFinish

    public init(
        baseColor: AetherColor = .white,
        baseColorTexture: String? = nil,
        normalTexture: String? = nil,
        roughnessTexture: String? = nil,
        metallicTexture: String? = nil,
        ambientOcclusionTexture: String? = nil,
        emissiveTexture: String? = nil,
        opacityTexture: String? = nil,
        roughness: AetherFloat = 0.5,
        metallic: AetherFloat = 0,
        emissiveColor: AetherColor = .clear,
        finish: AetherMaterialFinish = .base
    ) {
        self.baseColor = baseColor
        self.baseColorTexture = baseColorTexture
        self.normalTexture = normalTexture
        self.roughnessTexture = roughnessTexture
        self.metallicTexture = metallicTexture
        self.ambientOcclusionTexture = ambientOcclusionTexture
        self.emissiveTexture = emissiveTexture
        self.opacityTexture = opacityTexture
        self.roughness = roughness
        self.metallic = metallic
        self.emissiveColor = emissiveColor
        self.finish = finish
    }
}

/// A material supplied directly to an object or resolved through a shared key.
public enum AetherMaterial: Sendable, Codable, Hashable {

    case named(String)
    case surface(AetherMaterialSurface)

    public static func color(
        _ color: AetherColor,
        finish: AetherMaterialFinish = .base
    ) -> AetherMaterial {
        .surface(
            AetherMaterialSurface(
                baseColor: color,
                finish: finish
            )
        )
    }

    public static func texture(
        baseColorTexture: String,
        baseColor: AetherColor = .white,
        normalTexture: String? = nil,
        roughnessTexture: String? = nil,
        metallicTexture: String? = nil,
        roughness: AetherFloat = 0.5,
        metallic: AetherFloat = 0
    ) -> AetherMaterial {
        .surface(
            AetherMaterialSurface(
                baseColor: baseColor,
                baseColorTexture: baseColorTexture,
                normalTexture: normalTexture,
                roughnessTexture: roughnessTexture,
                metallicTexture: metallicTexture,
                roughness: roughness,
                metallic: metallic
            )
        )
    }

    // MARK: Standard keys

    public static let ae_default_object_key = "ae_default_object"
    public static let ae_default_panel_key = "ae_default_panel"
    public static let ae_default_button_key = "ae_default_button"
    public static let ae_default_quit_button_key = "ae_default_quit_button"
    public static let ae_default_text_key = "ae_default_text"
    public static let ae_default_text_background_key = "ae_default_text_background"
    public static let ae_default_control_off_key = "ae_default_control_off"
    public static let ae_default_control_on_key = "ae_default_control_on"
    public static let ae_default_progress_track_key = "ae_default_progress_track"
    public static let ae_default_progress_fill_key = "ae_default_progress_fill"
    public static let ae_default_image_key = "ae_default_image"

    // MARK: Standard references

    public static let defaultObject = AetherMaterial.named(ae_default_object_key)
    public static let defaultPanel = AetherMaterial.named(ae_default_panel_key)
    public static let defaultButton = AetherMaterial.named(ae_default_button_key)
    public static let defaultQuitButton = AetherMaterial.named(ae_default_quit_button_key)
    public static let defaultText = AetherMaterial.named(ae_default_text_key)
    public static let defaultTextBackground = AetherMaterial.named(ae_default_text_background_key)
    public static let defaultControlOff = AetherMaterial.named(ae_default_control_off_key)
    public static let defaultControlOn = AetherMaterial.named(ae_default_control_on_key)
    public static let defaultProgressTrack = AetherMaterial.named(ae_default_progress_track_key)
    public static let defaultProgressFill = AetherMaterial.named(ae_default_progress_fill_key)
    public static let defaultImage = AetherMaterial.named(ae_default_image_key)

    /// Re-registers every framework default. Applications may call this again
    /// to discard prior overrides and restore the AetherCircle appearance.
    public static func resetDefaults(
        in assetEngine: any AetherAssetEngine
    ) {
        assetEngine.registerMaterial(
            key: ae_default_object_key,
            material: .color(.white)
        )
        assetEngine.registerMaterial(
            key: ae_default_panel_key,
            material: .color(.black)
        )
        assetEngine.registerMaterial(
            key: ae_default_button_key,
            material: .color(.blue)
        )
        assetEngine.registerMaterial(
            key: ae_default_quit_button_key,
            material: .color(.red)
        )
        assetEngine.registerMaterial(
            key: ae_default_text_key,
            material: .color(.white)
        )
        assetEngine.registerMaterial(
            key: ae_default_text_background_key,
            material: .color(.clear)
        )
        assetEngine.registerMaterial(
            key: ae_default_control_off_key,
            material: .color(
                AetherColor(
                    red: 0.20,
                    green: 0.22,
                    blue: 0.27
                )
            )
        )
        assetEngine.registerMaterial(
            key: ae_default_control_on_key,
            material: .color(.green)
        )
        assetEngine.registerMaterial(
            key: ae_default_progress_track_key,
            material: .color(
                AetherColor(
                    red: 0.15,
                    green: 0.17,
                    blue: 0.21
                )
            )
        )
        assetEngine.registerMaterial(
            key: ae_default_progress_fill_key,
            material: .color(.blue)
        )
        assetEngine.registerMaterial(
            key: ae_default_image_key,
            material: .color(.white)
        )
    }
}
