import AetherCircleCore

public final class ShowcaseApplication: AetherApplication {

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

    private let sceneDepth: AetherFloat = -1.7

    public override func start() {
        world.environmentEngine.mode = .passthrough
        registerMaterials()
        showHomeScene()
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
        let title = makeTitle(
            "AetherCircle Showcase",
            y: 2.05
        )

        let primitiveButton = AetherButtonObject(
            name: "Primitive Objects Button",
            flavor: .default,
            title: "Primitive Objects",
            size: AetherSize3D(
                x: 0.70,
                y: 0.16,
                z: 0.04
            ),
            sizing: .fitTextToButton,
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 1.58,
                z: sceneDepth
            ),
            targetAppearance: .goldenGlow,
            action: {
                self.showPrimitiveObjectsScene()
            }
        )

        let panelButton = AetherButtonObject(
            name: "Panel Objects Button",
            flavor: .default,
            title: "Panel Objects",
            size: AetherSize3D(
                x: 0.70,
                y: 0.16,
                z: 0.04
            ),
            sizing: .fitTextToButton,
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 1.34,
                z: sceneDepth
            ),
            targetAppearance: .goldenGlow,
            action: {
                self.showPanelObjectsScene()
            }
        )

        let materialButton = AetherButtonObject(
            name: "Materials Button",
            flavor: .default,
            title: "Materials",
            size: AetherSize3D(
                x: 0.70,
                y: 0.16,
                z: 0.04
            ),
            sizing: .fitTextToButton,
            material: Material.button,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 1.10,
                z: sceneDepth
            ),
            targetAppearance: .goldenGlow,
            action: {
                self.showMaterialsScene()
            }
        )

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
                y: 0.82,
                z: sceneDepth
            ),
            targetAppearance: .goldenGlow,
            quitAction: {
                self.quitApp()
            }
        )
        quit.button.rotationRate = AetherRotationRate3D(
            x: 0,
            y: 0.55,
            z: 0
        )

        world.graphicEngine.changeToScene(
            AetherScene(
                name: "Showcase Home",
                objects: [
                    title,
                    primitiveButton,
                    panelButton,
                    materialButton,
                    quit,
                ]
            )
        )
    }

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
        var objects: [AetherObject] = [
            makeTitle("Materials", y: 2.05),
            makeHomeButton(),
        ]
        var availablePrimitives = AetherPrimitive.visibleCases.shuffled()

        for (index, selection) in selectedMaterials.enumerated() {
            let (name, material) = selection
            let x = positions[index]
            let primitive = availablePrimitives.isEmpty
                ? AetherPrimitive.cube
                : availablePrimitives.removeFirst()

            objects.append(
                AetherObject(
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
            AetherScene(
                name: "Materials",
                objects: objects
            )
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

        let pageOneHome = makePanelHomeButton(
            name: "Panel Page One Home"
        )
        pageOneHome.position = AetherPosition3D(
            x: -0.20,
            y: 0,
            z: 0
        )
        let pageOneNext = makePanelNextButton(
            name: "Panel Page One Next"
        )
        pageOneNext.position = AetherPosition3D(
            x: 0.20,
            y: 0,
            z: 0
        )
        let pageOneNavigation = AetherCompositeObject(
            name: "Panel Page One Navigation",
            objects: [
                pageOneHome,
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

        let pageTwoHome = makePanelHomeButton(
            name: "Panel Page Two Home"
        )
        pageTwoHome.position = AetherPosition3D(
            x: -0.20,
            y: 0,
            z: 0
        )
        let pageTwoNext = makePanelNextButton(
            name: "Panel Page Two Next"
        )
        pageTwoNext.position = AetherPosition3D(
            x: 0.20,
            y: 0,
            z: 0
        )
        let pageTwoNavigation = AetherCompositeObject(
            name: "Panel Page Two Navigation",
            objects: [
                pageTwoHome,
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
            title: "Panel Objects",
            objects: [
                pageOne,
                pageTwo,
            ],
            size: AetherSize3D(
                x: 1.08,
                y: 1.55,
                z: 0.04
            ),
            spacing: 0,
            hideAble: false,
            material: Material.panel,
            textMaterial: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: 1.42,
                z: -1.55
            ),
            onClose: {
                self.showHomeScene()
            }
        )
        let pagePosition = AetherPosition3D(
            x: 0,
            y: -0.06,
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
            AetherScene(
                name: "Panel Objects",
                objects: [
                    panel,
                    messagePanel,
                    yesNoPanel,
                ]
            )
        )
    }

    private func makePanelHomeButton(
        name: String
    ) -> AetherButtonObject {
        AetherButtonObject(
            name: name,
            flavor: .default,
            title: "Home",
            size: AetherSize3D(
                x: 0.34,
                y: 0.12,
                z: 0.04
            ),
            material: Material.orange,
            textMaterial: Material.white,
            targetAppearance: .goldenGlow,
            action: {
                self.showHomeScene()
            }
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
        var objects: [AetherObject] = [
            makeTitle(
                "Primitive Objects",
                y: 2.10
            ),
            makeHomeButton(),
        ]

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

            let object = AetherObject(
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
            AetherScene(
                name: "Primitive Objects",
                objects: objects
            )
        )
    }

    private func makeTitle(
        _ text: String,
        y: AetherFloat
    ) -> AetherTextObject {
        AetherTextObject(
            name: text + " Title",
            text: text,
            characterHeight: 0.16,
            extrusionDepth: 0.018,
            material: Material.white,
            position: AetherPosition3D(
                x: 0,
                y: y,
                z: sceneDepth
            )
        )
    }

    private func makeHomeButton() -> AetherButtonObject {
        AetherButtonObject(
            name: "Home Button",
            flavor: .default,
            title: "Home",
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
            targetAppearance: .goldenGlow,
            action: {
                self.showHomeScene()
            }
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
