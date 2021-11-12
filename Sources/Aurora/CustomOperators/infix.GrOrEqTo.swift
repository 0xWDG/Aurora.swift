// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

import Foundation

infix operator ≥ : ComparisonPrecedence

/// Greater or equal to
/// - Returns: Bool
public func ≥ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    // swiftlint:disable:previous identifier_name
    return lhs >= rhs
}

infix operator ≤ : ComparisonPrecedence

/// Less or equal to
/// - Returns: Bool
public func ≤ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    // swiftlint:disable:previous identifier_name
    return lhs <= rhs
}
