//
//  AetherHUDContent.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Content displayed by the AetherCircle heads-up display.
//

// MARK: Import

import Foundation

// MARK: Enumeration

/// Content displayed by the AetherCircle heads-up display.
public enum AetherHUDContent {

    /// Displays a text banner.
    ///
    /// - Parameters:
    ///   - text: Text shown in the banner.
    ///   - onClose: Optional action performed when the banner closes.
    case banner(
        text: String,
        onClose: AetherBlock?
    )

    /// Displays text with an action button.
    ///
    /// - Parameters:
    ///   - text: Text shown in the heads-up display.
    ///   - buttonTitle: Title shown on the action button.
    ///   - action: Action performed when the button is selected.
    case action(
        text: String,
        buttonTitle: String,
        action: AetherBlock
    )
}
