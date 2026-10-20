import Foundation

/// Rectangular room dimensions in millimeters. Floor is y=0; x/z are centered
/// on the scene origin. Front is negative Z. Renderers and object positions use meters.
public struct AetherRoom: Sendable, Codable, Hashable {
    public let width: AetherFloat
    public let height: AetherFloat
    public let depth: AetherFloat

    public enum Surface: Int, CaseIterable, Sendable, Codable {
        case floor, front, right, back, left, ceiling
    }

    /// All dimensions must be finite and greater than zero.
    public init(width: AetherFloat, height: AetherFloat, depth: AetherFloat) {
        precondition([width, height, depth].allSatisfy { $0.isFinite && $0 > 0 },
                     "Room dimensions must be finite positive millimeters.")
        self.width = width
        self.height = height
        self.depth = depth
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let width = try values.decode(AetherFloat.self, forKey: .width)
        let height = try values.decode(AetherFloat.self, forKey: .height)
        let depth = try values.decode(AetherFloat.self, forKey: .depth)
        guard [width, height, depth].allSatisfy({ $0.isFinite && $0 > 0 }) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                debugDescription: "Room dimensions must be finite positive millimeters."))
        }
        self.init(width: width, height: height, depth: depth)
    }

    /// Center of a surface in scene coordinates, measured in meters.
    public func center(of surface: Surface) -> AetherPosition3D {
        let w = width / 1000, h = height / 1000, d = depth / 1000
        switch surface {
        case .floor: return .init(x: 0, y: 0, z: 0)
        case .ceiling: return .init(x: 0, y: h, z: 0)
        case .front: return .init(x: 0, y: h / 2, z: -d / 2)
        case .back: return .init(x: 0, y: h / 2, z: d / 2)
        case .left: return .init(x: -w / 2, y: h / 2, z: 0)
        case .right: return .init(x: w / 2, y: h / 2, z: 0)
        }
    }

    /// Width/height of a surface's local XY plane in meters (zero thickness).
    public func size(of surface: Surface) -> AetherSize3D {
        switch surface {
        case .floor, .ceiling: return .init(x: width / 1000, y: depth / 1000, z: 0)
        case .front, .back: return .init(x: width / 1000, y: height / 1000, z: 0)
        case .left, .right: return .init(x: depth / 1000, y: height / 1000, z: 0)
        }
    }

    /// Euler radians orient a local XY surface's +Z normal toward the room interior.
    public func rotation(of surface: Surface) -> AetherRotation3D {
        switch surface {
        case .front: return .zero
        case .back: return .init(x: 0, y: .pi, z: 0)
        case .left: return .init(x: 0, y: .pi / 2, z: 0)
        case .right: return .init(x: 0, y: -.pi / 2, z: 0)
        case .floor: return .init(x: -.pi / 2, y: 0, z: 0)
        case .ceiling: return .init(x: .pi / 2, y: 0, z: 0)
        }
    }

    public func inwardNormal(of surface: Surface) -> AetherVector3 {
        switch surface {
        case .floor: return .up
        case .ceiling: return .down
        case .front: return .backward
        case .back: return .forward
        case .left: return .right
        case .right: return .left
        }
    }
}

/// Independent materials for the six surfaces. Textures tile once per meter.
public struct AetherRoomMaterials: Sendable, Codable, Hashable {
    public var floor: AetherMaterial
    public var front: AetherMaterial
    public var right: AetherMaterial
    public var back: AetherMaterial
    public var left: AetherMaterial
    public var ceiling: AetherMaterial

    public init(floor: AetherMaterial, front: AetherMaterial, right: AetherMaterial,
                back: AetherMaterial, left: AetherMaterial, ceiling: AetherMaterial) {
        self.floor = floor; self.front = front; self.right = right
        self.back = back; self.left = left; self.ceiling = ceiling
    }

    /// Convenience initializer giving all four walls the same material.
    public init(floor: AetherMaterial, walls: AetherMaterial, ceiling: AetherMaterial) {
        self.init(floor: floor, front: walls, right: walls, back: walls, left: walls, ceiling: ceiling)
    }

    public subscript(surface: AetherRoom.Surface) -> AetherMaterial {
        switch surface {
        case .floor: return floor
        case .front: return front
        case .right: return right
        case .back: return back
        case .left: return left
        case .ceiling: return ceiling
        }
    }
}

/// Initial placement for a 2D or 3D object on a room surface. This does not
/// attach or add the object. Apply position/rotation to the object explicitly.
public struct AetherRoomPlacement: Sendable, Codable, Hashable {
    public let position: AetherPosition3D
    public let rotation: AetherRotation3D

    /// Positive inset moves the object's center into the room. For a thick 3D
    /// object, use at least half its depth to keep it clear of the wall.
    public init(room: AetherRoom, surface: AetherRoom.Surface, insetMillimeters: AetherFloat = 0) {
        precondition(insetMillimeters.isFinite && insetMillimeters >= 0)
        let center = room.center(of: surface), normal = room.inwardNormal(of: surface)
        let inset = insetMillimeters / 1000
        position = .init(x: center.x + normal.x * inset,
                         y: center.y + normal.y * inset, z: center.z + normal.z * inset)
        rotation = room.rotation(of: surface)
    }
}
