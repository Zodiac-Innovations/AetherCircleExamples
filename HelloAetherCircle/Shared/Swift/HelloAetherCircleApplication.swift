import AetherCircleCore

public final class HelloAetherCircleApplication: AetherApplication {

    public override func start() {
        world.environmentEngine.mode = .passthrough
        let blueMaterialKey = "hello_blue"
        world.assetEngine.registerBaseColor(
            key: blueMaterialKey,
            color: .blue
        )

        let title = AetherTextObject(
            name: "Title",
            text: "Hello AetherCircle",
            characterHeight: 0.16,
            extrusionDepth: 0.02,
            position: AetherPosition3D(
                x: 0,
                y: 1.75,
                z: -1.5
            )
        )

        let cube = AetherObject.cube(
            name: "Hello Cube",
            size: 0.25,
            material: .named(blueMaterialKey)
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

        let quit = AetherQuitButtonObject(
            position: AetherPosition3D(
                x: 0,
                y: 0.95,
                z: -1.5
            ),
            targetAppearance: .goldenGlow,
            quitAction: {
                self.quitApp()
            }
        )

        let scene = AetherScene(
            name: "Hello AetherCircle",
            objects: [
                title,
                cube,
                quit,
            ]
        )
        world.graphicEngine.changeToScene(scene)
    }

    private func quitApp() {
        if world.platform.canQuitApp {
            world.platform.quitApp()
        }
    }
}

