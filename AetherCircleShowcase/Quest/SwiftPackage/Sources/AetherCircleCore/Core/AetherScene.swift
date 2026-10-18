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

public extension AetherScene {
    /// Finds exactly one visible element, including visible composite descendants.
    func findObject(_ target: AetherAutomationTarget) throws -> AetherBasicObject {
        var matches: [AetherBasicObject] = []
        func visit(_ objects: [AetherBasicObject]) {
            for object in objects where object.isVisible {
                let matchesTarget: Bool
                switch target {
                case .id(let value): matchesTarget = object.id == value
                case .tag(let value): matchesTarget = object.tag == value
                case .name(let value): matchesTarget = object.name == value
                case .autoID(let value): matchesTarget = !value.isEmpty && object.autoID == value
                case .title(let value):
                    if let button = object as? AetherButtonObject {
                        matchesTarget = button.title == value
                    } else if let panel = object as? AetherPanelObject {
                        matchesTarget = panel.title == value
                    } else { matchesTarget = false }
                }
                if matchesTarget { matches.append(object) }
                if let composite = object as? AetherCompositeObject { visit(composite.children) }
            }
        }
        visit(objects)
        guard !matches.isEmpty else { throw AetherAutomationError.targetNotFound }
        guard matches.count == 1 else { throw AetherAutomationError.ambiguousTarget }
        return matches[0]
    }

    /// Performs the same activation action used by platform input.
    func tapObject(_ target: AetherAutomationTarget) throws {
        let object = try findObject(target)
        guard let action = object.config?.activateAction else {
            throw AetherAutomationError.cannotActivate
        }
        action()
    }

    /// Reads the object's automation value through the shared interface.
    func objectValue(_ target: AetherAutomationTarget) throws -> String {
        try findObject(target).aetherObjectValue()
    }
}
