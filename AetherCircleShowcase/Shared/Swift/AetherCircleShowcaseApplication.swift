import AetherCircleCore
import Foundation
import Dispatch
#if os(visionOS)
import ImageIO
import UniformTypeIdentifiers
#endif

public final class AetherCircleShowcaseApplication: AetherApplication {

    private enum MaterialKey {
        static let red = "showcase_red"
        static let green = "showcase_green"
        static let blue = "showcase_blue"
        static let yellow = "showcase_yellow"
        static let orange = "showcase_orange"
        static let purple = "showcase_purple"
        static let cyan = "showcase_cyan"
        static let pink = "showcase_pink"
        static let agedBrass = "showcase_aged_brass"
        static let darkWalnut = "showcase_dark_walnut"
        static let blueGranite = "showcase_blue_granite"
        static let carraraMarble = "showcase_carrara_marble"
        static let brushedSteel = "showcase_brushed_steel"
        static let verdigrisCopper = "showcase_verdigris_copper"
        static let carbonFiber = "showcase_carbon_fiber"
        static let sandstone = "showcase_sandstone"
        static let redLeather = "showcase_red_leather"
        static let blueFabric = "showcase_blue_fabric"
        static let glacierIce = "showcase_glacier_ice"
        static let lavaRock = "showcase_lava_rock"
        static let greenMoss = "showcase_green_moss"
        static let cobaltCeramic = "showcase_cobalt_ceramic"
        static let scifiPanel = "showcase_scifi_panel"
    }

    private enum Material {
        static let red = AetherMaterial.named(MaterialKey.red)
        static let green = AetherMaterial.named(MaterialKey.green)
        static let blue = AetherMaterial.named(MaterialKey.blue)
        static let yellow = AetherMaterial.named(MaterialKey.yellow)
        static let orange = AetherMaterial.named(MaterialKey.orange)
        static let purple = AetherMaterial.named(MaterialKey.purple)
        static let cyan = AetherMaterial.named(MaterialKey.cyan)
        static let pink = AetherMaterial.named(MaterialKey.pink)
        static let agedBrass = AetherMaterial.named(MaterialKey.agedBrass)
        static let darkWalnut = AetherMaterial.named(MaterialKey.darkWalnut)
        static let blueGranite = AetherMaterial.named(MaterialKey.blueGranite)
        static let carraraMarble = AetherMaterial.named(MaterialKey.carraraMarble)
        static let brushedSteel = AetherMaterial.named(MaterialKey.brushedSteel)
        static let verdigrisCopper = AetherMaterial.named(MaterialKey.verdigrisCopper)
        static let carbonFiber = AetherMaterial.named(MaterialKey.carbonFiber)
        static let sandstone = AetherMaterial.named(MaterialKey.sandstone)
        static let redLeather = AetherMaterial.named(MaterialKey.redLeather)
        static let blueFabric = AetherMaterial.named(MaterialKey.blueFabric)
        static let glacierIce = AetherMaterial.named(MaterialKey.glacierIce)
        static let lavaRock = AetherMaterial.named(MaterialKey.lavaRock)
        static let greenMoss = AetherMaterial.named(MaterialKey.greenMoss)
        static let cobaltCeramic = AetherMaterial.named(MaterialKey.cobaltCeramic)
        static let scifiPanel = AetherMaterial.named(MaterialKey.scifiPanel)
        static let white = AetherMaterial.defaultText
        static let panel = AetherMaterial.defaultPanel
        static let button = AetherMaterial.defaultButton
    }

    /// Shared navigation action used by Home buttons throughout the Showcase.
    private(set) lazy var homeAction = AetherTitleAction("Home") { [weak self] in
        self?.showHomeScene()
    }

    private let sceneDepth: AetherFloat = -1.7
    private var environmentDownloadTask: Task<Void, Never>?

    public override func stop() {
        environmentDownloadTask?.cancel()
        environmentDownloadTask = nil
    }

    public override func start() {
        world.environmentEngine.mode = .passthrough
        registerMaterials()
        registerEnvironmentImages()
        showHomeScene()
    }

    private enum EnvironmentImageKey {
        static let spatial = "showcase.environment.spatial"
        static let mono = "showcase.environment.mono"
        static let embeddedMono = "showcase.environment.kiara"
    }

    /// One registered example is embedded; the other must arrive over HTTPS.
    private func registerEnvironmentImages() {
        #if os(visionOS)
        if #available(visionOS 26.0, *), world.platform.canDecodeStereoHEIC { registerSpatialDemo() }
        #endif
        for name in ["yosemite-01", "yosemite-02"] {
            if let data = world.platform.resourceRetrieve(name: "environment-" + name, type: .image) {
                world.assetEngine.registerImage(key: "showcase.gallery." + name, data: data)
            } else {
                print("Showcase: missing bundled image environment-\(name).jpg")
            }
        }
        if let data = world.platform.resourceRetrieve(name: "environment-kiara-360", type: .image) {
            world.assetEngine.registerImage(key: EnvironmentImageKey.embeddedMono, data: data)
        } else {
            print("Showcase: missing bundled image environment-kiara-360.jpg")
        }
        environmentDownloadTask?.cancel()
        let registry = world.assetEngine.imageRegistry
        registry.remove(key: EnvironmentImageKey.mono)
        guard let url = URL(string: "https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/spruit_sunrise.jpg") else { return }
        environmentDownloadTask = Task {
            do {
                try await registry.register(key: EnvironmentImageKey.mono, from: url)
                print("Showcase: internet panorama downloaded and registered.")
            } catch is CancellationError {
                // The app stopped before the download completed.
            } catch {
                if !Task.isCancelled { print("Showcase: internet panorama download failed: \(error)") }
            }
        }
    }

    private func registerMaterials() {
        world.assetEngine.resetDefaultMaterials()

        let colors: [(String, AetherColor)] = [
            (MaterialKey.red, .red),
            (MaterialKey.green, .green),
            (MaterialKey.blue, .blue),
            (
                MaterialKey.yellow,
                AetherColor(red: 1.0, green: 0.82, blue: 0.12, alpha: 1.0)
            ),
            (
                MaterialKey.orange,
                AetherColor(red: 1.0, green: 0.42, blue: 0.08, alpha: 1.0)
            ),
            (
                MaterialKey.purple,
                AetherColor(red: 0.58, green: 0.24, blue: 0.90, alpha: 1.0)
            ),
            (
                MaterialKey.cyan,
                AetherColor(red: 0.10, green: 0.82, blue: 0.92, alpha: 1.0)
            ),
            (
                MaterialKey.pink,
                AetherColor(red: 0.95, green: 0.25, blue: 0.58, alpha: 1.0)
            ),
        ]

        for (material, color) in colors {
            world.assetEngine.registerBaseColor(
                key: material,
                color: color
            )
        }

        world.assetEngine.registerMaterial(
            key: MaterialKey.agedBrass,
            material: .texture(
                baseColorTexture: "aged-brass-basecolor.jpg",
                roughness: 0.28,
                metallic: 0.85
            )
        )
        world.assetEngine.registerMaterial(
            key: MaterialKey.darkWalnut,
            material: .texture(
                baseColorTexture: "dark-walnut-basecolor.jpg",
                roughness: 0.62,
                metallic: 0
            )
        )
        world.assetEngine.registerMaterial(
            key: MaterialKey.blueGranite,
            material: .texture(
                baseColorTexture: "blue-granite-basecolor.jpg",
                roughness: 0.82,
                metallic: 0
            )
        )

        let texturedMaterials: [(
            key: String,
            file: String,
            roughness: AetherFloat,
            metallic: AetherFloat
        )] = [
            (MaterialKey.carraraMarble, "carrara-marble-basecolor.jpg", 0.36, 0),
            (MaterialKey.brushedSteel, "brushed-steel-basecolor.jpg", 0.22, 0.90),
            (MaterialKey.verdigrisCopper, "verdigris-copper-basecolor.jpg", 0.48, 0.65),
            (MaterialKey.carbonFiber, "carbon-fiber-basecolor.jpg", 0.30, 0.18),
            (MaterialKey.sandstone, "sandstone-basecolor.jpg", 0.90, 0),
            (MaterialKey.redLeather, "red-leather-basecolor.jpg", 0.58, 0),
            (MaterialKey.blueFabric, "blue-fabric-basecolor.jpg", 0.92, 0),
            (MaterialKey.glacierIce, "glacier-ice-basecolor.jpg", 0.12, 0),
            (MaterialKey.lavaRock, "lava-rock-basecolor.jpg", 0.78, 0),
            (MaterialKey.greenMoss, "green-moss-basecolor.jpg", 0.96, 0),
            (MaterialKey.cobaltCeramic, "cobalt-ceramic-basecolor.jpg", 0.14, 0),
            (MaterialKey.scifiPanel, "scifi-panel-basecolor.jpg", 0.26, 0.72),
        ]

        for material in texturedMaterials {
            world.assetEngine.registerMaterial(
                key: material.key,
                material: .texture(
                    baseColorTexture: material.file,
                    roughness: material.roughness,
                    metallic: material.metallic
                )
            )
        }
    }

    private func showHomeScene() {
        let menu = AetherListButton(
            [
                AetherTitleAction("Materials") { [weak self] in self?.showMaterialsScene() },
                AetherTitleAction("Environment A") { [weak self] in self?.showEnvironmentScene() },
                AetherTitleAction("Environment B") { [weak self] in self?.showEnvironmentScene(isMedia: true) },
                AetherTitleAction("Primitive Objects") { [weak self] in self?.showPrimitiveObjectsScene() },
                AetherTitleAction("Panel Objects") { [weak self] in self?.showPanelObjectsScene() },
                AetherTitleAction("Automation") { [weak self] in self?.showAutomationScene() },
            ],
            name: "Showcase Menu",
            autoID: "showcase.menu",
            size: AetherSize3D(x: 0.70, y: 0.16, z: 0.04),
            material: Material.button,
            textMaterial: Material.white,
            position: .zero,
            targetAppearance: .goldenGlow,
            rowSpacing: 0.06
        )
        // Preserve the stable identifiers used by all three automation examples.
        let menuIDs = ["materials", "environment", "environment-b", "primitives", "panels", "automation"]
        for (button, menuID) in zip(menu.buttons, menuIDs) {
            button.autoID = "showcase." + menuID
        }

        let quit = AetherQuitButtonObject(
            name: "Quit",
            flavor: .doubleSided,
            size: AetherSize3D(
                x: 0.34,
                y: 0.13,
                z: 0.04
            ),
            material: Material.red,
            textMaterial: Material.white,
            panelMaterial: Material.panel,
            panelButtonMaterial: Material.button,
            position: AetherPosition3D(
                x: 0,
                y: -1.12,
                z: 0
            ),
            targetAppearance: .goldenGlow,
            quitAction: {
                self.quitApp()
            }
        )
        quit.button.autoID = "showcase.quit"
        quit.button.rotationRate = AetherRotationRate3D(
            x: 0,
            y: 0.55,
            z: 0
        )

        let arrangement = AetherBaseArrangement(
            title: "AetherCircle Showcase",
            closeAction: { [weak self] in self?.quitApp() },
            elements: [menu, quit],
            width: 2.8,
            contentHeight: 1.22,
            position: AetherPosition3D(x: 0, y: 2.10, z: sceneDepth),
            name: "Home Arrangement",
            autoID: "showcase.home-arrangement",
            barFlavor: .floatingTitle
        )

        world.graphicEngine.changeToScene(
            AetherScene(
                name: "Showcase Home",
                objects: [
                    arrangement,
                ]
            )
        )
    }

    /// Environment changes persist when navigating to other Showcase sections.
    private func showEnvironmentScene(isMedia: Bool = false) {
        var choices: [(String, String, AetherEnvironmentMode)] = [
            ("Passthrough", "passthrough", .passthrough),
            ("Teal", "teal", .materialVR(.color(AetherColor(red: 0, green: 0.5, blue: 0.5)))),
            ("Black", "black", .materialVR(.color(.black))),
            ("White", "white", .materialVR(.color(.white))),
        ]
        let patterns: [(String, AetherMaterial)] = [
            ("Dark Walnut", Material.darkWalnut),
            ("Blue Granite", Material.blueGranite),
            ("Carbon Fiber", Material.carbonFiber),
            ("Blue Fabric", Material.blueFabric),
            ("Carrara Marble", Material.carraraMarble),
            ("Sci-Fi Panel", Material.scifiPanel),
        ]
        let shuffledPatterns = patterns.shuffled()
        let floorPatterns = Array(shuffledPatterns.dropFirst(3))
        for (index, pattern) in shuffledPatterns.prefix(3).enumerated() {
            choices.append((pattern.0, "pattern-\(index + 1)", .materialVR(pattern.1)))
        }
        choices.append(("Video 360 NASA", "video-360", .video360File("environment-nasa-360.mp4")))
        choices.append(("File 360 Mono", "file-mono", .image360File("environment-venice-360.jpg")))
        choices.append(("File Stereo TB", "file-stereo", .image360File("environment-stereo-360-tb.jpg", layout: .stereoTopBottom)))
        choices.append(("Internet 360 Mono", "image-mono", .image360Image(EnvironmentImageKey.mono)))
        choices.append(("Image 360 Kiara", "image-stereo", .image360Image(EnvironmentImageKey.embeddedMono)))
        choices.append(("Panorama Auto", "panorama-auto", .panoramaFile("environment-hahneberg-panorama.jpg")))
        choices.append(("Panorama Override", "panorama-override", .panoramaFile("environment-campus-panorama.jpg", horizontalDegrees: 180)))
        choices.append(("Apple Spatial Photo", "spatial-photo", .spatialPhotoImage(EnvironmentImageKey.spatial)))
        choices.append(("Yosemite Files", "gallery-files", .photo2DFiles(["environment-half-dome.jpg", "environment-el-capitan.jpg"], material: .color(.black))))
        choices.append(("Yosemite Images", "gallery-images", .photo2DImages(["showcase.gallery.yosemite-01", "showcase.gallery.yosemite-02"], material: .color(AetherColor(red: 0, green: 0.35, blue: 0.35, alpha: 1)))))
        choices.append(("Gallery 8", "gallery-eight", .photo2DFiles((3...10).map { String(format: "environment-yosemite-%02d.jpg", $0) }, material: .color(.black))))
        choices.append(("Floor + Sky", "floor-material", .floorMaterial(floor: floorPatterns[0].1, sky: Material.blue)))
        choices.append(("Cyber Floor · Cyan", "cyber-floor", .cyberFloor(
            sky: .color(AetherColor(red: 0.015, green: 0.025, blue: 0.08)),
            floor: .color(AetherColor(red: 0.025, green: 0.035, blue: 0.055)),
            lines: Material.cyan, squareWidth: 1000)))
        choices.append(("Cyber Floor · Silver", "cyber-floor-silver", .cyberFloor(
            sky: .color(.white), floor: .color(.black),
            lines: .surface(AetherMaterialSurface(
                baseColor: AetherColor(red: 0.75, green: 0.75, blue: 0.75),
                roughness: 0.3, metallic: 0.8)),
            squareWidth: 1000)))
        // Millimeters: a 5 x 3 x 6 metre room with a matching-wall convenience call.
        choices.append(("Room · Matching Walls", "room-matching", .room(
            width: 5000, height: 3000, depth: 6000,
            floor: Material.darkWalnut, walls: Material.sandstone, ceiling: .color(.white))))
        // A second room exercises an independent material on every surface.
        let studio = AetherRoom(width: 6000, height: 3500, depth: 7000)
        choices.append(("Room · Six Materials", "room-six", .room(studio, materials: AetherRoomMaterials(
            floor: Material.carraraMarble, front: Material.blueFabric, right: Material.darkWalnut,
            back: Material.greenMoss, left: Material.blueGranite, ceiling: Material.brushedSteel))))
        choices.append(("Grass + Day Sky", "sky-grass", .skyFloor(
            skyFile: "environment-day-sky.jpg",
            floor: .texture(baseColorTexture: "environment-grass-floor.jpg", roughness: 0.95))))
        choices.append(("Sand + Sunset", "sky-sand", .skyFloor(
            skyFile: "environment-sunset-sky.jpg",
            floor: .texture(baseColorTexture: "environment-sand-floor.jpg", roughness: 0.9))))
        // A: materials and walkable spaces. B: recorded media and photo galleries.
        choices = choices.filter { choice in
            switch choice.2 {
            case .passthrough, .blankVR, .materialVR, .floorMaterial, .cyberFloor, .room, .skyFloor:
                return !isMedia
            default:
                return isMedia
            }
        }
        var objects: [AetherBasicObject] = []
        for (index, choice) in choices.enumerated() {
            let button = AetherButtonObject(
                name: choice.0 + " Environment Button",
                autoID: "showcase.environment." + choice.1,
                title: choice.0,
                size: AetherSize3D(x: 0.78, y: 0.15, z: 0.04),
                sizing: .fitTextToButton,
                material: Material.button, textMaterial: Material.white,
                position: AetherPosition3D(x: AetherFloat(index % 3 - 1) * 0.86, y: 1.68 - AetherFloat(index / 3) * 0.23, z: sceneDepth),
                targetAppearance: .goldenGlow,
                action: {
                    if choice.1 == "image-mono",
                       self.world.assetEngine.registeredImage(for: EnvironmentImageKey.mono) == nil { return }
                    if choice.1 == "floor-material" {
                        let floor = floorPatterns.randomElement()?.1 ?? floorPatterns[0].1
                        let sky = [Material.red, Material.green, Material.blue, Material.yellow,
                                   Material.orange, Material.purple, Material.cyan, Material.pink].randomElement() ?? Material.blue
                        self.world.environmentEngine.mode = .floorMaterial(floor: floor, sky: sky)
                    } else {
                        self.world.environmentEngine.mode = choice.2
                    }
                }
            )
            if choice.1 == "video-360" {
                let platform = world.platform
                button.availabilityCheck = {
                    platform.resourceExists(name: "environment-nasa-360", type: .custom("mp4"))
                }
                button.refreshAvailability()
            }
            if choice.1 == "image-mono" {
                let registry = world.assetEngine.imageRegistry
                button.availabilityCheck = { registry.entry(for: EnvironmentImageKey.mono) != nil }
                button.refreshAvailability()
            }
            if choice.1 == "image-stereo" {
                let registry = world.assetEngine.imageRegistry
                button.availabilityCheck = { registry.entry(for: EnvironmentImageKey.embeddedMono) != nil }
                button.refreshAvailability()
            }
            if choice.1 == "gallery-images" {
                let registry = world.assetEngine.imageRegistry
                button.availabilityCheck = {
                    registry.entry(for: "showcase.gallery.yosemite-01") != nil && registry.entry(for: "showcase.gallery.yosemite-02") != nil
                }
                button.refreshAvailability()
            }
            if choice.1 == "spatial-photo" {
                let registry = world.assetEngine.imageRegistry
                let supported = world.platform.canDecodeStereoHEIC
                button.availabilityCheck = { supported && registry.entry(for: EnvironmentImageKey.spatial) != nil }
                button.refreshAvailability()
            }
            objects.append(button)
        }
        world.graphicEngine.changeToScene(makeSectionScene(title: isMedia ? "Environment B" : "Environment A", elements: objects, width: 2.8, flavor: .default))
    }

    private enum TourMode: String, Sendable {
        case scriptObject
        case textScript
        case commandObjects
    }

    /// Three entry points demonstrate the same tour and timing.
    private func showAutomationScene() {
        let description = AetherTextObject(
            name: "Automation Description",
            text: "Tour screens and test controls in 45 seconds.",
            characterHeight: 0.045,
            extrusionDepth: 0.006,
            material: Material.white,
            position: AetherPosition3D(x: 0, y: 1.72, z: sceneDepth)
        )
        world.graphicEngine.changeToScene(makeSectionScene(
            title: "Automation",
            elements: [
                description,
                makeTourButton("Run Script Object", mode: .scriptObject, y: 1.43),
                makeTourButton("Run Text Script", mode: .textScript, y: 1.18),
                makeTourButton("Run Command Objects", mode: .commandObjects, y: 0.93),
            ]
        ))
    }

    private func makeTourButton(
        _ title: String, mode: TourMode, y: AetherFloat
    ) -> AetherButtonObject {
        AetherButtonObject(
            name: title + " Button",
            autoID: "showcase.run-" + mode.rawValue,
            title: title,
            size: AetherSize3D(x: 0.95, y: 0.16, z: 0.04),
            sizing: .fitTextToButton,
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(x: 0, y: y, z: sceneDepth),
            targetAppearance: .goldenGlow,
            action: {
                let platform = self.world.platform
                if mode == .commandObjects {
                    // Synchronous invoke/wait calls run on a dedicated worker.
                    // Navigation is dispatched back to the platform frame thread.
                    DispatchQueue.global(qos: .userInitiated).async {
                        Self.runCommandObjectTour(on: platform)
                    }
                } else {
                    Task {
                        do {
                            switch mode {
                            case .scriptObject:
                                try await platform.runScript(Self.showcaseTour)
                            case .textScript:
                                try await platform.runTextScript(Self.showcaseTourScript)
                            case .commandObjects: break
                            }
                        } catch AetherAutomationError.alreadyRunning {
                            // A repeated press does not interrupt the running tour.
                        } catch {
                            print("Showcase automation failed: \(error)")
                            
                            _ = try? await platform.runTextScript("interaction on")
                        }
                    }
                }
            }
        )
    }

    /// Builds a typed script directly rather than parsing the text version.
    private static var showcaseTour: AetherAutomationScript {
        AetherAutomationScript(commands: [
            .setUserInteractionEnabled(false),
            .activate(.autoID("showcase.home")),
            .message("Home: starting the Showcase tour"),
            .wait(10),
            .activate(.autoID("showcase.primitives")),
            .message("Primitive Objects"),
            .wait(10),
            .activate(.autoID("showcase.home")),
            .activate(.autoID("showcase.panels")),
            .message("Panel Objects: buttons and dialogs"),
            .wait(5),
            .activate(.autoID("showcase.panels.next")),
            .message("Checking checkbox and integer values"),
            .check(.autoID("showcase.toggle.checkbox"), "true"),
            .activate(.autoID("showcase.toggle.checkbox")),
            .check(.autoID("showcase.toggle.checkbox"), "false"),
            .activate(.autoID("showcase.toggle.checkbox")),
            .check(.autoID("showcase.toggle.checkbox"), "true"),
            .check(.autoID("showcase.integer"), "4"),
            .activate(.autoID("showcase.integer")),
            .check(.autoID("showcase.integer"), "5"),
            .message("All control checks passed"),
            .wait(5),
            .activate(.autoID("showcase.home")),
            .activate(.autoID("showcase.materials")),
            .message("Materials"),
            .wait(10),
            .activate(.autoID("showcase.home")),
            .message("Tour complete: quitting in five seconds"),
            .wait(5),
            .setUserInteractionEnabled(true),
            .activate(.autoID("showcase.quit")),
            .activate(.name("Quit Confirmation Yes")),
        ], turnsOffInteraction: true)
    }

    /// Each object executes synchronously when invoke() is called.
    private static func runCommandObjectTour(on platform: any AetherPlatform) {
        let commands: [any AetherAutomationInvocable] = [
            AetherAutomationInteraction(platform: platform, enabled: false),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.home")),
            AetherAutomationMessage(platform: platform, text: "Home: starting the Showcase tour"),
            AetherAutomationWait(seconds: 10),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.primitives")),
            AetherAutomationMessage(platform: platform, text: "Primitive Objects"),
            AetherAutomationWait(seconds: 10),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.home")),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.panels")),
            AetherAutomationMessage(platform: platform, text: "Panel Objects: buttons and dialogs"),
            AetherAutomationWait(seconds: 5),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.panels.next")),
            AetherAutomationMessage(platform: platform, text: "Checking checkbox and integer values"),
            AetherAutomationCheck(platform: platform, target: .autoID("showcase.toggle.checkbox"), expected: "true"),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.toggle.checkbox")),
            AetherAutomationCheck(platform: platform, target: .autoID("showcase.toggle.checkbox"), expected: "false"),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.toggle.checkbox")),
            AetherAutomationCheck(platform: platform, target: .autoID("showcase.toggle.checkbox"), expected: "true"),
            AetherAutomationCheck(platform: platform, target: .autoID("showcase.integer"), expected: "4"),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.integer")),
            AetherAutomationCheck(platform: platform, target: .autoID("showcase.integer"), expected: "5"),
            AetherAutomationMessage(platform: platform, text: "All control checks passed"),
            AetherAutomationWait(seconds: 5),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.home")),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.materials")),
            AetherAutomationMessage(platform: platform, text: "Materials"),
            AetherAutomationWait(seconds: 10),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.home")),
            AetherAutomationMessage(platform: platform, text: "Tour complete: quitting in five seconds"),
            AetherAutomationWait(seconds: 5),
            AetherAutomationInteraction(platform: platform, enabled: true),
            AetherAutomationTap(platform: platform, target: .autoID("showcase.quit")),
            AetherAutomationTap(platform: platform, target: .name("Quit Confirmation Yes")),
        ]
        do {
            for command in commands { try command.invoke() }
        } catch AetherAutomationError.alreadyRunning {
            // Leave any existing tour in control of input.
        } catch {
            print("Showcase command invocation failed: \(error)")
            try? AetherAutomationInteraction(platform: platform, enabled: true).invoke()
        }
    }

    /// Each navigation target resolves in the current scene, including nested
    /// panel navigation. Quit uses the normal confirmation dialog.
    private static let showcaseTourScript = """
    interaction off
    tap autoID showcase.home
    message 'Home: starting the Showcase tour'
    wait 10
    tap autoID showcase.primitives
    message 'Primitive Objects'
    wait 10
    tap autoID showcase.home
    tap autoID showcase.panels
    message 'Panel Objects: buttons and dialogs'
    wait 5
    tap autoID showcase.panels.next
    message 'Checking checkbox and integer values'
    check autoID showcase.toggle.checkbox true
    tap autoID showcase.toggle.checkbox
    check autoID showcase.toggle.checkbox false
    tap autoID showcase.toggle.checkbox
    check autoID showcase.toggle.checkbox true
    check autoID showcase.integer 4
    tap autoID showcase.integer
    check autoID showcase.integer 5
    message 'All control checks passed'
    wait 5
    tap autoID showcase.home
    tap autoID showcase.materials
    message 'Materials'
    wait 10
    tap autoID showcase.home
    message 'Tour complete: quitting in five seconds'
    wait 5
    interaction on
    tap autoID showcase.quit
    tap name 'Quit Confirmation Yes'
    """

    private func showMaterialsScene() {
        let availableMaterials: [(String, AetherMaterial)] = [
            ("Aged Brass", Material.agedBrass),
            ("Dark Walnut", Material.darkWalnut),
            ("Blue Granite", Material.blueGranite),
            ("Carrara Marble", Material.carraraMarble),
            ("Brushed Steel", Material.brushedSteel),
            ("Verdigris Copper", Material.verdigrisCopper),
            ("Carbon Fiber", Material.carbonFiber),
            ("Sandstone", Material.sandstone),
            ("Red Leather", Material.redLeather),
            ("Blue Fabric", Material.blueFabric),
            ("Glacier Ice", Material.glacierIce),
            ("Lava Rock", Material.lavaRock),
            ("Green Moss", Material.greenMoss),
            ("Cobalt Ceramic", Material.cobaltCeramic),
            ("Sci-Fi Panel", Material.scifiPanel),
        ]
        let selectedMaterials = Array(
            availableMaterials.shuffled().prefix(3)
        )
        let positions: [AetherFloat] = [
            -0.62,
            0,
            0.62,
        ]
        var objects: [AetherBasicObject] = []
        var availablePrimitives = AetherPrimitive.visibleCases.shuffled()

        for (index, selection) in selectedMaterials.enumerated() {
            let (name, material) = selection
            let x = positions[index]
            let primitive = availablePrimitives.isEmpty
                ? AetherPrimitive.cube
                : availablePrimitives.removeFirst()

            objects.append(
                AetherBasicObject(
                    name: name + " " + primitive.rawValue,
                    primitive: primitive,
                    position: AetherPosition3D(
                        x: x,
                        y: 1.42,
                        z: sceneDepth
                    ),
                    size: AetherSize3D(
                        x: 0.42,
                        y: 0.42,
                        z: 0.42
                    ),
                    material: material,
                    rotationRate: randomRotationRate()
                )
            )
            objects.append(
                AetherTextObject(
                    name: name + " Label",
                    text: name,
                    characterHeight: 0.045,
                    extrusionDepth: 0.006,
                    material: Material.white,
                    position: AetherPosition3D(
                        x: x,
                        y: 1.10,
                        z: sceneDepth
                    )
                )
            )
        }

        world.graphicEngine.changeToScene(
            makeSectionScene(title: "Materials", elements: objects, width: 2.8, flavor: .darkPanel)
        )
    }

    private func showPanelObjectsScene() {
        let pageOneDescription = AetherTextObject(
            name: "Panel Page One Description",
            text: "Panel and button flavors",
            characterHeight: 0.045,
            extrusionDepth: 0.006,
            material: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 0.34,
                z: 0
            )
        )

        let defaultButton = AetherButtonObject(
            name: "Default Flavor Demonstration",
            flavor: .default,
            title: "Default Button",
            size: AetherSize3D(
                x: 0.52,
                y: 0.12,
                z: 0.04
            ),
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 0.19,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )

        let doubleSidedButton = AetherButtonObject(
            name: "Double-Sided Flavor Demonstration",
            flavor: .doubleSided,
            title: "Double-Sided Button",
            size: AetherSize3D(
                x: 0.60,
                y: 0.12,
                z: 0.04
            ),
            material: Material.purple,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 0.02,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )
        doubleSidedButton.rotationRate = AetherRotationRate3D(
            x: 0,
            y: 0.55,
            z: 0
        )

        let messageButton = AetherButtonObject(
            name: "Message Panel Demonstration",
            flavor: .default,
            title: "Show Message Panel",
            size: AetherSize3D(
                x: 0.60,
                y: 0.12,
                z: 0.04
            ),
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: -0.16,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )

        let yesNoButton = AetherButtonObject(
            name: "Yes No Panel Demonstration",
            flavor: .default,
            title: "Show Yes / No Panel",
            size: AetherSize3D(
                x: 0.60,
                y: 0.12,
                z: 0.04
            ),
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: -0.32,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )

        let pageOneNext = makePanelNextButton(
            name: "Panel Page One Next"
        )
        pageOneNext.autoID = "showcase.panels.next"
        pageOneNext.position = AetherPosition3D(
            x: 0,
            y: 0,
            z: 0
        )
        let pageOneNavigation = AetherCompositeObject(
            name: "Panel Page One Navigation",
            objects: [
                pageOneNext,
            ],
            position: AetherPosition3D(
                x: 0,
                y: -0.51,
                z: 0
            )
        )
        pageOneNavigation.size = AetherSize3D(
            x: 0.75,
            y: 0.12,
            z: 0.04
        )

        let pageOne = AetherCompositeObject(
            name: "Panel Objects Page One",
            objects: [
                pageOneDescription,
                defaultButton,
                doubleSidedButton,
                messageButton,
                yesNoButton,
                pageOneNavigation,
            ]
        )
        pageOne.size = AetherSize3D(
            x: 0.90,
            y: 1.08,
            z: 0.12
        )

        let pageTwoDescription = AetherTextObject(
            name: "Panel Page Two Description",
            text: "Boolean and integer controls",
            characterHeight: 0.045,
            extrusionDepth: 0.006,
            material: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 0.40,
                z: 0
            )
        )

        let defaultToggleRow = makeBoolToggleRow(
            name: "Default",
            flavor: .default,
            value: false,
            y: 0.25
        )
        let checkboxToggleRow = makeBoolToggleRow(
            name: "Checkbox",
            flavor: .checkbox,
            value: true,
            y: 0.08
        )
        let radioToggleRow = makeBoolToggleRow(
            name: "Radio Group",
            flavor: .radioGroup,
            value: true,
            y: -0.09
        )
        let switchToggleRow = makeBoolToggleRow(
            name: "Switch",
            flavor: .switch,
            value: false,
            y: -0.26
        )

        let intLabel = AetherTextObject(
            name: "Integer Slider Label",
            text: "Integer Slider",
            characterHeight: 0.04,
            extrusionDepth: 0.005,
            material: Material.white,
            position: AetherPosition3D(
                x: -0.28,
                y: 0,
                z: 0
            )
        )
        let intToggle = AetherIntToggleObject(
            name: "Integer Slider",
            autoID: "showcase.integer",
            value: 4,
            range: 0...10,
            step: 1,
            flavor: .default,
            size: AetherSize3D(
                x: 0.42,
                y: 0.07,
                z: 0.025
            ),
            trackMaterial: Material.button,
            fillMaterial: Material.orange,
            thumbMaterial: Material.white,
            position: AetherPosition3D(
                x: 0.22,
                y: 0,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )
        let intToggleRow = AetherCompositeObject(
            name: "Integer Slider Row",
            objects: [
                intLabel,
                intToggle,
            ],
            position: AetherPosition3D(
                x: 0,
                y: -0.44,
                z: 0
            )
        )
        intToggleRow.size = AetherSize3D(
            x: 0.90,
            y: 0.12,
            z: 0.06
        )

        let pageTwoNext = makePanelNextButton(
            name: "Panel Page Two Next"
        )
        pageTwoNext.autoID = "showcase.panels.next"
        pageTwoNext.position = AetherPosition3D(
            x: 0.20,
            y: 0,
            z: 0
        )
        let pageTwoNavigation = AetherCompositeObject(
            name: "Panel Page Two Navigation",
            objects: [
                pageTwoNext,
            ],
            position: AetherPosition3D(
                x: 0,
                y: -0.62,
                z: 0
            )
        )
        pageTwoNavigation.size = AetherSize3D(
            x: 0.75,
            y: 0.12,
            z: 0.04
        )

        let pageTwo = AetherCompositeObject(
            name: "Panel Objects Page Two",
            objects: [
                pageTwoDescription,
                defaultToggleRow,
                checkboxToggleRow,
                radioToggleRow,
                switchToggleRow,
                intToggleRow,
                pageTwoNavigation,
            ],
            isVisible: false
        )
        pageTwo.size = AetherSize3D(
            x: 0.90,
            y: 1.30,
            z: 0.12
        )

        let panel = AetherPanelObject(
            name: "Panel Objects Demonstration",
            flavor: .default,
            objects: [
                pageOne,
                pageTwo,
            ],
            size: AetherSize3D(
                x: 1.08,
                y: 1.24,
                z: 0.04
            ),
            spacing: 0,
            hideAble: false,
            material: Material.panel,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 1.42,
                z: sceneDepth
            ),
            onClose: {
                self.showHomeScene()
            }
        )
        let pagePosition = AetherPosition3D(
            x: 0,
            y: 0.12,
            z: 0.09
        )
        pageOne.position = pagePosition
        pageTwo.position = pagePosition

        pageOneNext.setAction {
            pageOne.isVisible = false
            pageTwo.isVisible = true
        }
        pageTwoNext.setAction {
            pageTwo.isVisible = false
            pageOne.isVisible = true
        }

        let helperPosition = AetherPosition3D(
            x: 0,
            y: 1.42,
            z: -1.30
        )
        let messagePanel = AetherPanelObject.messagePanel(
            name: "Message Panel Demonstration",
            title: "Message Panel",
            message: "This panel uses the standard message helper.",
            material: Material.panel,
            textMaterial: Material.white,
            buttonMaterial: Material.button,
            position: helperPosition,
            onOK: { [weak panel] in
                panel?.show()
            }
        )
        messagePanel.hide()

        let yesNoPanel = AetherPanelObject.yesNoPanel(
            name: "Yes No Panel Demonstration",
            title: "Yes / No Panel",
            message: "Either choice closes this panel.",
            material: Material.panel,
            textMaterial: Material.white,
            buttonMaterial: Material.button,
            position: helperPosition,
            yesAction: { [weak panel] in
                panel?.show()
            },
            noAction: { [weak panel] in
                panel?.show()
            }
        )
        yesNoPanel.hide()

        messageButton.setAction {
            panel.hide()
            messagePanel.show()
        }
        yesNoButton.setAction {
            panel.hide()
            yesNoPanel.show()
        }

        world.graphicEngine.changeToScene(
            makeSectionScene(
                title: "Panel Objects",
                elements: [panel, messagePanel, yesNoPanel],
                width: panel.panelSize.x,
                flavor: .lightPanel
            )
        )
    }

    private func makePanelNextButton(
        name: String
    ) -> AetherButtonObject {
        AetherButtonObject(
            name: name,
            flavor: .default,
            title: "Next",
            size: AetherSize3D(
                x: 0.34,
                y: 0.12,
                z: 0.04
            ),
            material: Material.button,
            textMaterial: Material.white,
            targetAppearance: .goldenGlow
        )
    }

    private func makeBoolToggleRow(
        name: String,
        flavor: AetherBoolToggleFlavor,
        value: Bool,
        y: AetherFloat
    ) -> AetherCompositeObject {
        let label = AetherTextObject(
            name: name + " Toggle Label",
            text: name,
            characterHeight: 0.04,
            extrusionDepth: 0.005,
            material: Material.white,
            position: AetherPosition3D(
                x: -0.28,
                y: 0,
                z: 0
            )
        )
        let toggle = AetherBoolToggleObject(
            name: name + " Toggle",
            autoID: "showcase.toggle." + name.lowercased(),
            value: value,
            flavor: flavor,
            offMaterial: Material.button,
            onMaterial: Material.green,
            position: AetherPosition3D(
                x: 0.22,
                y: 0,
                z: 0
            ),
            targetAppearance: .goldenGlow
        )
        let row = AetherCompositeObject(
            name: name + " Toggle Row",
            objects: [
                label,
                toggle,
            ],
            position: AetherPosition3D(
                x: 0,
                y: y,
                z: 0
            )
        )
        row.size = AetherSize3D(
            x: 0.90,
            y: 0.14,
            z: 0.06
        )
        return row
    }

    private func showPrimitiveObjectsScene() {
        var objects: [AetherBasicObject] = []

        let primitives = AetherPrimitive.visibleCases
        let columns = 5
        let spacingX: AetherFloat = 0.43
        let spacingY: AetherFloat = 0.42
        let firstX = -spacingX * 2
        let firstY: AetherFloat = 1.55

        for (index, primitive) in primitives.enumerated() {
            let column = index % columns
            let row = index / columns
            let x = firstX + AetherFloat(column) * spacingX
            let y = firstY - AetherFloat(row) * spacingY
            let material = randomDisplayMaterial()

            let object = AetherBasicObject(
                name: primitive.rawValue,
                primitive: primitive,
                position: AetherPosition3D(
                    x: x,
                    y: y,
                    z: sceneDepth
                ),
                size: AetherSize3D(
                    x: 0.20,
                    y: 0.20,
                    z: 0.20
                ),
                material: material,
                rotationRate: randomRotationRate()
            )
            let label = AetherTextObject(
                name: primitive.rawValue + " Label",
                text: primitive.rawValue,
                characterHeight: 0.035,
                extrusionDepth: 0.005,
                material: Material.white,
                position: AetherPosition3D(
                    x: x,
                    y: y - 0.16,
                    z: sceneDepth
                )
            )

            objects.append(object)
            objects.append(label)
        }

        world.graphicEngine.changeToScene(
            makeSectionScene(title: "Primitive Objects", elements: objects, width: 2.8, flavor: .default)
        )
    }

    /// Converts each section's authored positions to a single movable arrangement.
    /// Back remains a normal bottom content button until bar navigation is adopted.
    private func makeSectionScene(
        title: String, elements: [AetherBasicObject], width: AetherFloat = 2.4,
        flavor: AetherArrangementBarFlavor = .default
    ) -> AetherScene {
        let titleY: AetherFloat = 2.10
        let contentY = titleY - 0.26
        let highest = elements.map { $0.position.y + max($0.size.y / 2, 0.08) }.max() ?? contentY
        let lift = contentY - highest
        for element in elements { element.position.y += lift }
        let lowest = elements.map { $0.position.y - max($0.size.y / 2, 0.08) }.min() ?? 1
        let backY = lowest - 0.20
        let back = makeHomeButton()
        back.position = AetherPosition3D(x: 0, y: backY, z: sceneDepth)
        let contents = elements + [back]
        for object in contents {
            object.position.y -= contentY
            object.position.z -= sceneDepth
        }
        let arrangement = AetherBaseArrangement(
            title: title,
            closeAction: { [weak self] in self?.quitApp() },
            elements: contents,
            width: width,
            contentHeight: max(0, contentY - backY + 0.08),
            position: AetherPosition3D(x: 0, y: titleY, z: sceneDepth),
            name: title + " Arrangement",
            autoID: "showcase." + title.lowercased().replacingOccurrences(of: " ", with: "-") + "-arrangement",
            barFlavor: flavor
        )
        // Initial placement follows the same floor clearance as later dragging.
        arrangement.move(to: arrangement.position)
        return AetherScene(name: title, objects: [arrangement])
    }

    private func makeHomeButton() -> AetherButtonObject {
        AetherButtonObject(
            AetherTitleAction("Back", action: homeAction.action),
            name: "Home Button",
            autoID: "showcase.home",
            flavor: .default,
            size: AetherSize3D(
                x: 0.34,
                y: 0.13,
                z: 0.04
            ),
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: -0.98,
                y: 1.86,
                z: sceneDepth
            ),
            targetAppearance: .goldenGlow
        )
    }

    private func randomDisplayMaterial() -> AetherMaterial {
        [
            Material.red,
            Material.green,
            Material.blue,
            Material.yellow,
            Material.orange,
            Material.purple,
            Material.cyan,
            Material.pink,
            Material.agedBrass,
            Material.darkWalnut,
            Material.blueGranite,
            Material.carraraMarble,
            Material.brushedSteel,
            Material.verdigrisCopper,
            Material.carbonFiber,
            Material.sandstone,
            Material.redLeather,
            Material.blueFabric,
            Material.glacierIce,
            Material.lavaRock,
            Material.greenMoss,
            Material.cobaltCeramic,
            Material.scifiPanel,
        ].randomElement() ?? Material.blue
    }

    private func randomRotationRate() -> AetherRotationRate3D {
        AetherRotationRate3D(
            x: randomRotationComponent(),
            y: randomRotationComponent(),
            z: randomRotationComponent()
        )
    }

    private func randomRotationComponent() -> AetherFloat {
        let speed = AetherFloat.random(in: 0.18...0.70)
        return Bool.random() ? speed : -speed
    }

    private func quitApp() {
        if world.platform.canQuitApp {
            world.platform.quitApp()
        }
    }
}



#if os(visionOS)
extension AetherCircleShowcaseApplication {
    /// Adapted from Apple's Writing Spatial Photos sample (license in Shared/Files).
    /// Creates a genuine stereo HEIC at startup, then exercises registered-image loading.
    @available(visionOS 26.0, *)
    private func registerSpatialDemo() {
        guard let leftData = world.platform.resourceRetrieve(name: "environment-spatial-left", type: .image),
              let rightData = world.platform.resourceRetrieve(name: "environment-spatial-right", type: .image),
              let left = CGImageSourceCreateWithData(leftData as CFData, nil),
              let right = CGImageSourceCreateWithData(rightData as CFData, nil),
              let image = CGImageSourceCreateImageAtIndex(left, 0, nil) else {
            print("Showcase: spatial sample source JPEGs are missing or unreadable.")
            return
        }
        let width = Double(image.width), height = Double(image.height)
        let focal = width * 0.5 / tan(80.0 * .pi / 360)
        let intrinsics: [Double] = [focal, 0, width / 2, 0, focal, height / 2, 0, 0, 1]
        func properties(isLeft: Bool) -> CFDictionary {
            [kCGImagePropertyGroups: [
                kCGImagePropertyGroupIndex: 0,
                kCGImagePropertyGroupType: kCGImagePropertyGroupTypeStereoPair,
                (isLeft ? kCGImagePropertyGroupImageIsLeftImage : kCGImagePropertyGroupImageIsRightImage): true,
                kCGImagePropertyGroupImageDisparityAdjustment: 200
            ], kCGImagePropertyHEIFDictionary: [
                kIIOMetadata_CameraExtrinsicsKey: [
                    kIIOCameraExtrinsics_Position: [isLeft ? 0.0 : 0.064, 0.0, 0.0],
                    kIIOCameraExtrinsics_Rotation: [1.0, 0, 0, 0, 1, 0, 0, 0, 1]
                ], kIIOMetadata_CameraModelKey: [
                    kIIOCameraModel_Intrinsics: intrinsics,
                    kIIOCameraModel_ModelType: kIIOCameraModelType_SimplifiedPinhole
                ]
            ], kCGImagePropertyHasAlpha: false] as CFDictionary
        }
        let encoded = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(encoded, UTType.heic.identifier as CFString, 2,
            [kCGImagePropertyPrimaryImage: 0] as CFDictionary) else {
            print("Showcase: HEIC encoder unavailable; spatial sample cannot be registered.")
            return
        }
        CGImageDestinationAddImageFromSource(destination, left, 0, properties(isLeft: true))
        CGImageDestinationAddImageFromSource(destination, right, 0, properties(isLeft: false))
        guard CGImageDestinationFinalize(destination) else {
            print("Showcase: spatial HEIC sample encoding failed")
            return
        }
        world.assetEngine.registerImage(key: EnvironmentImageKey.spatial, data: encoded as Data)
    }
}
#endif
