//
//  AetherHUDEngine.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Platform engine contract for presenting heads-up display content
//

// MARK: Protocol

/// Platform engine contract for presenting heads-up display content.
public protocol AetherHUDEngine: AetherEngine {

    /// Presents content in the platform-specific heads-up display.
    ///
    /// - Parameter content: Heads-up display content to present.
    func present(_ content: AetherHUDContent)

    /// Dismisses the currently presented heads-up display content.
    func dismiss()
}

// MARK: Class

/// Place Holder HUD.
public final class AetherHUDDummy: AetherHUDEngine {
    
    public init() { }
    
    public func present(_ content: AetherHUDContent) { }
    
    public func dismiss() { }
}
