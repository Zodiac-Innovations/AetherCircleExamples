//
//  AetherSupportLevel.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Feature level supported by an AetherCircle platform
//

// MARK: Import

import Foundation

// MARK: Enumeration

/// Core feature level supported by an AetherCircle platform.
public enum AetherSupportLevel: Int, Sendable, Codable, Hashable, Comparable {

    /// Initial AetherCircle Core feature level.
    case level1 = 1
}

// MARK: Extensions

public extension AetherSupportLevel {

    /// Compares two support levels by their numeric feature level.
    ///
    /// - Parameters:
    ///   - lhs: Support level on the left side of the comparison.
    ///   - rhs: Support level on the right side of the comparison.
    /// - Returns: `true` when the left support level is lower than the right support level.
    static func < (
        lhs: AetherSupportLevel,
        rhs: AetherSupportLevel
    ) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
