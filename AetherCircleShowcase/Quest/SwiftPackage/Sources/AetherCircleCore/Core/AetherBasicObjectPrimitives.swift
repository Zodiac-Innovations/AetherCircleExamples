//
//  AetherBasicObjectPrimitives.swift
//  AetherCircleCore
//
//  Convenience constructors for geometric AetherCircle objects
//

// MARK: Extension

public extension AetherBasicObject {

    /// Creates a rectangular box.
    static func box(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .box,
            size: size,
            material: material
        )
    }

    /// Creates a hemisphere.
    static func hemisphere(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        uniformShape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .hemisphere,
            size: diameter,
            material: material
        )
    }

    /// Creates an ellipsoid.
    static func ellipsoid(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .ellipsoid,
            size: size,
            material: material
        )
    }

    /// Creates a cylinder.
    static func cylinder(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .cylinder,
            size: AetherSize3D(
                x: diameter,
                y: height,
                z: diameter
            ),
            material: material
        )
    }

    /// Creates a cone.
    static func cone(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .cone,
            size: AetherSize3D(
                x: diameter,
                y: height,
                z: diameter
            ),
            material: material
        )
    }

    /// Creates a capsule.
    static func capsule(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .capsule,
            size: AetherSize3D(
                x: diameter,
                y: height,
                z: diameter
            ),
            material: material
        )
    }

    /// Creates a square-based pyramid.
    static func pyramid(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .pyramid,
            size: size,
            material: material
        )
    }

    /// Creates a tetrahedron.
    static func tetrahedron(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .tetrahedron,
            size: size,
            material: material
        )
    }

    /// Creates an octahedron.
    static func octahedron(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .octahedron,
            size: size,
            material: material
        )
    }

    /// Creates an octahedron using the familiar diamond name.
    static func diamond(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        octahedron(
            tag: tag,
            name: name,
            autoID: autoID,
            size: size,
            material: material
        )
    }

    /// Creates a wedge.
    static func wedge(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .wedge,
            size: size,
            material: material
        )
    }

    /// Creates a regular six-sided prism.
    static func prism(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .prism,
            size: size,
            material: material
        )
    }

    /// Creates a torus.
    static func torus(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .torus,
            size: size,
            material: material
        )
    }

    /// Creates a flat rectangular plane.
    static func plane(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        width: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .plane,
            size: AetherSize3D(
                x: width,
                y: height,
                z: 0
            ),
            material: material
        )
    }

    /// Creates a flat triangle.
    static func triangle(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        width: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .triangle,
            size: AetherSize3D(
                x: width,
                y: height,
                z: 0
            ),
            material: material
        )
    }

    /// Creates a flat filled disc.
    static func disc(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .disc,
            size: AetherSize3D(
                x: diameter,
                y: diameter,
                z: 0
            ),
            material: material
        )
    }

    /// Creates a flat circular ring.
    static func ring(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: .ring,
            size: AetherSize3D(
                x: diameter,
                y: diameter,
                z: 0
            ),
            material: material
        )
    }

    /// Creates an object from any primitive and size.
    static func shape(
        tag: Int = 0,
        name: String = "",
        autoID: String = "",
        primitive: AetherPrimitive,
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherBasicObject {
        AetherBasicObject(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: primitive,
            size: size,
            material: material
        )
    }

    /// Creates a uniformly sized object from a primitive.
    private static func uniformShape(
        tag: Int,
        name: String,
        autoID: String,
        primitive: AetherPrimitive,
        size: AetherFloat,
        material: AetherMaterial
    ) -> AetherBasicObject {
        shape(
            tag: tag,
            name: name,
            autoID: autoID,
            primitive: primitive,
            size: AetherSize3D(
                x: size,
                y: size,
                z: size
            ),
            material: material
        )
    }
}

