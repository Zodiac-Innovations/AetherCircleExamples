//
//  AetherDemoHello.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/11/26.
//

// MARK: Application
// MARK: Core Application

/// Simple AetherCircle application that displays a rotating blue cube.
nonisolated public final class AetherDemoHello: AetherApplication {

    // MARK: Lifecycle

    /// Creates and presents the initial Hello AetherCircle scene.
    public override func start() {
        world.environmentEngine.mode = .passthrough

        let cube = AetherObject.cube(
            name: "Hello Cube",
            size: 0.25,
            material: .color(.blue)
        )
        cube.position = AetherPosition3D(
            x: 0,
            y: 1.35,
            z: -1.5
        )
        cube.rotationRate = AetherRotationRate3D(
            x: 0.35,
            y: 0.7,
            z: 0.15
        )

        let scene = AetherScene(
            name: "Hello AetherCircle",
            objects: [cube]
        )
        world.graphicEngine.changeToScene(scene)
    }
}
