import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Reads standard GPano XMP crop dimensions from encoded JPEG/PNG image data.
/// Does not infer capture angles from pixel aspect ratio or focal length.
public enum AetherPanoramaMetadata {
    public static func horizontalDegrees(in data: Data) -> AetherFloat? {
        let text = String(decoding: data, as: UTF8.self)
        // Locate an XMP packet without asking an XML parser to consume image bytes.
        let pattern = #"<((?:[A-Za-z_][\w.-]*:)?xmpmeta)\b[\s\S]*?</\1\s*>"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        for match in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            guard let range = Range(match.range, in: text) else { continue }
            let reader = GPanoReader()
            let parser = XMLParser(data: Data(text[range].utf8))
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.delegate = reader
            guard parser.parse(),
                  let width = reader.values["CroppedAreaImageWidthPixels"],
                  let fullWidth = reader.values["FullPanoWidthPixels"],
                  width.isFinite, fullWidth.isFinite, width > 0, fullWidth >= width else { continue }
            let degrees = 360 * width / fullWidth
            guard degrees.isFinite, degrees > 0, degrees <= 360 else { continue }
            return AetherFloat(degrees)
        }
        return nil
    }

    /// An explicit override is validated by the geometry builder, never silently replaced.
    public static func resolvedHorizontalDegrees(override: AetherFloat? = nil, imageData: Data?) -> AetherFloat {
        if let override { return override }
        return imageData.flatMap { horizontalDegrees(in: $0) } ?? 270
    }
}

private final class GPanoReader: NSObject, XMLParserDelegate {
    private let namespace = "http://ns.google.com/photos/1.0/panorama/"
    private var prefixes: [String: String] = [:]
    private var field: String?
    private var text = ""
    var values: [String: Double] = [:]

    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        prefixes[prefix] = namespaceURI
    }
    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) { prefixes.removeValue(forKey: prefix) }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String: String]) {
        for (name, value) in attributes {
            let parts = name.split(separator: ":", maxSplits: 1).map(String.init)
            if parts.count == 2, prefixes[parts[0]] == namespace { values[parts[1]] = Double(value) }
        }
        field = namespaceURI == namespace ? elementName : nil
        text = ""
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) { if field != nil { text += string } }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let field, namespaceURI == namespace { values[field] = Double(text.trimmingCharacters(in: .whitespacesAndNewlines)) }
        field = nil
    }
}
