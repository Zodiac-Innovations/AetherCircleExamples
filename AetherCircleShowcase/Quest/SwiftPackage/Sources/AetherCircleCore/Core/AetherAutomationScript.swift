import Foundation

public enum AetherAutomationTarget: Sendable, Equatable {
    case id(UUID)
    case tag(Int)
    case name(String)
    case title(String)
    case autoID(String)
}

public enum AetherAutomationCommand: Sendable, Equatable {
    case wait(TimeInterval)
    case message(String)
    case activate(AetherAutomationTarget)
    case check(AetherAutomationTarget, String)
    case setUserInteractionEnabled(Bool)
}

public enum AetherAutomationError: Error, Sendable, Equatable {
    case invalidLine(Int, String)
    case invalidWait
    case alreadyRunning
    case unsupported
    case targetNotFound
    case ambiguousTarget
    case cannotActivate
    case stopped
    case requiresBackgroundThread
    case checkFailed(AetherAutomationTarget, expected: String, actual: String?)
}

/// A reusable sequence of commands. Text is fully parsed before execution.
public struct AetherAutomationScript: Sendable, Equatable {
    public var commands: [AetherAutomationCommand]

    /// Automatically disables physical input at start and enables it on completion,
    /// failure, or host stop. Set false to manage interaction explicitly.
    public var turnsOffInteraction: Bool

    public init(commands: [AetherAutomationCommand], turnsOffInteraction: Bool = true) {
        self.commands = commands
        self.turnsOffInteraction = turnsOffInteraction
    }

    /// Converts text to a reusable script without executing it.
    public static func make(text: String, turnsOffInteraction: Bool = true) throws -> Self {
        try Self(text: text, turnsOffInteraction: turnsOffInteraction)
    }

    public init(text: String, turnsOffInteraction: Bool = true) throws {
        var commands: [AetherAutomationCommand] = []
        for (offset, line) in text.components(separatedBy: .newlines).enumerated() {
            let tokens = try Self.tokens(line, line: offset + 1)
            if tokens.isEmpty { continue }
            func invalid() -> AetherAutomationError {
                .invalidLine(offset + 1, line)
            }
            switch tokens.first {
            case "wait":
                guard tokens.count == 2, let seconds = Double(tokens[1]),
                      seconds.isFinite, seconds >= 0 else { throw invalid() }
                commands.append(.wait(seconds))
            case "tap", "check":
                let isCheck = tokens[0] == "check"
                guard tokens.count == (isCheck ? 4 : 3) else { throw invalid() }
                let value = tokens[2]
                let target: AetherAutomationTarget
                switch tokens[1] {
                case "id":
                    guard let id = UUID(uuidString: value) else { throw invalid() }
                    target = .id(id)
                case "tag":
                    guard let tag = Int(value) else { throw invalid() }
                    target = .tag(tag)
                case "name": target = .name(value)
                case "title": target = .title(value)
                case "autoID":
                    guard !value.isEmpty else { throw invalid() }
                    target = .autoID(value)
                default: throw invalid()
                }
                commands.append(isCheck ? .check(target, tokens[3]) : .activate(target))
            case "message":
                guard tokens.count == 2 else { throw invalid() }
                commands.append(.message(tokens[1]))
            case "interaction":
                guard tokens.count == 2, ["on", "off"].contains(tokens[1]) else {
                    throw invalid()
                }
                commands.append(.setUserInteractionEnabled(tokens[1] == "on"))
            default: throw invalid()
            }
        }
        self.init(commands: commands, turnsOffInteraction: turnsOffInteraction)
    }

    /// Quotes allow whitespace; backslash escapes the following character.
    private static func tokens(_ text: String, line: Int) throws -> [String] {
        var result: [String] = []
        var token = ""
        var quote: Character?
        var escaped = false
        var started = false
        for character in text {
            if escaped {
                token.append(character); escaped = false; started = true
            } else if character == "\\" {
                escaped = true; started = true
            } else if let current = quote {
                if character == current { quote = nil } else { token.append(character) }
            } else if character == "'" || character == "\"" {
                quote = character; started = true
            } else if character.isWhitespace {
                if started { result.append(token); token = ""; started = false }
            } else {
                token.append(character); started = true
            }
        }
        guard quote == nil, !escaped else {
            throw AetherAutomationError.invalidLine(line, text)
        }
        if started { result.append(token) }
        return result
    }
}

public extension AetherAutomationTarget {
    /// Compatibility entry point; the scene owns lookup.
    func resolve(in scene: AetherScene?) throws -> AetherBasicObject {
        guard let scene else { throw AetherAutomationError.targetNotFound }
        return try scene.findObject(self)
    }

    var scriptDescription: String {
        switch self {
        case .id(let value): return "id " + value.uuidString
        case .tag(let value): return "tag " + String(value)
        case .name(let value): return "name " + value
        case .title(let value): return "title " + value
        case .autoID(let value): return "autoID " + value
        }
    }
}

public extension AetherAutomationError {
    var hudMessage: String? {
        if case .checkFailed(let target, let expected, _) = self {
            return "check " + target.scriptDescription + " failed find " + expected
        }
        return nil
    }
}
