import Foundation
import Dispatch

/// A single synchronous automation operation.
public protocol AetherAutomationInvocable: Sendable {
    func invoke() throws
}

/// Blocks only the calling thread for the requested number of seconds.
public struct AetherAutomationWait: AetherAutomationInvocable {
    public let seconds: TimeInterval
    public init(seconds: TimeInterval) { self.seconds = seconds }
    public func invoke() throws {
        guard seconds.isFinite, seconds >= 0 else { throw AetherAutomationError.invalidWait }
        Thread.sleep(forTimeInterval: seconds)
    }
}

/// Invokes an element's activation action on the platform frame thread.
public struct AetherAutomationTap: AetherAutomationInvocable {
    public let platform: any AetherPlatform
    public let target: AetherAutomationTarget
    public init(platform: any AetherPlatform, target: AetherAutomationTarget) {
        self.platform = platform
        self.target = target
    }
    public func invoke() throws {
        try AetherAutomationCommand.activate(target).invoke(on: platform)
    }
}

public struct AetherAutomationInteraction: AetherAutomationInvocable {
    public let platform: any AetherPlatform
    public let enabled: Bool
    public init(platform: any AetherPlatform, enabled: Bool) {
        self.platform = platform
        self.enabled = enabled
    }
    public func invoke() throws {
        try AetherAutomationCommand.setUserInteractionEnabled(enabled).invoke(on: platform)
    }
}

public struct AetherAutomationMessage: AetherAutomationInvocable {
    public let platform: any AetherPlatform
    public let text: String
    public init(platform: any AetherPlatform, text: String) {
        self.platform = platform
        self.text = text
    }
    public func invoke() throws {
        try AetherAutomationCommand.message(text).invoke(on: platform)
    }
}

public struct AetherAutomationCheck: AetherAutomationInvocable {
    public let platform: any AetherPlatform
    public let target: AetherAutomationTarget
    public let expected: String
    public init(platform: any AetherPlatform, target: AetherAutomationTarget, expected: String) {
        self.platform = platform
        self.target = target
        self.expected = expected
    }
    public func invoke() throws {
        try AetherAutomationCommand.check(target, expected).invoke(on: platform)
    }
}

public extension AetherAutomationCommand {
    /// Execute one command synchronously. Tap and interaction calls must originate
    /// on a worker thread: they wait for the existing frame-driven dispatcher.
    func invoke(on platform: any AetherPlatform) throws {
        if case .wait(let seconds) = self {
            try AetherAutomationWait(seconds: seconds).invoke()
            return
        }
        guard !Thread.isMainThread,
              Thread.current.threadDictionary["AetherCircle.Automation.FrameThread"] == nil else {
            throw AetherAutomationError.requiresBackgroundThread
        }
        let completion = InvocationCompletion()
        Task.detached {
            do {
                try await platform.runScript(AetherAutomationScript(commands: [self], turnsOffInteraction: false))
                completion.finish(.success(()))
            } catch {
                completion.finish(.failure(error))
            }
        }
        try completion.wait()
    }
}

/// The worker waits here; the Swift task and the platform frame thread stay free.
private final class InvocationCompletion: @unchecked Sendable {
    private let semaphore = DispatchSemaphore(value: 0)
    private let lock = NSLock()
    private var result: Result<Void, any Error>?

    func finish(_ result: Result<Void, any Error>) {
        lock.lock()
        self.result = result
        lock.unlock()
        semaphore.signal()
    }

    func wait() throws {
        semaphore.wait()
        lock.lock()
        let result = self.result!
        lock.unlock()
        try result.get()
    }
}
