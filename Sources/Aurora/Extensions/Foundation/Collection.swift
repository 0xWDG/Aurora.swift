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

public extension Collection {
    /// Returns an element with the specified index or nil if the element does not exist.
    ///
    /// - Parameters:
    ///   - try: The index of the element.
    @inlinable
    subscript(try index: Index) -> Element? {
        indices.contains(index) ? self[index]: nil
    }
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Sequence where Element: Numeric {
    /// Returns the sum of all elements.
    @inlinable
    func sum() -> Element {
        reduce(0, +)
    }
}

public protocol DivisibleArithmetic: Numeric {
    /// DivisibleArithmetic
    /// - Parameter value: values
    init(_ value: Int)
    
    /// Divide
    /// - Parameters:
    ///   - lhs: Number 1
    ///   - rhs: Number 2
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Double: DivisibleArithmetic {}
extension Float: DivisibleArithmetic {}

#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: DivisibleArithmetic {}
#endif

public extension Collection where Element: DivisibleArithmetic {
    /// Returns the average of all elements.
    @inlinable
    func average() -> Element {
        sum() / Element(count)
    }
}

public extension Collection where Element == Int {
    /// Returns the average of all elements as a Double value.
    @inlinable
    func average<ReturnType: DivisibleArithmetic>() -> ReturnType {
        ReturnType(sum()) / ReturnType(count)
    }
}
