import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

    public enum DownloadError: Error, Equatable {
        case invalidKey
        case unsupportedURL
        case invalidResponse
        case httpStatus(Int)
        case unsupportedImageData
    }

    /// Downloads encoded JPEG/PNG bytes and publishes the registration only
    /// after the entire request succeeds. Failure preserves an existing image.
    @discardableResult
    public func register(key: String, from url: URL, session: URLSession = .shared) async throws -> Bool {
        guard !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw DownloadError.invalidKey }
        guard let scheme = url.scheme?.lowercased(), ["https", "http"].contains(scheme),
              url.host != nil else { throw DownloadError.unsupportedURL }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.setValue("AetherCircle/1.0", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await session.data(for: request)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else { throw DownloadError.invalidResponse }
        guard (200..<300).contains(response.statusCode) else { throw DownloadError.httpStatus(response.statusCode) }
        let jpeg = data.starts(with: [0xFF, 0xD8, 0xFF])
        let png = data.starts(with: [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        guard jpeg || png else { throw DownloadError.unsupportedImageData }
        return register(key: key, image: .data(data))
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
