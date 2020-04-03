// $$HEADER$$

import Foundation

extension Collection {
    /// Returns an element with the specified index or nil if the element does not exist.
    ///
    /// - Parameters:
    ///   - try: The index of the element.
    @inlinable
    public subscript(try index: Index) -> Element? {
        indices.contains(index) ? self[index]: nil
    }
}

extension Sequence where Element: Numeric {
    /// Returns the sum of all elements.
    @inlinable
    public func sum() -> Element {
        reduce(0, +)
    }
}

public protocol DivisibleArithmetic: Numeric {
    init(_ value: Int)
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Double: DivisibleArithmetic {}
extension Float: DivisibleArithmetic {}

#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: DivisibleArithmetic {}
#endif

extension Collection where Element: DivisibleArithmetic {
    /// Returns the average of all elements.
    @inlinable
    public func average() -> Element {
        sum() / Element(count)
    }
}

extension Collection where Element == Int {
    /// Returns the average of all elements as a Double value.
    @inlinable
    public func average<ReturnType: DivisibleArithmetic>() -> ReturnType {
        ReturnType(sum()) / ReturnType(count)
    }
}
