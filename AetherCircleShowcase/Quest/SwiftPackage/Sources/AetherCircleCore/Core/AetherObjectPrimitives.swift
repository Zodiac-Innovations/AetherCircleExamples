//
//  AetherObjectPrimitives.swift
//  AetherCircleCore
//
//  Convenience constructors for geometric AetherCircle objects
//

// MARK: Extension

public extension AetherObject {

    /// Creates a rectangular box.
    static func box(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .box,
            size: size,
            material: material
        )
    }

    /// Creates a hemisphere.
    static func hemisphere(
        tag: Int = 0,
        name: String = "",
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        uniformShape(
            tag: tag,
            name: name,
            primitive: .hemisphere,
            size: diameter,
            material: material
        )
    }

    /// Creates an ellipsoid.
    static func ellipsoid(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .ellipsoid,
            size: size,
            material: material
        )
    }

    /// Creates a cylinder.
    static func cylinder(
        tag: Int = 0,
        name: String = "",
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        diameter: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .pyramid,
            size: size,
            material: material
        )
    }

    /// Creates a tetrahedron.
    static func tetrahedron(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .tetrahedron,
            size: size,
            material: material
        )
    }

    /// Creates an octahedron.
    static func octahedron(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .octahedron,
            size: size,
            material: material
        )
    }

    /// Creates an octahedron using the familiar diamond name.
    static func diamond(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        octahedron(
            tag: tag,
            name: name,
            size: size,
            material: material
        )
    }

    /// Creates a wedge.
    static func wedge(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .wedge,
            size: size,
            material: material
        )
    }

    /// Creates a regular six-sided prism.
    static func prism(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .prism,
            size: size,
            material: material
        )
    }

    /// Creates a torus.
    static func torus(
        tag: Int = 0,
        name: String = "",
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
            primitive: .torus,
            size: size,
            material: material
        )
    }

    /// Creates a flat rectangular plane.
    static func plane(
        tag: Int = 0,
        name: String = "",
        width: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        width: AetherFloat,
        height: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        diameter: AetherFloat,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
        primitive: AetherPrimitive,
        size: AetherSize3D,
        material: AetherMaterial = .defaultObject
    ) -> AetherObject {
        AetherObject(
            tag: tag,
            name: name,
            primitive: primitive,
            size: size,
            material: material
        )
    }

    /// Creates a uniformly sized object from a primitive.
    private static func uniformShape(
        tag: Int,
        name: String,
        primitive: AetherPrimitive,
        size: AetherFloat,
        material: AetherMaterial
    ) -> AetherObject {
        shape(
            tag: tag,
            name: name,
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
