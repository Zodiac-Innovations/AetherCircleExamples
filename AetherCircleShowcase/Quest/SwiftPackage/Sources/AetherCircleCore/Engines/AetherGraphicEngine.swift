//
//  AetherGraphicEngine.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Platform engine contract for presenting and synchronizing AetherCircle scenes
//

// MARK: Protocol

/// Platform engine contract for presenting and synchronizing AetherCircle scenes.
public protocol AetherGraphicEngine: AetherEngine {
    
    /// Remove old scene and replace with a scene on the current platform.
    /// Use specified effect.
    ///
    /// - Parameter scene: Scene to present.
    ///   - effect: Effect to use to add.
    func changeToScene(
        _ scene: AetherScene,
        effect: AetherEffect
    )
    
    /// Adds an object to the native representation of a scene.
    /// Use specified effect.
    ///
    /// - Parameters:
    ///   - object: Object to add.
    ///   - effect: Effect to use to add.
    func changeAddObject(
        _ object: AetherObject,
        effect: AetherEffect
    )
    
    /// Removes an object from the native representation of a scene.
    /// Use specified effect.
    ///
    /// - Parameters:
    ///   - object: Object to remove.
    ///   - effect: Effect to use to remove.
    func changeRemoveObject(
        _ object: AetherObject,
        effect: AetherEffect
    )
    
}

// MARK: Extension

public extension AetherGraphicEngine {
    
    /// Remove old scene and replace with a scene on the current platform, with no effect.
    ///
    /// - Parameters:
    ///   - scene: Scene to present.
    func changeToScene(_ scene: AetherScene) {
        changeToScene(scene, effect: .none)
    }
    
    /// Adds an object to the native representation of a scene, with no effect.
    ///
    /// - Parameters:
    ///   - object: Object to add.
    func changeAddObject(_ object: AetherObject) {
        changeAddObject(object, effect: .none)
    }
    
    /// Removes an object from the native representation of a scene, with no effect.
    ///
    /// - Parameters:
    ///   - object: Object to remove.
    func changeRemoveObject(_ object: AetherObject) {
        changeRemoveObject(object, effect: .none)
    }
    
}

// MARK: Class

/// Place Holder Graphic.
public final class AetherGraphicDummy: AetherGraphicEngine {
    public init() { }
    
    public func changeToScene(_ scene: AetherScene, effect: AetherEffect) { }

    public func changeAddObject(_ object: AetherObject, effect: AetherEffect) { }

    public func changeRemoveObject(_ object: AetherObject, effect: AetherEffect) { }
}
