//
//  AetherApplication.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Base application class used by all AetherCircle applications
//

// MARK: Import

import Foundation

// MARK: Class

/// Base application class used by all AetherCircle applications.
open class AetherApplication {

    // MARK: Properties

    /// World with engines
    public let world: AetherWorld
    
    /// Unique identifier for the application instance.
    public let id: UUID

    /// Human-readable name of the application.
    public let name: String

    // MARK: Initialization

    /// Creates an AetherCircle application.
    ///
    /// - Parameters:
    ///   - name: Human-readable name of the application.
    ///   - id: Unique identifier for the application.
    public init(
        world: AetherWorld,
        name: String = "",
        id: UUID = UUID(),
    ) {
        self.world = world
        self.name = name
        self.id = id
    }

    // MARK: Lifecycle

    /// Starts the application after the world runtime is ready.
    open func start() {
    }

    /// Stops the application before the world runtime is released.
    open func stop() {
    }


}
