//
//  AetherCircleVector.swift
//  AetherCircle
//
//  Platform-independent vector drawing definitions.
//  Keep this contract identical across projects after substituting the project prefix.
//

import Foundation

// MARK: - Geometry

/// A point in a vector drawing's local coordinate system.
public struct AetherCirclePoint: Codable, Sendable, Equatable {
    public var x: AetherCircleFloat
    public var y: AetherCircleFloat

    public init(x: AetherCircleFloat, y: AetherCircleFloat) {
        self.x = x
        self.y = y
    }
}

/// A size in a vector drawing's local coordinate system.
public struct AetherCircleSize: Codable, Sendable, Equatable {
    public var width: AetherCircleFloat
    public var height: AetherCircleFloat

    public init(width: AetherCircleFloat, height: AetherCircleFloat) {
        self.width = width
        self.height = height
    }
}

/// A rectangle in a vector drawing's local coordinate system.
public struct AetherCircleRect: Codable, Sendable, Equatable {
    public var origin: AetherCirclePoint
    public var size: AetherCircleSize

    public init(origin: AetherCirclePoint, size: AetherCircleSize) {
        self.origin = origin
        self.size = size
    }

    public init(x: AetherCircleFloat, y: AetherCircleFloat, width: AetherCircleFloat, height: AetherCircleFloat) {
        self.init(origin: AetherCirclePoint(x: x, y: y), size: AetherCircleSize(width: width, height: height))
    }
}

// MARK: - Stroke and Fill

public enum AetherCircleVectorLineCap: String, Codable, Sendable, Equatable {
    case butt
    case round
    case square
}

public enum AetherCircleVectorLineJoin: String, Codable, Sendable, Equatable {
    case miter
    case round
    case bevel
}

public enum AetherCircleVectorLinePattern: Codable, Sendable, Equatable {
    case solid
    case dashed(lengths: [AetherCircleFloat], phase: AetherCircleFloat = 0)
}

public struct AetherCircleVectorStroke: Codable, Sendable, Equatable {
    public var material: AetherCircleMaterial
    public var thickness: AetherCircleFloat
    public var pattern: AetherCircleVectorLinePattern
    public var cap: AetherCircleVectorLineCap
    public var join: AetherCircleVectorLineJoin

    public init(
        material: AetherCircleMaterial = .black,
        thickness: AetherCircleFloat = 1,
        pattern: AetherCircleVectorLinePattern = .solid,
        cap: AetherCircleVectorLineCap = .butt,
        join: AetherCircleVectorLineJoin = .miter
    ) {
        self.material = material
        self.thickness = max(0, thickness)
        self.pattern = pattern
        self.cap = cap
        self.join = join
    }

    public init(
        color: AetherCircleColor,
        thickness: AetherCircleFloat = 1,
        pattern: AetherCircleVectorLinePattern = .solid,
        cap: AetherCircleVectorLineCap = .butt,
        join: AetherCircleVectorLineJoin = .miter
    ) {
        self.init(
            material: .color(color),
            thickness: thickness,
            pattern: pattern,
            cap: cap,
            join: join
        )
    }
}

public enum AetherCircleVectorFillPattern: Codable, Sendable, Equatable {
    case material(AetherCircleMaterial)
    case solid(AetherCircleColor)
}

public struct AetherCircleVectorFill: Codable, Sendable, Equatable {
    public var pattern: AetherCircleVectorFillPattern

    public init(pattern: AetherCircleVectorFillPattern) {
        self.pattern = pattern
    }

    public init(material: AetherCircleMaterial) {
        self.pattern = .material(material)
    }

    public init(color: AetherCircleColor) {
        self.pattern = .material(.color(color))
    }
}

// MARK: - Drawing Behavior

public enum AetherCircleVectorArcDirection: String, Codable, Sendable, Equatable {
    case clockwise
    case counterclockwise
}

public enum AetherCircleVectorContentMode: String, Codable, Sendable, Equatable {
    case fit
    case fill
    case stretch
    case original
}

public enum AetherCircleVectorAlignment: String, Codable, Sendable, Equatable {
    case topLeading
    case top
    case topTrailing
    case leading
    case center
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing
}

/// Issues platform-independent drawing commands in a local coordinate system.
/// The origin is at the upper-left, positive x extends right, and positive y extends down.
public protocol AetherCircleVectorDrawingProtocol: AnyObject {
    /// The logical bounds visible to drawing commands, independent of physical output size.
    var bounds: AetherCircleRect { get }

    func drawLine(from start: AetherCirclePoint, to end: AetherCirclePoint, stroke: AetherCircleVectorStroke)
    func drawRectangle(in rect: AetherCircleRect, stroke: AetherCircleVectorStroke?, fill: AetherCircleVectorFill?)
    func drawRoundedRectangle(
        in rect: AetherCircleRect,
        cornerRadius: AetherCircleFloat,
        stroke: AetherCircleVectorStroke?,
        fill: AetherCircleVectorFill?
    )
    func drawOval(in rect: AetherCircleRect, stroke: AetherCircleVectorStroke?, fill: AetherCircleVectorFill?)

    /// Draws an arc whose zero-degree angle points right. Positive angles follow the clockwise
    /// direction of the local coordinate system unless `direction` specifies otherwise.
    func drawArc(
        center: AetherCirclePoint,
        radius: AetherCircleFloat,
        startAngle: AetherCircleFloat,
        endAngle: AetherCircleFloat,
        direction: AetherCircleVectorArcDirection,
        stroke: AetherCircleVectorStroke
    )

    func drawPolygon(
        points: [AetherCirclePoint],
        stroke: AetherCircleVectorStroke?,
        fill: AetherCircleVectorFill?
    )
    func drawQuadraticBezier(
        from start: AetherCirclePoint,
        control: AetherCirclePoint,
        to end: AetherCirclePoint,
        stroke: AetherCircleVectorStroke
    )
    func drawCubicBezier(
        from start: AetherCirclePoint,
        control1: AetherCirclePoint,
        control2: AetherCirclePoint,
        to end: AetherCirclePoint,
        stroke: AetherCircleVectorStroke
    )

    /// Draws bitmap data, optionally cropping it with `sourceRect`, into `destinationRect`.
    func drawBitmap(
        data: Data,
        sourceRect: AetherCircleRect?,
        destinationRect: AetherCircleRect,
        opacity: AetherCircleFloat
    )

    /// Offers opaque developer-defined data to a specialized drawer.
    /// Returns true when the drawer recognizes and handles the command.
    @discardableResult
    func drawSpecialData(type: String, data: String) -> Bool
    /// Draws bitmap content using a material as its tint/mask paint.
    /// Returns false when this backend does not implement painted bitmap drawing.
    @discardableResult
    func drawBitmap(
        data: Data,
        sourceRect: AetherCircleRect?,
        destinationRect: AetherCircleRect,
        opacity: AetherCircleFloat,
        material: AetherCircleMaterial
    ) -> Bool

    /// Offers a specialized command together with its paint.
    /// Returns false when the backend does not handle this painted command.
    @discardableResult
    func drawSpecialData(type: String, data: String, material: AetherCircleMaterial) -> Bool

}

public extension AetherCircleVectorDrawingProtocol {
    @discardableResult
    func drawSpecialData(type: String, data: String) -> Bool {
        false
    }
}

/// Reusable drawing code that can target a native drawer or a recorder.
public typealias AetherCircleVectorDrawingClosure = (_ drawer: any AetherCircleVectorDrawingProtocol) -> Void

// MARK: - Direct Color and Material Drawing

public extension AetherCircleVectorDrawingProtocol {

    func drawLine(from start: AetherCirclePoint, to end: AetherCirclePoint, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1) {
        drawLine(from: start, to: end, stroke: AetherCircleVectorStroke(material: material, thickness: thickness))
    }

    func drawLine(from start: AetherCirclePoint, to end: AetherCirclePoint, color: AetherCircleColor, thickness: AetherCircleFloat = 1) {
        drawLine(from: start, to: end, material: .color(color), thickness: thickness)
    }

    /// Draws this shape with independent outline and interior materials.
    /// Nil omits the corresponding outline or fill.
    func drawRectangle(in rect: AetherCircleRect, strokeMaterial: AetherCircleMaterial?, fillMaterial: AetherCircleMaterial?, thickness: AetherCircleFloat = 1) {
        drawRectangle(in: rect, stroke: strokeMaterial.map { AetherCircleVectorStroke(material: $0, thickness: thickness) }, fill: fillMaterial.map { AetherCircleVectorFill(material: $0) })
    }

    func drawRectangle(in rect: AetherCircleRect, strokeColor: AetherCircleColor?, fillColor: AetherCircleColor?, thickness: AetherCircleFloat = 1) {
        drawRectangle(in: rect, strokeMaterial: strokeColor.map { AetherCircleMaterial.color($0) }, fillMaterial: fillColor.map { AetherCircleMaterial.color($0) }, thickness: thickness)
    }

    /// Filled shapes use the material for their interior; unfilled shapes use it for their outline.
    func drawRectangle(in rect: AetherCircleRect, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawRectangle(in: rect, strokeMaterial: filled ? nil : material, fillMaterial: filled ? material : nil, thickness: thickness)
    }

    func drawRectangle(in rect: AetherCircleRect, color: AetherCircleColor, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawRectangle(in: rect, material: .color(color), thickness: thickness, filled: filled)
    }

    /// Draws this shape with independent outline and interior materials.
    /// Nil omits the corresponding outline or fill.
    func drawRoundedRectangle(in rect: AetherCircleRect, cornerRadius: AetherCircleFloat, strokeMaterial: AetherCircleMaterial?, fillMaterial: AetherCircleMaterial?, thickness: AetherCircleFloat = 1) {
        drawRoundedRectangle(in: rect, cornerRadius: cornerRadius, stroke: strokeMaterial.map { AetherCircleVectorStroke(material: $0, thickness: thickness) }, fill: fillMaterial.map { AetherCircleVectorFill(material: $0) })
    }

    func drawRoundedRectangle(in rect: AetherCircleRect, cornerRadius: AetherCircleFloat, strokeColor: AetherCircleColor?, fillColor: AetherCircleColor?, thickness: AetherCircleFloat = 1) {
        drawRoundedRectangle(in: rect, cornerRadius: cornerRadius, strokeMaterial: strokeColor.map { AetherCircleMaterial.color($0) }, fillMaterial: fillColor.map { AetherCircleMaterial.color($0) }, thickness: thickness)
    }

    /// Filled shapes use the material for their interior; unfilled shapes use it for their outline.
    func drawRoundedRectangle(in rect: AetherCircleRect, cornerRadius: AetherCircleFloat, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawRoundedRectangle(in: rect, cornerRadius: cornerRadius, strokeMaterial: filled ? nil : material, fillMaterial: filled ? material : nil, thickness: thickness)
    }

    func drawRoundedRectangle(in rect: AetherCircleRect, cornerRadius: AetherCircleFloat, color: AetherCircleColor, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawRoundedRectangle(in: rect, cornerRadius: cornerRadius, material: .color(color), thickness: thickness, filled: filled)
    }

    /// Draws this shape with independent outline and interior materials.
    /// Nil omits the corresponding outline or fill.
    func drawOval(in rect: AetherCircleRect, strokeMaterial: AetherCircleMaterial?, fillMaterial: AetherCircleMaterial?, thickness: AetherCircleFloat = 1) {
        drawOval(in: rect, stroke: strokeMaterial.map { AetherCircleVectorStroke(material: $0, thickness: thickness) }, fill: fillMaterial.map { AetherCircleVectorFill(material: $0) })
    }

    func drawOval(in rect: AetherCircleRect, strokeColor: AetherCircleColor?, fillColor: AetherCircleColor?, thickness: AetherCircleFloat = 1) {
        drawOval(in: rect, strokeMaterial: strokeColor.map { AetherCircleMaterial.color($0) }, fillMaterial: fillColor.map { AetherCircleMaterial.color($0) }, thickness: thickness)
    }

    /// Filled shapes use the material for their interior; unfilled shapes use it for their outline.
    func drawOval(in rect: AetherCircleRect, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawOval(in: rect, strokeMaterial: filled ? nil : material, fillMaterial: filled ? material : nil, thickness: thickness)
    }

    func drawOval(in rect: AetherCircleRect, color: AetherCircleColor, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawOval(in: rect, material: .color(color), thickness: thickness, filled: filled)
    }

    func drawArc(center: AetherCirclePoint, radius: AetherCircleFloat, startAngle: AetherCircleFloat, endAngle: AetherCircleFloat, direction: AetherCircleVectorArcDirection, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1) {
        drawArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, direction: direction, stroke: AetherCircleVectorStroke(material: material, thickness: thickness))
    }

    func drawArc(center: AetherCirclePoint, radius: AetherCircleFloat, startAngle: AetherCircleFloat, endAngle: AetherCircleFloat, direction: AetherCircleVectorArcDirection, color: AetherCircleColor, thickness: AetherCircleFloat = 1) {
        drawArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, direction: direction, material: .color(color), thickness: thickness)
    }

    /// Draws this shape with independent outline and interior materials.
    /// Nil omits the corresponding outline or fill.
    func drawPolygon(points: [AetherCirclePoint], strokeMaterial: AetherCircleMaterial?, fillMaterial: AetherCircleMaterial?, thickness: AetherCircleFloat = 1) {
        drawPolygon(points: points, stroke: strokeMaterial.map { AetherCircleVectorStroke(material: $0, thickness: thickness) }, fill: fillMaterial.map { AetherCircleVectorFill(material: $0) })
    }

    func drawPolygon(points: [AetherCirclePoint], strokeColor: AetherCircleColor?, fillColor: AetherCircleColor?, thickness: AetherCircleFloat = 1) {
        drawPolygon(points: points, strokeMaterial: strokeColor.map { AetherCircleMaterial.color($0) }, fillMaterial: fillColor.map { AetherCircleMaterial.color($0) }, thickness: thickness)
    }

    /// Filled shapes use the material for their interior; unfilled shapes use it for their outline.
    func drawPolygon(points: [AetherCirclePoint], material: AetherCircleMaterial, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawPolygon(points: points, strokeMaterial: filled ? nil : material, fillMaterial: filled ? material : nil, thickness: thickness)
    }

    func drawPolygon(points: [AetherCirclePoint], color: AetherCircleColor, thickness: AetherCircleFloat = 1, filled: Bool = true) {
        drawPolygon(points: points, material: .color(color), thickness: thickness, filled: filled)
    }

    func drawQuadraticBezier(from start: AetherCirclePoint, control: AetherCirclePoint, to end: AetherCirclePoint, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1) {
        drawQuadraticBezier(from: start, control: control, to: end, stroke: AetherCircleVectorStroke(material: material, thickness: thickness))
    }

    func drawQuadraticBezier(from start: AetherCirclePoint, control: AetherCirclePoint, to end: AetherCirclePoint, color: AetherCircleColor, thickness: AetherCircleFloat = 1) {
        drawQuadraticBezier(from: start, control: control, to: end, material: .color(color), thickness: thickness)
    }

    func drawCubicBezier(from start: AetherCirclePoint, control1: AetherCirclePoint, control2: AetherCirclePoint, to end: AetherCirclePoint, material: AetherCircleMaterial, thickness: AetherCircleFloat = 1) {
        drawCubicBezier(from: start, control1: control1, control2: control2, to: end, stroke: AetherCircleVectorStroke(material: material, thickness: thickness))
    }

    func drawCubicBezier(from start: AetherCirclePoint, control1: AetherCirclePoint, control2: AetherCirclePoint, to end: AetherCirclePoint, color: AetherCircleColor, thickness: AetherCircleFloat = 1) {
        drawCubicBezier(from: start, control1: control1, control2: control2, to: end, material: .color(color), thickness: thickness)
    }

    /// Default implementations explicitly report unsupported painted bitmap/special operations.
    @discardableResult
    func drawBitmap(data: Data, sourceRect: AetherCircleRect?, destinationRect: AetherCircleRect, opacity: AetherCircleFloat, material: AetherCircleMaterial) -> Bool {
        false
    }

    @discardableResult
    func drawBitmap(data: Data, sourceRect: AetherCircleRect?, destinationRect: AetherCircleRect, opacity: AetherCircleFloat, color: AetherCircleColor) -> Bool {
        drawBitmap(data: data, sourceRect: sourceRect, destinationRect: destinationRect, opacity: opacity, material: .color(color))
    }

    @discardableResult
    func drawSpecialData(type: String, data: String, material: AetherCircleMaterial) -> Bool {
        false
    }

    @discardableResult
    func drawSpecialData(type: String, data: String, color: AetherCircleColor) -> Bool {
        drawSpecialData(type: type, data: data, material: .color(color))
    }
}
