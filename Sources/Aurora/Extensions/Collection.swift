// $$HEADER$$

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
}

public extension Sequence where Element: Numeric {
    /// Returns the sum of all elements.
    @inlinable
    func sum() -> Element {
        reduce(0, +)
    }
}

public protocol DivisibleArithmetic: Numeric {
    /// <#Description#>
    /// - Parameter value: <#value description#>
    init(_ value: Int)
    
    /// <#Description#>
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
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
