//
//  AetherScene.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Collection of AetherObjects displayed together
//

// MARK: Import

import Foundation

// MARK: Class

/// Collection of AetherObjects displayed together.
public final class AetherScene: @unchecked Sendable {

    // MARK: Properties

    /// Unique identifier for the scene.
    public let id: UUID

    /// Human-readable name of the scene.
    public var name: String

    /// Objects contained in the scene.
    public private(set) var objects: [AetherBasicObject]

    // MARK: Initialization

    /// Creates a scene.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the scene.
    ///   - name: Human-readable name of the scene.
    ///   - objects: Initial objects contained in the scene.
    public init(
        id: UUID = UUID(),
        name: String = "",
        objects: [AetherBasicObject] = []
    ) {
        self.id = id
        self.name = name
        self.objects = objects
    }

    // MARK: Methods

    /// Adds an object to the scene.
    ///
    /// - Parameter object: Object to add.
    public func add(
        _ object: AetherBasicObject
    ) {
        objects.append(object)
    }

    /// Removes an object from the scene.
    ///
    /// - Parameter object: Object to remove.
    public func remove(
        _ object: AetherBasicObject
    ) {
        objects.removeAll {
            $0.id == object.id
        }
    }

    /// Removes all objects from the scene.
    public func removeAll() {
        objects.removeAll()
    }
}
