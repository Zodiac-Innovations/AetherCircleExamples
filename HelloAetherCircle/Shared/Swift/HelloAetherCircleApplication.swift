import AetherCircleCore

public final class HelloAetherCircleApplication: AetherApplication {

    public override func start() {
        world.environmentEngine.mode = .passthrough
        let blueMaterialKey = "hello_blue"
        world.assetEngine.registerBaseColor(
            key: blueMaterialKey,
            color: .blue
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

        let scene = AetherScene(
            name: "Hello AetherCircle",
            objects: [cube]
        )
        world.graphicEngine.changeToScene(scene)
    }
}
