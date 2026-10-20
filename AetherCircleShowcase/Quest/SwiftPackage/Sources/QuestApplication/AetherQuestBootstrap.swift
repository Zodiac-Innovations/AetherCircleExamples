import Foundation
import AetherCircleCore

private final class QuestGraphicEngine: AetherGraphicEngine {
    var scene = AetherScene()

    func changeToScene(
        _ scene: AetherScene,
        effect: AetherEffect
    ) {
        self.scene = scene
    }

    func changeAddObject(
        _ object: AetherBasicObject,
        effect: AetherEffect
    ) {
        scene.add(object)
    }

    func changeRemoveObject(
        _ object: AetherBasicObject,
        effect: AetherEffect
    ) {
        scene.remove(object)
    }
}

private final class QuestEnvironmentEngine: AetherEnvironmentEngine {
    private var currentMode: AetherEnvironmentMode = .blankVR
    var mode: AetherEnvironmentMode {
        get { currentMode }
        set {
            guard supports(newValue) else {
                print("AetherCircle: native Apple spatial HEIC decoding is not supported on Quest")
                return
            }
            currentMode = newValue
        }
    }
}

private final class QuestAssetEngine: AetherAssetEngine {
    let imageRegistry = AetherImageRegistry()
    private var materials: [String: AetherMaterial] = [:]
    init() { resetDefaultMaterials() }
    func registerMaterial(key: String, material: AetherMaterial) { materials[key] = material }
    func registeredMaterial(for key: String) -> AetherMaterial? { materials[key] }
    func surface(for material: AetherMaterial) -> AetherMaterialSurface {
        var current = material
        var visited = Set<String>()
        while case .named(let key) = current {
            guard visited.insert(key).inserted, let next = materials[key] else {
                return AetherMaterialSurface(baseColor: .white)
            }
            current = next
        }
        if case .surface(let surface) = current { return surface }
        return AetherMaterialSurface(baseColor: .white)
    }
}

private final class QuestPlatform: AetherPlatform, @unchecked Sendable {
    let appName = {{DISPLAY_NAME_SWIFT}}
    let appIdentifier = "{{PACKAGE_NAME}}"
    let appVersion = "{{VERSION}}"
    let appBuild = "{{BUILD}}"
    var platformName: String { "Meta Quest" }
    var platformType: AetherPlatformType { .quest }
    var canDecodeStereoHEIC: Bool { false }
    var deviceType: AetherDeviceType { .headset }
    var deviceManufacturer: String { "Meta" }
    let automationRunner = AetherAutomationRunner()
    var canRunAutomation: Bool { true }
    @discardableResult
    func runScript(_ script: AetherAutomationScript) async throws -> Bool {
        try await automationRunner.run(script)
        return true
    }
    nonisolated var canSetUserInteractionEnabled: Bool { true }
    nonisolated(unsafe) private(set) var isUserInteractionEnabled = true
    @discardableResult
    nonisolated func setUserInteractionEnabled(_ enabled: Bool) -> Bool {
        isUserInteractionEnabled = enabled
        return true
    }
    var quitRequested = false
    var canQuitApp: Bool { true }
    func quitApp() -> Bool { quitRequested = true; return true }
    var resourceDirectory: URL?
    var canRetrieveResources: Bool { resourceDirectory != nil }
    func resourceURL(name: String, type: AetherResourceType) -> URL? {
        guard let root = resourceDirectory,
              !name.isEmpty, name == URL(fileURLWithPath: name).lastPathComponent else { return nil }
        let candidates = [name] + type.fileExtensions.map { name + "." + $0 }
        return candidates.map { root.appendingPathComponent($0) }.first {
            FileManager.default.fileExists(atPath: $0.path)
        }
    }
    func resourceExists(name: String, type: AetherResourceType) -> Bool {
        resourceURL(name: name, type: type) != nil
    }
    func resourceRetrieve(name: String, type: AetherResourceType) -> Data? {
        guard let url = resourceURL(name: name, type: type) else { return nil }
        return try? Data(contentsOf: url)
    }
}

private final class QuestSwiftRuntime: @unchecked Sendable {
    static let shared = QuestSwiftRuntime()

    let graphicEngine = QuestGraphicEngine()
    var supportsPassthrough = false
    let environmentEngine = QuestEnvironmentEngine()
    let assetEngine = QuestAssetEngine()
    let hudEngine = AetherHUDDummy()
    let platformServices = QuestPlatform()
    private var application: AetherApplication?
    var renderObjects: [AetherBasicObject] = []
    var renderParents: [Int32] = []

    private var panoramaAngleCache: [String: AetherFloat] = [:]
    func panoramaDegrees(override: AetherFloat?) -> AetherFloat {
        if let override { return override }
        let image: AetherImageResource
        let cacheKey: String
        switch environmentEngine.mode {
        case .panoramaFile(let name, _): image = .file(name); cacheKey = "file:" + name
        case .panoramaImage(let key, _):
            guard let entry = assetEngine.imageRegistry.entry(for: key) else { return 270 }
            image = entry.image; cacheKey = "image:\(key):\(entry.revision)"
        default: return 270
        }
        if let cached = panoramaAngleCache[cacheKey] { return cached }
        let data: Data?
        switch image {
        case .data(let encoded): data = encoded
        case .file(let name): data = platformServices.resourceRetrieve(name: name, type: .image)
        }
        // Retry if native resource extraction has not completed yet.
        guard let data else { return 270 }
        let angle = AetherPanoramaMetadata.resolvedHorizontalDegrees(imageData: data)
        panoramaAngleCache = [cacheKey: angle]
        return angle
    }

    var galleryNames: [String] {
        switch environmentEngine.mode {
        case .photo2DFiles(let names, _), .photo2DImages(let names, _): return Array(names.prefix(8))
        default: return []
        }
    }
    func galleryImage(at bridgeIndex: Int32) -> AetherImageResource? {
        let slot = Int(-bridgeIndex - 10)
        let names = galleryNames
        guard slot >= 0, slot < names.count else { return nil }
        if case .photo2DFiles = environmentEngine.mode { return .file(names[slot]) }
        return assetEngine.registeredImage(for: names[slot])
    }
    func registeredImageKey(at bridgeIndex: Int32) -> String? {
        if bridgeIndex == -1 { return registeredEnvironmentImageKey }
        let slot = Int(-bridgeIndex - 10)
        if case .photo2DImages = environmentEngine.mode, slot >= 0, slot < galleryNames.count {
            return galleryNames[slot]
        }
        return nil
    }

    /// Bridge index -1 is reserved for the environment, outside scene interaction.
    var environmentMaterial: AetherMaterial? {
        switch environmentEngine.mode {
        case .materialVR(let material), .photo2DFiles(_, let material), .photo2DImages(_, let material): return material
        case .image360File(let name, _), .panoramaFile(let name, _): return .texture(baseColorTexture: name)
        case .image360Image(let key, _), .panoramaImage(let key, _):
            guard let entry = assetEngine.imageRegistry.entry(for: key) else { return nil }
            switch entry.image {
            case .file(let name): return .texture(baseColorTexture: name)
            case .data: return .color(.white)
            }
        case .floorMaterial(_, let sky), .cyberFloor(let sky, _, _, _): return sky
        default: return nil
        }
    }

    var registeredEnvironmentImageKey: String? {
        switch environmentEngine.mode {
        case .image360Image(let key, _), .panoramaImage(let key, _): return key
        default: return nil
        }
    }

    var cyberGrid: AetherCyberFloorGrid? {
        if case .cyberFloor(_, _, _, let width) = environmentEngine.mode {
            return AetherCyberFloorGrid(squareWidth: width)
        }
        return nil
    }

    /// Room surfaces use -20...-25, separate from scene interaction and galleries.
    var room: AetherRoom? {
        if case .room(let room, _) = environmentEngine.mode { return room }
        return nil
    }

    func material(at index: Int32) -> AetherMaterial? {
        if index <= -20, index >= -25,
           let surface = AetherRoom.Surface(rawValue: Int(-index - 20)),
           case .room(_, let materials) = environmentEngine.mode { return materials[surface] }
        if index == -1 { return environmentMaterial }
        if index == -2 { return floorMaterial }
        if index == -3, case .cyberFloor(_, _, let lines, _) = environmentEngine.mode { return lines }
        return object(at: index)?.material
    }

    /// Bridge index -2 is the floor; it is never a tappable scene object.
    var floorMaterial: AetherMaterial? {
        switch environmentEngine.mode {
        case .floorMaterial(let floor, _), .cyberFloor(_, let floor, _, _): return floor
        default: break
        }
        return nil
    }

    func prepareRenderScene() {
        renderObjects.removeAll(keepingCapacity: true)
        renderParents.removeAll(keepingCapacity: true)
        func append(_ object: AetherBasicObject, parent: Int32) {
            guard object.isVisible else { return }
            if let button = object as? AetherButtonObject { button.refreshAvailability() }
            let index = Int32(renderObjects.count)
            renderObjects.append(object)
            renderParents.append(parent)
            if let composite = object as? AetherCompositeObject {
                for child in composite.children { append(child, parent: index) }
            }
        }
        for object in graphicEngine.scene.objects { append(object, parent: -1) }
    }

    private init() {
    }

    func start() {
        guard application == nil else {
            return
        }

        platformServices.quitRequested = false
        let world = AetherWorld(
            graphicEngine: graphicEngine,
            environmentEngine: environmentEngine,
            hudEngine: hudEngine,
            clockEngine: AetherClockDummy(),
            assetEngine: assetEngine,
            capabilities: AetherCapabilities(
                coreLevel: .level1,
                supportsPassthrough: supportsPassthrough,
                supportsFullVR: true,
                supportsHUD: false,
                supportsClock: false
            ),
            platform: platformServices
        )
        let application = {{PROJECT_NAME}}Application(
            world: world,
            name: {{DISPLAY_NAME_SWIFT}}
        )
        self.application = application
        application.start()
        prepareRenderScene()
    }

    func stop() {
        platformServices.automationRunner.stop()
        questArrangementDrags.removeAll()
        application?.stop()
        application = nil
        graphicEngine.scene = AetherScene()
    }

    func object(at index: Int32) -> AetherBasicObject? {
        let objects = renderObjects
        guard index >= 0, Int(index) < objects.count else {
            return nil
        }
        return objects[Int(index)]
    }
}

@_cdecl("aethercircle_swift_start")
public func aethercircleSwiftStart() {
    QuestSwiftRuntime.shared.start()
}

@_cdecl("aethercircle_swift_stop")
public func aethercircleSwiftStop() {
    QuestSwiftRuntime.shared.stop()
}

@_cdecl("aethercircle_swift_object_count")
public func aethercircleSwiftObjectCount() -> Int32 {
    Int32(QuestSwiftRuntime.shared.renderObjects.count)
}

@_cdecl("aethercircle_swift_object_primitive")
public func aethercircleSwiftObjectPrimitive(_ index: Int32) -> Int32 {
    guard let object = QuestSwiftRuntime.shared.object(at: index) else {
        return -1
    }
    switch object.primitive {
    case .cube: return 0
    case .sphere: return 1
    case .space: return 2
    case .box: return 3
    case .hemisphere: return 4
    case .ellipsoid: return 5
    case .cylinder: return 6
    case .cone: return 7
    case .capsule: return 8
    case .pyramid: return 9
    case .tetrahedron: return 10
    case .octahedron: return 11
    case .wedge: return 12
    case .prism: return 13
    case .torus: return 14
    case .plane: return 15
    case .triangle: return 16
    case .disc: return 17
    case .ring: return 18
    }
}

@_cdecl("aethercircle_swift_object_value")
public func aethercircleSwiftObjectValue(
    _ index: Int32,
    _ value: Int32
) -> Float {
    if index == -3 {
        let runtime = QuestSwiftRuntime.shared
        guard let grid = runtime.cyberGrid, let material = runtime.material(at: index) else { return 0 }
        switch value {
        case 0: return 1
        case 1: return grid.cellWidth
        case 2: return grid.lineWidth
        case 3: return Float(AetherCyberFloorGrid.halfCellCount)
        case 4: return grid.rebaseStep
        case 14: return runtime.assetEngine.surface(for: material).roughness
        case 15: return runtime.assetEngine.surface(for: material).metallic
        default: return 0
        }
    }
    if index <= -20 && index >= -25 {
        let runtime = QuestSwiftRuntime.shared
        guard let room = runtime.room,
              let surface = AetherRoom.Surface(rawValue: Int(-index - 20)),
              let material = runtime.material(at: index) else { return 0 }
        let center = room.center(of: surface), size = room.size(of: surface)
        let rotation = room.rotation(of: surface)
        switch value {
        case 0: return 1
        case 1: return center.x
        case 2: return center.y
        case 3: return center.z
        case 4: return size.x
        case 5: return size.y
        case 6: return rotation.x
        case 7: return rotation.y
        case 14: return runtime.assetEngine.surface(for: material).roughness
        case 15: return runtime.assetEngine.surface(for: material).metallic
        default: return 0
        }
    }
    if index <= -10 && index >= -17 {
        let runtime = QuestSwiftRuntime.shared
        let slot = Int(-index - 10)
        let angles = AetherImageGalleryLayout.anglesDegrees(imageCount: runtime.galleryNames.count)
        guard slot < angles.count else { return 0 }
        switch value {
        case 0: return runtime.galleryImage(at: index) == nil ? 0 : 1
        case 1: return angles[slot]
        case 2: return AetherImageGalleryLayout.radius
        case 3: return AetherImageGalleryLayout.maximumWidth
        case 4: return AetherImageGalleryLayout.maximumHeight
        default: return 0
        }
    }
    if index == -2 {
        let runtime = QuestSwiftRuntime.shared
        guard let material = runtime.floorMaterial else { return 0 }
        switch value {
        case 0: return 1
        case 1: return runtime.cyberGrid?.floorExtent ?? 2048
        case 14: return runtime.assetEngine.surface(for: material).roughness
        case 15: return runtime.assetEngine.surface(for: material).metallic
        default: return 0
        }
    }
    if index == -1 {
        let runtime = QuestSwiftRuntime.shared
        switch value {
        case 0: return runtime.environmentMaterial == nil ? 0 : 1
        case 1:
            if case .photo2DFiles = runtime.environmentEngine.mode { return 12 }
            if case .photo2DImages = runtime.environmentEngine.mode { return 12 }
            if case .materialVR = runtime.environmentEngine.mode { return 12 }
            if case .floorMaterial = runtime.environmentEngine.mode { return 12 }
            if case .cyberFloor = runtime.environmentEngine.mode { return 12 }
            return 1
        case 2:
            if case .photo2DFiles = runtime.environmentEngine.mode { return 6 }
            if case .photo2DImages = runtime.environmentEngine.mode { return 6 }
            if case .materialVR = runtime.environmentEngine.mode { return 6 }
            if case .floorMaterial = runtime.environmentEngine.mode { return 6 }
            if case .cyberFloor = runtime.environmentEngine.mode { return 6 }
            return 1
        case 3:
            switch runtime.environmentEngine.mode {
            case .image360File(_, let layout), .image360Image(_, let layout):
                switch layout {
                case .mono: return 0
                case .stereoTopBottom: return 1
                case .stereoSideBySide: return 2
                }
            case .panoramaFile, .panoramaImage: return 3
            default: return -1
            }
        case 4:
            if case .floorMaterial = runtime.environmentEngine.mode { return 1 }
            if case .cyberFloor = runtime.environmentEngine.mode { return 1 }
            return runtime.environmentEngine.mode.placement == .userCentered ? 1 : 0
        case 6: return Float(runtime.galleryNames.count)
        case 5:
            switch runtime.environmentEngine.mode {
            case .panoramaFile(_, let degrees), .panoramaImage(_, let degrees): return runtime.panoramaDegrees(override: degrees)
            default: return 360
            }
        default: return 0
        }
    }
    guard let object = QuestSwiftRuntime.shared.object(at: index) else {
        return 0
    }

    switch value {
    case 0: return object.position.x
    case 1: return object.position.y
    case 2: return object.position.z
    case 3: return object.size.x
    case 4: return object.size.y
    case 5: return object.size.z
    case 6: return object.rotation.x
    case 7: return object.rotation.y
    case 8: return object.rotation.z
    case 9: return object.rotationRate?.x ?? 0
    case 10: return object.rotationRate?.y ?? 0
    case 11: return object.rotationRate?.z ?? 0
    case 12: return object.isVisible ? 1 : 0
    case 13: return (object as? AetherTextObject)?.characterHeight ?? 0
    case 14: return QuestSwiftRuntime.shared.assetEngine.surface(for: object.material).roughness
    case 15: return QuestSwiftRuntime.shared.assetEngine.surface(for: object.material).metallic
    default: return 0
    }
}

@_cdecl("aethercircle_swift_object_color")
public func aethercircleSwiftObjectColor(
    _ index: Int32,
    _ component: Int32
) -> Float {
    let runtime = QuestSwiftRuntime.shared
    guard let material = runtime.material(at: index) else { return 0 }
    let color = runtime.assetEngine.surface(for: material).baseColor
    switch component {
    case 0: return color.red
    case 1: return color.green
    case 2: return color.blue
    case 3: return color.alpha
    default: return 0
    }
}


// All native bridge calls must be serialized on the Android runtime thread.
@_cdecl("aethercircle_swift_set_resource_directory")
public func aethercircleSwiftSetResourceDirectory(_ path: UnsafePointer<CChar>?) {
    QuestSwiftRuntime.shared.platformServices.resourceDirectory = path.map {
        URL(fileURLWithPath: String(cString: $0), isDirectory: true)
    }
}

// Snapshot once per frame; parents precede their children. Transforms stay local.
@_cdecl("aethercircle_swift_prepare_scene")
public func aethercircleSwiftPrepareScene() {
    let runtime = QuestSwiftRuntime.shared
    runtime.platformServices.automationRunner.update(
        now: ProcessInfo.processInfo.systemUptime,
        activate: { target in
            try runtime.graphicEngine.scene.tapObject(target)
        },
        setInteractionEnabled: { _ = runtime.platformServices.setUserInteractionEnabled($0) },
        showMessage: { runtime.hudEngine.present(.banner(text: $0, onClose: nil)) },
        readValue: { try runtime.graphicEngine.scene.objectValue($0) }
    )
    runtime.prepareRenderScene()
}

@_cdecl("aethercircle_swift_object_parent")
public func aethercircleSwiftObjectParent(_ index: Int32) -> Int32 {
    let parents = QuestSwiftRuntime.shared.renderParents
    guard index >= 0, Int(index) < parents.count else { return -1 }
    return parents[Int(index)]
}

// Caller owns the buffer. The return value is the full UTF-8 byte count.
@_cdecl("aethercircle_swift_object_text")
public func aethercircleSwiftObjectText(
    _ index: Int32, _ buffer: UnsafeMutablePointer<CChar>?, _ capacity: Int32
) -> Int32 {
    guard let text = QuestSwiftRuntime.shared.object(at: index) as? AetherTextObject else {
        if let buffer, capacity > 0 { buffer[0] = 0 }
        return 0
    }
    let bytes = Array(text.text.utf8)
    if let buffer, capacity > 0 {
        let count = min(bytes.count, Int(capacity) - 1)
        for i in 0..<count { buffer[i] = CChar(bitPattern: bytes[i]) }
        buffer[count] = 0
    }
    return Int32(bytes.count)
}

@_cdecl("aethercircle_swift_object_target")
public func aethercircleSwiftObjectTarget(_ index: Int32) -> Int32 {
    let runtime = QuestSwiftRuntime.shared
    guard runtime.platformServices.isUserInteractionEnabled else { return -1 }
    var current = index
    while let object = runtime.object(at: current) {
        if let config = object.config { return config.canTarget ? current : -1 }
        current = runtime.renderParents[Int(current)]
        if current < 0 { break }
    }
    return -1
}

@_cdecl("aethercircle_swift_activate")
public func aethercircleSwiftActivate(_ index: Int32) {
    guard QuestSwiftRuntime.shared.platformServices.isUserInteractionEnabled,
          let object = QuestSwiftRuntime.shared.object(at: index),
          object.isVisible, let config = object.config, config.canTarget else { return }
    try? QuestSwiftRuntime.shared.graphicEngine.scene.tapObject(.id(object.id))
    QuestSwiftRuntime.shared.prepareRenderScene()
}


@_cdecl("aethercircle_swift_user_interaction_enabled")
public func aethercircleSwiftUserInteractionEnabled() -> Int32 {
    QuestSwiftRuntime.shared.platformServices.isUserInteractionEnabled ? 1 : 0
}

@_cdecl("aethercircle_swift_quit_requested")
public func aethercircleSwiftQuitRequested() -> Int32 {
    QuestSwiftRuntime.shared.platformServices.quitRequested ? 1 : 0
}

@_cdecl("aethercircle_swift_object_texture")
public func aethercircleSwiftObjectTexture(
    _ index: Int32, _ buffer: UnsafeMutablePointer<CChar>?, _ capacity: Int32
) -> Int32 {
    let runtime = QuestSwiftRuntime.shared
    let material = runtime.material(at: index)
    var filename = material.flatMap { runtime.assetEngine.surface(for: $0).baseColorTexture } ?? ""
    if index <= -10 && index >= -17, case .file(let name)? = runtime.galleryImage(at: index) { filename = name }
    if let key = runtime.registeredImageKey(at: index),
       let entry = runtime.assetEngine.imageRegistry.entry(for: key), case .data = entry.image {
        filename = "@image:\(key):\(entry.revision)"
    }
    if let key = runtime.registeredImageKey(at: index),
       case .file(let name)? = runtime.assetEngine.registeredImage(for: key) { filename = name }
    let bytes = Array(filename.utf8)
    if let buffer, capacity > 0 {
        let count = min(bytes.count, Int(capacity) - 1)
        for i in 0..<count { buffer[i] = CChar(bitPattern: bytes[i]) }
        buffer[count] = 0
    }
    return Int32(bytes.count)
}
@_cdecl("aethercircle_swift_set_passthrough_supported")
public func aethercircleSwiftSetPassthroughSupported(_ supported: Int32) {
    QuestSwiftRuntime.shared.supportsPassthrough = supported != 0
}

@_cdecl("aethercircle_swift_passthrough_requested")
public func aethercircleSwiftPassthroughRequested() -> Int32 {
    QuestSwiftRuntime.shared.environmentEngine.mode == .passthrough ? 1 : 0
}



/// Encoded registered image bytes are copied through the native bridge only
/// when its revision changes. Bundled file images use the normal asset loader.
@_cdecl("aethercircle_swift_object_texture_bytes")
public func aethercircleSwiftObjectTextureBytes(
    _ index: Int32, _ buffer: UnsafeMutablePointer<CChar>?, _ capacity: Int32
) -> Int32 {
    let runtime = QuestSwiftRuntime.shared
    guard let key = runtime.registeredImageKey(at: index),
          case .data(let data)? = runtime.assetEngine.registeredImage(for: key),
          data.count <= Int(Int32.max) else { return 0 }
    if let buffer, capacity > 0 {
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            if let base = bytes.baseAddress {
                UnsafeMutableRawPointer(buffer).copyMemory(from: base, byteCount: min(data.count, Int(capacity)))
            }
        }
    }
    return Int32(data.count)
}

private struct QuestArrangementDrag {
    let arrangement: AetherBaseArrangement
    let start: AetherPosition3D
}
nonisolated(unsafe) private var questArrangementDrags: [Int32: QuestArrangementDrag] = [:]

/// Returns 1 when a trigger press starts dragging an arrangement's move bar.
@_cdecl("aethercircle_swift_begin_arrangement_drag")
public func aethercircleSwiftBeginArrangementDrag(_ index: Int32, _ hand: Int32) -> Int32 {
    let runtime = QuestSwiftRuntime.shared
    guard runtime.platformServices.isUserInteractionEnabled,
          let target = runtime.object(at: index),
          let bar = AetherArrangementBar.containing(target.id, in: runtime.graphicEngine.scene.objects),
          let arrangement = bar.movementArrangement(for: target.id),
          !questArrangementDrags.values.contains(where: { $0.arrangement === arrangement }) else { return 0 }
    questArrangementDrags[hand] = QuestArrangementDrag(arrangement: arrangement, start: arrangement.position)
    return 1
}

@_cdecl("aethercircle_swift_update_arrangement_drag")
public func aethercircleSwiftUpdateArrangementDrag(
    _ hand: Int32, _ x: Float, _ y: Float, _ z: Float
) {
    guard QuestSwiftRuntime.shared.platformServices.isUserInteractionEnabled,
          let drag = questArrangementDrags[hand] else { return }
    drag.arrangement.move(to: AetherPosition3D(
        x: drag.start.x + x, y: drag.start.y + y, z: drag.start.z + z
    ))
}

@_cdecl("aethercircle_swift_end_arrangement_drag")
public func aethercircleSwiftEndArrangementDrag(_ hand: Int32) {
    questArrangementDrags.removeValue(forKey: hand)
}

/// Resolves both hands before changing visibility, since rebuilding changes render indices.
/// Returns 1 when the caller must refresh its transform cache.
@_cdecl("aethercircle_swift_arrangement_hover")
public func aethercircleSwiftArrangementHover(_ left: Int32, _ right: Int32) -> Int32 {
    let runtime = QuestSwiftRuntime.shared
    let roots = runtime.graphicEngine.scene.objects
    let bars = [left, right].compactMap { index -> AetherArrangementBar? in
        guard runtime.platformServices.isUserInteractionEnabled,
              let object = runtime.object(at: index) else { return nil }
        return AetherArrangementBar.containing(object.id, in: roots)
    }
    var changed = false
    func visit(_ object: AetherBasicObject) {
        if let bar = object as? AetherArrangementBar {
            let hovered = bars.contains { $0 === bar }
            if bar.setHovered(hovered) { changed = true }
        }
        if let group = object as? AetherCompositeObject {
            for child in group.children { visit(child) }
        }
    }
    for root in roots { visit(root) }
    if changed { runtime.prepareRenderScene() }
    return changed ? 1 : 0
}
