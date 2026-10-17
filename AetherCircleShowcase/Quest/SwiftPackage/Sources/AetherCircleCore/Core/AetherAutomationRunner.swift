import Foundation

/// Submissions can arrive from any executor. Only the host's serialized frame
/// thread calls update(), so actions never escape onto a background Swift task.
public final class AetherAutomationRunner: @unchecked Sendable {
    private final class Run {
        let script: AetherAutomationScript
        let continuation: CheckedContinuation<Void, any Error>
        var index = 0
        var deadline: TimeInterval?
        var started = false
        var restoreInteraction: (() throws -> Void)?
        init(_ script: AetherAutomationScript, _ continuation: CheckedContinuation<Void, any Error>) {
            self.script = script
            self.continuation = continuation
        }
    }
    private let lock = NSLock()
    private var active: Run?

    public init() {}

    public var isRunning: Bool {
        lock.lock()
        defer { lock.unlock() }
        return active != nil
    }

    /// Returns when the sequence completes. Only one script may run per host.
    public func run(_ script: AetherAutomationScript) async throws {
        for command in script.commands {
            if case .wait(let seconds) = command, !seconds.isFinite || seconds < 0 {
                throw AetherAutomationError.invalidWait
            }
        }
        try Task.checkCancellation()
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
            lock.lock()
            guard active == nil else {
                lock.unlock()
                continuation.resume(throwing: AetherAutomationError.alreadyRunning)
                return
            }
            active = Run(script, continuation)
            lock.unlock()
        }
    }

    /// Call once per frame, using a monotonic timestamp. Callbacks run on the
    /// calling thread. A budget prevents long scripts from monopolizing a frame.
    public func update(
        now: TimeInterval,
        activate: (AetherAutomationTarget) throws -> Void,
        setInteractionEnabled: @escaping (Bool) throws -> Void,
        showMessage: (String) throws -> Void = { _ in }
    ) {
        Thread.current.threadDictionary["AetherCircle.Automation.FrameThread"] = true
        lock.lock()
        let run = active
        lock.unlock()
        guard let run else { return }
        do {
            if !run.started {
                run.started = true
                if run.script.turnsOffInteraction {
                    run.restoreInteraction = { try setInteractionEnabled(true) }
                    try setInteractionEnabled(false)
                }
            }
            for _ in 0..<256 {
                lock.lock()
                let stillActive = active === run
                lock.unlock()
                guard stillActive else { return }
                guard run.index < run.script.commands.count else {
                    finish(run, error: nil)
                    return
                }
                switch run.script.commands[run.index] {
                case .wait(let seconds):
                    let deadline = run.deadline ?? (now + seconds)
                    run.deadline = deadline
                    guard now >= deadline else { return }
                    run.deadline = nil
                case .message(let text): try showMessage(text)
                case .activate(let target): try activate(target)
                case .setUserInteractionEnabled(let enabled): try setInteractionEnabled(enabled)
                }
                run.index += 1
            }
        } catch { finish(run, error: error) }
    }

    /// Call on the frame thread when the host stops.
    public func stop() {
        lock.lock()
        let run = active
        lock.unlock()
        if let run { finish(run, error: AetherAutomationError.stopped) }
    }

    private func finish(_ run: Run, error: (any Error)?) {
        lock.lock()
        guard active === run else { lock.unlock(); return }
        active = nil
        lock.unlock()
        var resultError = error
        do { try run.restoreInteraction?() }
        catch { if resultError == nil { resultError = error } }
        run.restoreInteraction = nil
        if let resultError { run.continuation.resume(throwing: resultError) }
        else { run.continuation.resume() }
    }
}
