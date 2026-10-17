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
            case "tap":
                guard tokens.count == 3 else { throw invalid() }
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
                commands.append(.activate(target))
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
    /// Resolves exactly one visible object, including nested composite children.
    func resolve(in scene: AetherScene?) throws -> AetherBasicObject {
        var matches: [AetherBasicObject] = []
        func visit(_ objects: [AetherBasicObject]) {
            for object in objects where object.isVisible {
                let matchesTarget: Bool
                switch self {
                case .id(let value): matchesTarget = object.id == value
                case .tag(let value): matchesTarget = object.tag == value
                case .name(let value): matchesTarget = object.name == value
                case .autoID(let value): matchesTarget = !value.isEmpty && object.autoID == value
                case .title(let value):
                    if let button = object as? AetherButtonObject {
                        matchesTarget = button.title == value
                    } else if let panel = object as? AetherPanelObject {
                        matchesTarget = panel.title == value
                    } else { matchesTarget = false }
                }
                if matchesTarget { matches.append(object) }
                if let composite = object as? AetherCompositeObject { visit(composite.children) }
            }
        }
        visit(scene?.objects ?? [])
        guard !matches.isEmpty else { throw AetherAutomationError.targetNotFound }
        guard matches.count == 1 else { throw AetherAutomationError.ambiguousTarget }
        return matches[0]
    }
}
