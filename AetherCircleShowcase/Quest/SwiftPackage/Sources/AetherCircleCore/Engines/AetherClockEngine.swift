//
//  AetherClockEngine.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Platform engine contract for scheduling and managing clock events
//

// MARK: Import

import Foundation

// MARK: Protocol

/// Platform engine contract for scheduling and managing clock events.
public protocol AetherClockEngine: AetherEngine {

    /// Schedules a clock event.
    ///
    /// - Parameter alarm: Event to schedule.
    func schedule(_ alarm: AetherAlarm)

    /// Cancels the clock event with the specified identifier.
    ///
    /// - Parameter id: Unique identifier of the event to cancel.
    func cancel(id: UUID)

    /// Returns the clock event with the specified identifier.
    ///
    /// - Parameter id: Unique identifier of the requested event.
    /// - Returns: Matching event, or nil when no event is registered.
    func event(id: UUID) -> AetherAlarm?
}

// MARK: Class

/// Place Holder Clock.
public final class AetherClockDummy: AetherClockEngine {

    // MARK: Init
    
    public init() {}

    // MARK: AetherClockEngine
    
    public func schedule(_ alarm: AetherAlarm) { }

    public func cancel(id: UUID) { }

    public func event(id: UUID) -> AetherAlarm? { nil }
}
