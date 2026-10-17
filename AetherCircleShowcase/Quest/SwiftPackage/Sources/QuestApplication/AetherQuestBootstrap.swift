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
        _ object: AetherObject,
        effect: AetherEffect
    ) {
        scene.add(object)
    }

    func changeRemoveObject(
        _ object: AetherObject,
        effect: AetherEffect
    ) {
        scene.remove(object)
    }
}

private final class QuestEnvironmentEngine: AetherEnvironmentEngine {
    var mode: AetherEnvironmentMode = .fullVR
}

private final class QuestAssetEngine: AetherAssetEngine {
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
    let appName = "AetherCircle Showcase"
    let appIdentifier = "com.zodiacinnovations.aethercircleshowcase"
    let appVersion = "0.1.0"
    let appBuild = "1"
    var platformName: String { "Meta Quest" }
    var platformType: AetherPlatformType { .quest }
    var deviceType: AetherDeviceType { .headset }
    var deviceManufacturer: String { "Meta" }
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
    let environmentEngine = QuestEnvironmentEngine()
    let assetEngine = QuestAssetEngine()
    let platformServices = QuestPlatform()
    private var application: AetherApplication?
    var renderObjects: [AetherObject] = []
    var renderParents: [Int32] = []

    func prepareRenderScene() {
        renderObjects.removeAll(keepingCapacity: true)
        renderParents.removeAll(keepingCapacity: true)
        func append(_ object: AetherObject, parent: Int32) {
            guard object.isVisible else { return }
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

        let world = AetherWorld(
            graphicEngine: graphicEngine,
            environmentEngine: environmentEngine,
            hudEngine: AetherHUDDummy(),
            clockEngine: AetherClockDummy(),
            assetEngine: assetEngine,
            capabilities: AetherCapabilities(
                coreLevel: .level1,
                supportsPassthrough: false,
                supportsFullVR: true,
                supportsHUD: false,
                supportsClock: false
            ),
            platform: platformServices
        )
        let application = AetherCircleShowcaseApplication(
            world: world,
            name: "AetherCircle Showcase"
        )
        self.application = application
        application.start()
        prepareRenderScene()
    }

    func stop() {
        application?.stop()
        application = nil
        graphicEngine.scene = AetherScene()
    }

    func object(at index: Int32) -> AetherObject? {
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
    default: return 0
    }
}

@_cdecl("aethercircle_swift_object_color")
public func aethercircleSwiftObjectColor(
    _ index: Int32,
    _ component: Int32
) -> Float {
    guard let object = QuestSwiftRuntime.shared.object(at: index) else {
        return 0
    }
    let color = QuestSwiftRuntime.shared.assetEngine.surface(for: object.material).baseColor
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
    QuestSwiftRuntime.shared.prepareRenderScene()
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
