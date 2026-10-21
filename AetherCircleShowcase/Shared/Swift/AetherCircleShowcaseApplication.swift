// MARK: - Imports

import AetherCircleCore
import Foundation
#if os(visionOS)
import ImageIO
import UniformTypeIdentifiers
#endif

// MARK: - Application Object

/// Showcase of AetherCircle framework
public final class AetherCircleShowcaseApplication: AetherApplication {

    // MARK: - Constants

    /// Different Script
    private enum ScriptMode: String, Sendable {
        case environments
        case sections
    }

    /// Material Keys for the app
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

    /// Material for the app
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

    /// List of keys for various images
    private enum EnvironmentImageKey {
        static let spatial = "showcase.environment.spatial"
        static let mono = "showcase.environment.mono"
        static let embeddedMono = "showcase.environment.kiara"
    }

    /// List of actions used on Home Page
    private lazy var homeActions: [AetherAction] = [
        AetherAction(
            key: "showcase.voice.primitives",
            title: "Primitives",
            audioCommand: "primitive",
            action: { [weak self] in
                self?.showPrimitiveScene()
            }
        ),
        AetherAction(
            key: "showcase.voice.materials",
            title: "Materials",
            audioCommand: "materials",
            action: { [weak self] in
                self?.showMaterialsScene()
            }
        ),
        AetherAction(
            key: "showcase.voice.environment-a",
            title: "Environment A",
            audioCommand: "environment a",
            action: { [weak self] in
                self?.showEnvironmentScene()
            }
        ),
        AetherAction(
            key: "showcase.voice.environment-b",
            title: "Media",
            audioCommand: "media",
            action: { [weak self] in
                self?.showEnvironmentScene(isMedia: true)
            }
        ),
        AetherAction(
            key: "showcase.voice.dialogs",
            title: "Dialogs",
            audioCommand: "dialogs",
            action: { [weak self] in
                self?.showDialogsScene()
            }
        ),
        AetherAction(
            key: "showcase.voice.ui",
            title: "UI Elements",
            audioCommand: "u i elements",
            action: { [weak self] in
                self?.showUIElementsScene()
            }
        ),
        AetherAction(
            key: "showcase.voice.automation",
            title: "Automation",
            audioCommand: "automation",
            action: { [weak self] in
                self?.showAutomationScene()
            }
        )
    ]

    /// At most 51 seconds of waits, leaving headroom for frame-driven commands.
    /// Optional media entries are omitted.
    private var scriptForEnviroments: String {
        """
        wait 1
        message "Environment A: materials, rooms and particles"
        tap name "Showcase Menu Environment A"
        wait 1
        tap name "Passthrough Environment Button"
        wait 1.2
        tap name "Teal Environment Button"
        wait 1.2
        tap name "Black Environment Button"
        wait 1.2
        tap name "White Environment Button"
        wait 1.2
        tap name "Floor + Sky Environment Button"
        wait 1.2
        tap name "Cyber Floor · Cyan Environment Button"
        wait 1.2
        tap name "Cyber Floor · Silver Environment Button"
        wait 1.2
        tap name "Room · Matching Walls Environment Button"
        wait 1.2
        tap name "Room · Six Materials Environment Button"
        wait 1.2
        tap name "Cylinder Room Environment Button"
        wait 1.2
        tap name "Dome Room Environment Button"
        wait 1.2
        tap name "Stars Environment Button"
        wait 1.2
        tap name "Snow Environment Button"
        wait 1.2
        tap name "Rain Environment Button"
        wait 1.2
        tap name "Fireflies Environment Button"
        wait 1.2
        tap name "Grass + Day Sky Environment Button"
        wait 1.2
        tap name "Sand + Sunset Environment Button"
        wait 1.2
        tap name "Home Button"
        tap name "Showcase Menu Media"
        message "Media: photographs, panoramas and video"
        wait 1
        tap name "Video 360 NASA Environment Button"
        wait 1.6
        tap name "3D Video · Side by Side Environment Button"
        wait 1.6
        tap name "3D Video · Top + Bottom Environment Button"
        wait 1.6
        tap name "Apple MV-HEVC Video Environment Button"
        wait 1.6
        tap name "File 360 Mono Environment Button"
        wait 1.6
        tap name "File Stereo TB Environment Button"
        wait 1.6
        tap name "Internet 360 Mono Environment Button"
        wait 1.6
        tap name "Image 360 Kiara Environment Button"
        wait 1.6
        tap name "Panorama Auto Environment Button"
        wait 1.6
        tap name "Panorama Override Environment Button"
        wait 1.6
        tap name "Apple Spatial Photo Environment Button"
        wait 1.6
        tap name "Yosemite Files Environment Button"
        wait 1.6
        tap name "Yosemite Images Environment Button"
        wait 1.6
        tap name "Gallery 8 Environment Button"
        wait 1.6
        tap name "Home Button"
        tap name "Showcase Menu Environment A"
        tap name "Passthrough Environment Button"
        tap name "Home Button"
        message "Environment tour complete"
        wait 1
        """
    }
    
    /// 42 seconds of waits. Demonstrates UI sections.
    private static var scriptForUI: String {
        """
        wait 1
        tap name "Showcase Menu Primitives"
        message "Primitives"
        wait 12
        tap name "Home Button"
        tap name "Showcase Menu Materials"
        message "Materials"
        wait 12
        tap name "Home Button"
        tap name "Showcase Menu Dialogs"
        message "Dialogs"
        wait 8
        tap name "Home Button"
        tap name "Showcase Menu UI Elements"
        message "UI Elements"
        check name "Checkbox Toggle" true
        tap name "Checkbox Toggle"
        check name "Checkbox Toggle" false
        tap name "Checkbox Toggle"
        check name "Checkbox Toggle" true
        check name "Integer Slider" 4
        tap name "Integer Slider"
        check name "Integer Slider" 5
        message "UI element checks passed"
        wait 8
        tap name "Home Button"
        message "Section tour complete"
        wait 1
        """
    }

    /// Depth of various arrangement in the world
    private let sceneDepth: AetherFloat = -1.7
    
    /// Download Task for Eviroment
    private var environmentDownloadTask: Task<Void, Never>?
    
    /// Download Task for Video
    private var spatialVideoDemoTask: Task<Void, Never>?
    
    /// Spatial Video key
    private static let spatialVideoDemoKey = "showcase.environment.spatial-video"

    // Keep radom list of materials.
    private lazy var environmentPatterns: [(String, AetherMaterial)] = [
        ("Dark Walnut", Material.darkWalnut),
        ("Blue Granite", Material.blueGranite),
        ("Carbon Fiber", Material.carbonFiber),
        ("Blue Fabric", Material.blueFabric),
        ("Carrara Marble", Material.carraraMarble),
        ("Sci-Fi Panel", Material.scifiPanel),
    ].shuffled()

    // MARK: - Randomized

    /// Randomly pick a material
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

    /// Random rotation rate
    private func randomRotationRate() -> AetherRotationRate3D {
        AetherRotationRate3D(
            x: randomRotationComponent(),
            y: randomRotationComponent(),
            z: randomRotationComponent()
        )
    }

    /// Random Rotation part
    private func randomRotationComponent() -> AetherFloat {
        let speed = AetherFloat.random(in: 0.18...0.70)
        return Bool.random() ? speed : -speed
    }

    // MARK: - App Functions

    public override func start() {
        world.platform.configureVoice(AetherVoiceConfiguration(wakePhrase: "Showcase"))

        world.environmentEngine.mode = .passthrough

        registerMaterials()
        registerEnvironmentImages()
        homeActions.forEach { $0.register() }

        AetherAction.setHomeAction { [weak self] in self?.showHomeScene() }
    }

    public override func stop() {
        world.platform.configureVoice(nil)
        
        spatialVideoDemoTask?.cancel()
        spatialVideoDemoTask = nil
        environmentDownloadTask?.cancel()
        environmentDownloadTask = nil
    }

    // MARK: - Register Functions

    /// Register Materials.
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

    /// One registered example is embedded; the other must arrive over HTTPS.
    private func registerEnvironmentImages() {
        #if os(visionOS)
        if #available(visionOS 26.0, *), world.platform.canDecodeStereoHEIC { registerSpatialDemo() }
        #endif
        
        if world.platform.canPrepareSpatialVideo { registerSpatialVideoDemo() }
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

    /// Selects sample content; the platform handles encoding and cache publication.
    private func registerSpatialVideoDemo() {
        spatialVideoDemoTask?.cancel()
        let platform = world.platform
        let key = Self.spatialVideoDemoKey
        spatialVideoDemoTask = Task<Void, Never>.detached(priority: .utility) { @Sendable [platform, key] in
            do {
                try await platform.registerSpatialVideo(
                    key: key, resourceName: "environment-stereo-sbs",
                    layout: .sideBySide, storage: .session
                )
            } catch is CancellationError {
                // Stopping the app cancels preparation.
            } catch { print("Showcase: MV-HEVC demo could not be prepared: \(error)") }
        }
    }
    
    // MARK: - Make Functions
    
    /// Preserves each section's internal layout in a single movable arrangement.
    /// Back remains a normal bottom content button until bar navigation is adopted.
    private func makeSectionScene(
        title: String, elements: [AetherBasicObject], width: AetherFloat = 2.4,
        flavor: AetherArrangementBarFlavor = .default
    ) -> AetherScene {
        let titleY: AetherFloat = 2.10
        // Keep grids and control rows intact inside one group. The arrangement
        // measures the descendants and spaces this group and Back automatically.
        for element in elements { element.position.z -= sceneDepth }
        let group = AetherCompositeObject(name: title + " Elements", objects: elements)
        let back = makeHomeButton()
        back.position = .zero
        let contents: [AetherBasicObject] = [group, back]
        let arrangement = AetherBaseArrangement(
            title: title,
            elements: contents,
            width: width,
            position: AetherPosition3D(x: 0, y: titleY, z: sceneDepth),
            name: title + " Arrangement",
            barFlavor: flavor
        )
        // Initial placement follows the same floor clearance as later dragging.
        arrangement.move(to: arrangement.position)
        return AetherScene(name: title, objects: [arrangement])
    }

    /// Make various UI element for Bool
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

    /// Make Standard Home Button
    private func makeHomeButton() -> AetherButtonObject {
        AetherButtonObject(
            .home,
            name: "Home Button",
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

    /// Make Script Button
    private func makeScriptButton(
        _ title: String, mode: ScriptMode, y: AetherFloat
    ) -> AetherButtonObject {
        AetherButtonObject(
            name: title + " Button",
            title: title,
            size: AetherSize3D(x: 1.55, y: 0.16, z: 0.04),
            sizing: .fitTextToButton,
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(x: 0, y: y, z: sceneDepth),
            targetAppearance: .goldenGlow,
            action: AetherAction(action: {
                let script = mode == .environments ? self.scriptForEnviroments : Self.scriptForUI
                let platform = self.world.platform
                // Navigate first, before runTextScript can disable input or execute commands.
                AetherAction.home.invoke()
                Task {
                    do {
                        try await platform.runTextScript(script, turnsOffInteraction: true)
                    } catch AetherAutomationError.alreadyRunning {
                        // The runner owns interaction until its current tour completes.
                    } catch {
                        print("Showcase automation failed: \(error)")
                    }
                }
            })
        )
    }

    // MARK: - Show Functions

    /// Show Home Screen
    private func showHomeScene() {
        world.graphicEngine.changeToScene(
            AetherScene(
                name: "Showcase Home",
                objects: [
                    AetherBaseArrangement(
                        title: "AetherCircle Showcase",
                        elements: [
                            AetherListButton(
                                AetherListActions(homeActions),
                                name: "Showcase Menu",
                                numberItemPerColumn: 4,
                                size: AetherSize3D(x: 0.70, y: 0.16, z: 0.04),
                                material: Material.button,
                                textMaterial: Material.white,
                                position: AetherPosition3D(x: -0.39, y: 0, z: 0),
                                targetAppearance: .goldenGlow,
                                rowSpacing: 0.06
                            ),
                            AetherQuitButtonObject( position: .zero)
                        ],
                        width: 2.8,
                        position: AetherPosition3D(x: 0, y: 2.10, z: sceneDepth),
                        name: "Home Arrangement",
                        barFlavor: .floatingTitle
                    )
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
        let shuffledPatterns = environmentPatterns
        let floorPatterns = Array(shuffledPatterns.dropFirst(3))
        for (index, pattern) in shuffledPatterns.prefix(3).enumerated() {
            choices.append((pattern.0, "pattern-\(index + 1)", .materialVR(pattern.1)))
        }
        choices.append(("Video 360 NASA", "video-360", .video360File("environment-nasa-360.mp4")))
        choices.append(("3D Video · Side by Side", "video-sbs", .spatialVideoFile("environment-stereo-sbs.mp4", layout: .sideBySide)))
        choices.append(("3D Video · Top + Bottom", "video-tb", .spatialVideoFile("environment-stereo-tb.mp4", layout: .topBottom)))
        choices.append(("Apple MV-HEVC Video", "video-spatial", .spatialVideoVideo(Self.spatialVideoDemoKey)))
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
        choices.append(("Cylinder Room", "room-cylinder", .cylinderRoom(
            diameter: 7000, height: 3200, floor: Material.darkWalnut,
            walls: Material.sandstone, ceiling: .color(.white))))
        choices.append(("Dome Room", "room-dome", .domeRoom(
            diameter: 8000, height: 4000, floor: Material.carraraMarble, dome: Material.blueFabric)))
        choices.append(("Stars", "particles-stars", .particleField(.stars())))
        choices.append(("Snow", "particles-snow", .particleField(.snow())))
        choices.append(("Rain", "particles-rain", .particleField(.rain())))
        choices.append(("Fireflies", "particles-fireflies", .particleField(.fireflies())))
        choices.append(("Grass + Day Sky", "sky-grass", .skyFloor(
            skyFile: "environment-day-sky.jpg",
            floor: .texture(baseColorTexture: "environment-grass-floor.jpg", roughness: 0.95))))
        choices.append(("Sand + Sunset", "sky-sand", .skyFloor(
            skyFile: "environment-sunset-sky.jpg",
            floor: .texture(baseColorTexture: "environment-sand-floor.jpg", roughness: 0.9))))
        // A: materials and walkable spaces. B: recorded media and photo galleries.
        choices = choices.filter { choice in
            switch choice.2 {
            case .passthrough, .blankVR, .materialVR, .floorMaterial, .cyberFloor, .room, .cylinderRoom, .domeRoom, .skyFloor, .particleField:
                return !isMedia
            default:
                return isMedia
            }
        }
        var objects: [AetherBasicObject] = []
        for (index, choice) in choices.enumerated() {
            let button = AetherButtonObject(
                name: choice.0 + " Environment Button",
                title: choice.0,
                size: AetherSize3D(x: 0.78, y: 0.15, z: 0.04),
                sizing: .fitTextToButton,
                material: Material.button, textMaterial: Material.white,
                position: AetherPosition3D(x: AetherFloat(index % 3 - 1) * 0.86, y: 1.68 - AetherFloat(index / 3) * 0.23, z: sceneDepth),
                targetAppearance: .goldenGlow,
                action: AetherAction(action: {
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
                })
            )
            if ["video-sbs", "video-tb"].contains(choice.1) {
                let platform = world.platform
                let supported = world.environmentEngine.supports(choice.2)
                let file = choice.1 == "video-sbs" ? "environment-stereo-sbs" : "environment-stereo-tb"
                button.setAction(AetherAction(action: button.action?.action, enabled: { supported && platform.resourceExists(name: file, type: .custom("mp4")) }))
                button.refreshAvailability()
            }
            if choice.1 == "video-spatial" {
                let cache = world.platform.cacheEngine
                let supported = world.environmentEngine.supports(choice.2)
                button.setAction(AetherAction(action: button.action?.action, enabled: { supported && (try? cache.fileURL(for: Self.spatialVideoDemoKey)) != nil }))
                button.refreshAvailability()
            }
            if choice.1 == "video-360" {
                let platform = world.platform
                button.setAction(AetherAction(action: button.action?.action, enabled: {
                    platform.resourceExists(name: "environment-nasa-360", type: .custom("mp4"))
                }))
                button.refreshAvailability()
            }
            if choice.1 == "image-mono" {
                let registry = world.assetEngine.imageRegistry
                button.setAction(AetherAction(action: button.action?.action, enabled: { registry.entry(for: EnvironmentImageKey.mono) != nil }))
                button.refreshAvailability()
            }
            if choice.1 == "image-stereo" {
                let registry = world.assetEngine.imageRegistry
                button.setAction(AetherAction(action: button.action?.action, enabled: { registry.entry(for: EnvironmentImageKey.embeddedMono) != nil }))
                button.refreshAvailability()
            }
            if choice.1 == "gallery-images" {
                let registry = world.assetEngine.imageRegistry
                button.setAction(AetherAction(action: button.action?.action, enabled: {
                    registry.entry(for: "showcase.gallery.yosemite-01") != nil && registry.entry(for: "showcase.gallery.yosemite-02") != nil
                }))
                button.refreshAvailability()
            }
            if choice.1 == "spatial-photo" {
                let registry = world.assetEngine.imageRegistry
                let supported = world.platform.canDecodeStereoHEIC
                button.setAction(AetherAction(action: button.action?.action, enabled: { supported && registry.entry(for: EnvironmentImageKey.spatial) != nil }))
                button.refreshAvailability()
            }
            objects.append(button)
        }
        world.graphicEngine.changeToScene(makeSectionScene(title: isMedia ? "Media" : "Environment A", elements: objects, width: 2.8, flavor: .default))
    }

    /// Two text-script tours; both return Home before the runner starts.
    private func showAutomationScene() {
        world.graphicEngine.changeToScene(makeSectionScene(
            title: "Automation",
            elements: [
                makeScriptButton("Tour Environments", mode: .environments, y: 1.43),
                makeScriptButton("Tour UI", mode: .sections, y: 1.18),
            ]
        ))
    }

    /// Show Material Scene
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

    /// Show Dialog scene
    private func showDialogsScene() {
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

        let pageOne = AetherCompositeObject(
            name: "Dialogs Content",
            objects: [pageOneDescription, defaultButton, doubleSidedButton, messageButton, yesNoButton],
            position: AetherPosition3D(x: 0, y: 0, z: 0.09)
        )
        pageOne.size = AetherSize3D(x: 0.90, y: 1.08, z: 0.12)
        let back = makeHomeButton()
        back.position = .zero
        let arrangement = AetherBaseArrangement(
            title: "Dialogs",
            elements: [pageOne, back],
            width: 1.08,
            position: AetherPosition3D(x: 0, y: 2.10, z: sceneDepth),
            name: "Dialogs Arrangement",
            barFlavor: .lightPanel
        )
        arrangement.move(to: arrangement.position)

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
            onOK: AetherAction(action: { [weak arrangement] in
                arrangement?.isVisible = true
            })
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
            yesAction: AetherAction(action: { [weak arrangement] in
                arrangement?.isVisible = true
            }),
            noAction: AetherAction(action: { [weak arrangement] in
                arrangement?.isVisible = true
            })
        )
        yesNoPanel.hide()

        messageButton.setAction(AetherAction(action: { [weak arrangement] in
            arrangement?.isVisible = false
            messagePanel.show()
        }))
        yesNoButton.setAction(AetherAction(action: { [weak arrangement] in
            arrangement?.isVisible = false
            yesNoPanel.show()
        }))

        world.graphicEngine.changeToScene(
            AetherScene(name: "Dialogs", objects: [arrangement, messagePanel, yesNoPanel])
        )
    }

    /// Show UI Scene
    private func showUIElementsScene() {
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

        let controls = AetherCompositeObject(
            name: "UI Elements Content",
            objects: [pageTwoDescription, defaultToggleRow, checkboxToggleRow,
                      radioToggleRow, switchToggleRow, intToggleRow],
            position: AetherPosition3D(x: 0, y: 1.42, z: sceneDepth)
        )
        controls.size = AetherSize3D(x: 0.90, y: 1.30, z: 0.12)
        world.graphicEngine.changeToScene(
            makeSectionScene(title: "UI Elements", elements: [controls],
                             width: 1.08, flavor: .lightPanel)
        )
    }

    /// Show Primitive Screne
    private func showPrimitiveScene() {
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

}


// MARK: - Extension

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

