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

}

// MARK: Class

/// Place Holder Environment.
public final class AetherEnvironmentDummy: AetherEnvironmentEngine {
    
    public init() { }
    
    public var mode: AetherEnvironmentMode = .fullVR
}
