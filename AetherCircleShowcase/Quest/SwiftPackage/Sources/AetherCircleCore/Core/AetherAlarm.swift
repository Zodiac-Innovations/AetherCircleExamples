//
//  AetherAlarm.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Scheduled action managed by the AetherClock service
//

// MARK: Import

import Foundation

// MARK: Class

/// Scheduled action managed by the AetherClock service.
public final class AetherAlarm {

    // MARK: Properties

    /// Unique identifier for the clock event.
    public let id: UUID

    /// Delay in seconds before the event first fires.
    public var delay: TimeInterval

    /// Optional repeat interval in seconds after the first firing.
    public var repeatInterval: TimeInterval?

    /// Action performed whenever the event fires.
    public let action: AetherBlock

    // MARK: Initialization

    /// Creates a clock event.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the event.
    ///   - delay: Delay in seconds before the first firing.
    ///   - repeatInterval: Optional repeat interval in seconds.
    ///   - action: Action performed whenever the event fires.
    public init(
        id: UUID = UUID(),
        delay: TimeInterval,
        repeatInterval: TimeInterval? = nil,
        action: @escaping AetherBlock
    ) {
        self.id = id
        self.delay = delay
        self.repeatInterval = repeatInterval
        self.action = action
    }
}
