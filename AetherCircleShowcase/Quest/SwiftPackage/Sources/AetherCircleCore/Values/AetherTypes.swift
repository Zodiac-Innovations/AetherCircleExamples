//
//  AetherTypes.swift
//  AetherCircleCore
//
//  Created by Steve Sheets on 8/4/26.
//
//  Fundamental scalar and closure aliases used throughout AetherCircle
//

// MARK: Import

import Foundation

// MARK: Type Aliases

/// Floating-point type used by all public AetherCircle APIs.
public typealias AetherFloat = Float

/// Closure that accepts no parameters and returns no value.
public typealias AetherBlockSimple = () -> Void

/// Closure that accepts a Boolean flag and returns no value.
public typealias AetherBlockFlag = (Bool) -> Void

/// Closure that accepts an integer value and returns no value.
public typealias AetherBlockInt = (Int) -> Void

/// Backward-compatible name for a closure that accepts no parameters.
public typealias AetherBlock = AetherBlockSimple
