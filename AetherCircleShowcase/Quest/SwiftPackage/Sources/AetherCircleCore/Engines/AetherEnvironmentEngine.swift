//
//  AetherEnvironmentEngine.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Platform engine contract for controlling the immersive environment
//

// MARK: Protocol

/// Platform engine contract for controlling the immersive environment.
public protocol AetherEnvironmentEngine: AetherEngine {

    /// Current immersive environment mode represented by the platform engine.
    var mode: AetherEnvironmentMode { get set }

    /// Whether this platform can present the requested format (not a resource validity check).
    func supports(_ mode: AetherEnvironmentMode) -> Bool

}

// MARK: Class

/// Place Holder Environment.
public final class AetherEnvironmentDummy: AetherEnvironmentEngine {
    
    public init() { }
    
    public var mode: AetherEnvironmentMode = .blankVR
}


public extension AetherEnvironmentEngine {
    func supports(_ mode: AetherEnvironmentMode) -> Bool {
        switch mode {
        case .spatialPhotoFile, .spatialPhotoImage: return false
        default: return true
        }
    }
}
