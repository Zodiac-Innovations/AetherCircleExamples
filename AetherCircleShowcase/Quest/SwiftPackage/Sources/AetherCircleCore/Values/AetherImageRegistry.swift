import Foundation

/// Encoded JPEG/PNG bytes, or the name of a bundled image. Downloaded images
/// are registered as data after the application finishes downloading them.
public enum AetherImageResource: Sendable, Codable, Hashable {
    case file(String)
    case data(Data)
}

/// Per-asset-engine, thread-safe storage. A revision changes on replacement so
/// renderers cannot accidentally reuse an earlier image under the same key.
public final class AetherImageRegistry: @unchecked Sendable {
    public struct Entry: Sendable {
        public let image: AetherImageResource
        public let revision: UInt64
    }

    private let lock = NSLock()
    private var images: [String: Entry] = [:]
    private var revision: UInt64 = 0

    public init() {}

    @discardableResult
    public func register(key: String, image: AetherImageResource) -> Bool {
        guard !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        switch image {
        case .file(let name):
            guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        case .data(let data):
            guard !data.isEmpty else { return false }
        }
        lock.lock()
        defer { lock.unlock() }
        revision &+= 1
        images[key] = Entry(image: image, revision: revision)
        return true
    }

    public func entry(for key: String) -> Entry? {
        lock.lock()
        defer { lock.unlock() }
        return images[key]
    }

    public func remove(key: String) {
        lock.lock()
        defer { lock.unlock() }
        images.removeValue(forKey: key)
    }
}
