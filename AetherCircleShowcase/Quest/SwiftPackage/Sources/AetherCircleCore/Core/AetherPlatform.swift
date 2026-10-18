//
//  AetherPlatform.swift
//  AetherCircleCore
//
//  Cross-platform application, device, and native service access.
//

import Foundation

public enum AetherPlatformType: String, CaseIterable, Sendable, Hashable {
    case visionOS
    case quest
    case windows
    case unknown
}

public enum AetherDeviceType: String, CaseIterable, Sendable, Hashable {
    case headset
    case desktop
    case unknown
}

public enum AetherOrientation: String, CaseIterable, Sendable, Hashable {
    case landscape
    case portrait
    case none
}

public enum AetherResourceType: Sendable, Equatable, Hashable {
    case data
    case text
    case image
    case pdf
    case audio
    case custom(String)

    public var fileExtensions: [String] {
        switch self {
        case .data: return ["bin", "dat"]
        case .text: return ["txt"]
        case .image: return ["png", "jpg", "jpeg"]
        case .pdf: return ["pdf"]
        case .audio: return ["wav", "mp3", "m4a"]
        case .custom(let value):
            let value = value.trimmingCharacters(in: CharacterSet(charactersIn: ".")).lowercased()
            return value.isEmpty ? [] : [value]
        }
    }
}

public enum AetherPlaybackResult: Sendable, Equatable {
    case finished
    case cancelled
    case failed
}

public typealias AetherPlaybackCompletion = @Sendable (AetherPlaybackResult) -> Void
public typealias AetherBannerCompletion = @Sendable () -> Void

/// Application information and native services supplied by the running platform.
///
/// Every operation that may be unavailable has a corresponding `can...` property.
/// Unsupported operations return `false` or `nil` without side effects.
public protocol AetherPlatform: AnyObject, Sendable {
    // Application and device information
    var canRetrieveAppIcon: Bool { get }
    func appIconData() -> Data?
    var appName: String { get }
    var appIdentifier: String { get }
    var appCopyright: String? { get }
    var appVersion: String { get }
    var appBuild: String { get }
    var platformName: String { get }
    var platformVersion: String { get }
    var platformAPILevel: Int? { get }
    var deviceModel: String { get }
    var deviceManufacturer: String { get }
    var localeIdentifier: String { get }
    var languageCode: String { get }
    var timeZoneIdentifier: String { get }
    var appearanceMode: String { get }
    var deviceClass: String { get }
    var platformType: AetherPlatformType { get }
    var deviceType: AetherDeviceType { get }
    var orientation: AetherOrientation { get }

    /// Scripts execute on the host's frame thread while this async call waits.
    /// Returns true after successful completion; failures throw.
    var canRunAutomation: Bool { get }
    @discardableResult
    func runScript(_ script: AetherAutomationScript) async throws -> Bool
    @discardableResult
    func runTextScript(_ text: String, turnsOffInteraction: Bool) async throws -> Bool

    // App interaction. Call on the platform's UI/runtime thread.
    /// Whether this host implements the app interaction gate.
    @MainActor var canSetUserInteractionEnabled: Bool { get }
    @MainActor var isUserInteractionEnabled: Bool { get }
    /// Gates app-owned controller, hand, targeting, selection, and touch input.
    /// Does not disable system controls, safety features, or head tracking.
    /// Remains in effect across scene changes until explicitly changed.
    @MainActor @discardableResult
    func setUserInteractionEnabled(_ enabled: Bool) -> Bool

    // External actions
    func canLaunchURL(_ url: URL) -> Bool
    @discardableResult func launchURL(_ url: URL) -> Bool
    var canComposeEmail: Bool { get }
    @discardableResult func composeEmail(to: [String], subject: String?, body: String?) -> Bool
    var canComposeMessage: Bool { get }
    @discardableResult func composeMessage(to: [String], body: String?) -> Bool
    var canDialPhone: Bool { get }
    @discardableResult func dialPhone(_ number: String) -> Bool
    var canOpenMap: Bool { get }
    @discardableResult func openMap(latitude: Double, longitude: Double, label: String?) -> Bool
    @discardableResult func openMap(address: String) -> Bool
    @discardableResult func searchMap(_ query: String) -> Bool
    var canOpenDirections: Bool { get }
    @discardableResult func openDirections(toLatitude latitude: Double, longitude: Double, label: String?) -> Bool
    @discardableResult func openDirections(toAddress address: String) -> Bool
    var canOpenApplicationSettings: Bool { get }
    @discardableResult func openApplicationSettings() -> Bool
    var canQuitApp: Bool { get }
    @discardableResult func quitApp() -> Bool

    // Bundled resources
    var canRetrieveResources: Bool { get }
    var canOpenResources: Bool { get }
    func resourceExists(name: String, type: AetherResourceType) -> Bool
    func resourceRetrieve(name: String, type: AetherResourceType) -> Data?
    @discardableResult func resourceOpen(name: String, type: AetherResourceType) -> Bool

    // Persistent and secure storage
    var canUsePersistentStorage: Bool { get }
    @discardableResult func setPersistentData(_ data: Data, forKey key: String) -> Bool
    func persistentData(forKey key: String) -> Data?
    @discardableResult func removePersistentValue(forKey key: String) -> Bool
    var canUseSecureStorage: Bool { get }
    @discardableResult func setSecureData(_ data: Data, forKey key: String) -> Bool
    func secureData(forKey key: String) -> Data?
    @discardableResult func removeSecureValue(forKey key: String) -> Bool

    // Sharing
    var canShareData: Bool { get }
    var canShareText: Bool { get }
    var canShareImage: Bool { get }
    var canSharePDF: Bool { get }
    @discardableResult func shareData(_ data: Data, filename: String, mimeType: String) -> Bool
    @discardableResult func shareText(_ text: String) -> Bool
    @discardableResult func shareResource(name: String, type: AetherResourceType) -> Bool

    // Audio and speech
    var canPlaySound: Bool { get }
    @discardableResult func playSound(
        _ data: Data,
        fileExtension: String,
        speed: Double,
        completion: @escaping AetherPlaybackCompletion
    ) -> Bool
    func cancelSound()
    var canSpeakText: Bool { get }
    @discardableResult func speakText(
        _ text: String,
        speed: Double,
        completion: @escaping AetherPlaybackCompletion
    ) -> Bool
    func cancelSpeech()

    // Banner and printing
    var canDisplayBanner: Bool { get }
    @discardableResult func banner(_ text: String, completion: @escaping AetherBannerCompletion) -> Bool
    var canPrintText: Bool { get }
    @discardableResult func printText(_ text: String, monospaced: Bool) -> Bool
    var canPrintImage: Bool { get }
    @discardableResult func printImage(_ data: Data, sizeToFit: Bool) -> Bool
}

public extension AetherPlatform {
    var canRunAutomation: Bool { false }
    @discardableResult
    func runScript(_ script: AetherAutomationScript) async throws -> Bool {
        throw AetherAutomationError.unsupported
    }
    @discardableResult
    func runTextScript(_ text: String, turnsOffInteraction: Bool = true) async throws -> Bool {
        let script = try AetherAutomationScript.make(
            text: text, turnsOffInteraction: turnsOffInteraction
        )
        return try await runScript(script)
    }

    @MainActor var canSetUserInteractionEnabled: Bool { false }
    @MainActor var isUserInteractionEnabled: Bool { true }
    @MainActor @discardableResult
    func setUserInteractionEnabled(_ enabled: Bool) -> Bool { false }

    var canRetrieveAppIcon: Bool { false }
    func appIconData() -> Data? { nil }
    var appName: String { "Application" }
    var appIdentifier: String { "" }
    var appCopyright: String? { nil }
    var appVersion: String { "0.0" }
    var appBuild: String { "0" }
    var appVersionBuild: String { "\(appVersion) (\(appBuild))" }
    var platformName: String { "Unknown" }
    var platformVersion: String { "Unknown" }
    var platformAPILevel: Int? { nil }
    var deviceModel: String { "Unknown" }
    var deviceManufacturer: String { "Unknown" }
    var localeIdentifier: String { Locale.current.identifier }
    var languageCode: String { Locale.preferredLanguages.first ?? "Unknown" }
    var timeZoneIdentifier: String { TimeZone.current.identifier }
    var appearanceMode: String { "unspecified" }
    var deviceClass: String { "unknown" }
    var platformType: AetherPlatformType { .unknown }
    var deviceType: AetherDeviceType { .unknown }
    var orientation: AetherOrientation { .none }

    func canLaunchURL(_ url: URL) -> Bool { false }
    @discardableResult func launchURL(_ url: URL) -> Bool { false }
    var canComposeEmail: Bool { false }
    @discardableResult func composeEmail(to: [String], subject: String? = nil, body: String? = nil) -> Bool { false }
    var canComposeMessage: Bool { false }
    @discardableResult func composeMessage(to: [String], body: String? = nil) -> Bool { false }
    var canDialPhone: Bool { false }
    @discardableResult func dialPhone(_ number: String) -> Bool { false }
    var canOpenMap: Bool { false }
    @discardableResult func openMap(latitude: Double, longitude: Double, label: String? = nil) -> Bool { false }
    @discardableResult func openMap(address: String) -> Bool { false }
    @discardableResult func searchMap(_ query: String) -> Bool { false }
    var canOpenDirections: Bool { false }
    @discardableResult func openDirections(toLatitude latitude: Double, longitude: Double, label: String? = nil) -> Bool { false }
    @discardableResult func openDirections(toAddress address: String) -> Bool { false }
    var canOpenApplicationSettings: Bool { false }
    @discardableResult func openApplicationSettings() -> Bool { false }
    var canQuitApp: Bool { false }
    @discardableResult func quitApp() -> Bool { false }

    var canRetrieveResources: Bool { false }
    var canOpenResources: Bool { false }
    func resourceExists(name: String, type: AetherResourceType) -> Bool { false }
    func resourceRetrieve(name: String, type: AetherResourceType) -> Data? { nil }
    @discardableResult func resourceOpen(name: String, type: AetherResourceType) -> Bool { false }

    var canUsePersistentStorage: Bool { true }
    @discardableResult
    func setPersistentData(_ data: Data, forKey key: String) -> Bool {
        UserDefaults.standard.set(data, forKey: key)
        return true
    }
    func persistentData(forKey key: String) -> Data? {
        UserDefaults.standard.data(forKey: key)
    }
    @discardableResult
    func removePersistentValue(forKey key: String) -> Bool {
        UserDefaults.standard.removeObject(forKey: key)
        return true
    }
    @discardableResult
    func setPersistentString(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return setPersistentData(data, forKey: key)
    }
    func persistentString(forKey key: String) -> String? {
        guard let data = persistentData(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    @discardableResult
    func setPersistentInteger(_ value: Int, forKey key: String) -> Bool {
        setPersistentString(String(value), forKey: key)
    }
    func persistentInteger(forKey key: String) -> Int? {
        persistentString(forKey: key).flatMap(Int.init)
    }

    var canUseSecureStorage: Bool { false }
    @discardableResult func setSecureData(_ data: Data, forKey key: String) -> Bool { false }
    func secureData(forKey key: String) -> Data? { nil }
    @discardableResult func removeSecureValue(forKey key: String) -> Bool { false }
    @discardableResult
    func setSecureString(_ value: String, forKey key: String) -> Bool {
        guard canUseSecureStorage, let data = value.data(using: .utf8) else { return false }
        return setSecureData(data, forKey: key)
    }
    func secureString(forKey key: String) -> String? {
        guard canUseSecureStorage, let data = secureData(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var canShareData: Bool { false }
    var canShareText: Bool { false }
    var canShareImage: Bool { false }
    var canSharePDF: Bool { false }
    @discardableResult func shareData(_ data: Data, filename: String = "SharedData.bin", mimeType: String = "application/octet-stream") -> Bool { false }
    @discardableResult func shareText(_ text: String) -> Bool { false }
    @discardableResult func shareResource(name: String, type: AetherResourceType) -> Bool { false }

    var canPlaySound: Bool { false }
    @discardableResult
    func playSound(_ data: Data, fileExtension: String, speed: Double = 1.0, completion: @escaping AetherPlaybackCompletion = { _ in }) -> Bool { false }
    func cancelSound() {}
    var canSpeakText: Bool { false }
    @discardableResult
    func speakText(_ text: String, speed: Double = 1.0, completion: @escaping AetherPlaybackCompletion = { _ in }) -> Bool { false }
    func cancelSpeech() {}

    var canDisplayBanner: Bool { false }
    @discardableResult func banner(_ text: String, completion: @escaping AetherBannerCompletion = {}) -> Bool { false }
    var canPrintText: Bool { false }
    @discardableResult func printText(_ text: String, monospaced: Bool = false) -> Bool { false }
    var canPrintImage: Bool { false }
    @discardableResult func printImage(_ data: Data, sizeToFit: Bool = true) -> Bool { false }

    func textExists(name: String) -> Bool { resourceExists(name: name, type: .text) }
    func textRetrieve(name: String) -> String? {
        guard canRetrieveResources,
              let data = resourceRetrieve(name: name, type: .text) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func imageRetrieve(name: String) -> Data? {
        guard canRetrieveResources else { return nil }
        return resourceRetrieve(name: name, type: .image)
    }
    func pdfRetrieve(name: String) -> Data? {
        guard canRetrieveResources else { return nil }
        return resourceRetrieve(name: name, type: .pdf)
    }
    @discardableResult
    func playSoundFile(
        _ filename: String,
        speed: Double = 1.0,
        completion: @escaping AetherPlaybackCompletion = { _ in }
    ) -> Bool {
        let url = URL(fileURLWithPath: filename)
        let ext = url.pathExtension.lowercased()
        let name = url.deletingPathExtension().lastPathComponent
        guard canPlaySound,
              ["wav", "mp3", "m4a"].contains(ext),
              let data = resourceRetrieve(name: name, type: .audio) else { return false }
        return playSound(data, fileExtension: ext, speed: speed, completion: completion)
    }
}

/// Safe fallback used until a host installs its native platform implementation.
public final class AetherPlatformDummy: AetherPlatform, @unchecked Sendable {
    public init() {}
}

