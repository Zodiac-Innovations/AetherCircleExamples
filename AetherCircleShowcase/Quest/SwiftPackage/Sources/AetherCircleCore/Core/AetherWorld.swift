//
//  AetherWorld.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Complete collection of engines and capabilities used by an AetherCircle world
//

// MARK: Class

/// Complete collection of engines and capabilities supplied by an AetherCircle platform.
open class AetherWorld {
    
    /// initalizer
    public init(
        graphicEngine: any AetherGraphicEngine,
        environmentEngine: any AetherEnvironmentEngine,
        hudEngine: any AetherHUDEngine,
        clockEngine: any AetherClockEngine,
        assetEngine: any AetherAssetEngine,
        capabilities: AetherCapabilities,
        platform: any AetherPlatform = AetherPlatformDummy()
    ) {
        self.graphicEngine = graphicEngine
        self.environmentEngine = environmentEngine
        self.hudEngine = hudEngine
        self.clockEngine = clockEngine
        self.assetEngine = assetEngine
        self.capabilities = capabilities
        self.platform = platform
    }

    // MARK: Engines
    
    /// Graphic engine supplied by the platform.
    public let graphicEngine: any AetherGraphicEngine

    /// Environment engine supplied by the platform.
    public let environmentEngine: any AetherEnvironmentEngine

    /// Heads-up display engine supplied by the platform.
    public let hudEngine: any AetherHUDEngine

    /// Clock engine supplied by the platform.
    public let clockEngine: any AetherClockEngine
    
    /// Asset engine supplied by the platform.
    public let assetEngine: any AetherAssetEngine
    
    // MARK: Platform

    /// Application information and native services for the running platform.
    public let platform: any AetherPlatform

    // MARK: Information
    
    /// Capabilities of the enviroment
    public let capabilities: AetherCapabilities

}
