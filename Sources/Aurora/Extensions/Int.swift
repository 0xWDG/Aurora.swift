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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

extension Int {
    /// Converts a string to:
    ///
    /// * 16 = Hexadecimal
    /// * 8   = Octal
    /// * 2   = Binary
    public func toString(_ radix: Int) -> String {
        switch radix {
        case 16:
            return String(format: "%2X", self).lowerAndNoSpaces
            
        case 8:
            return String(self, radix: 8, uppercase: false).lowerAndNoSpaces
            
        case 2:
            return String(self, radix: 2, uppercase: false).lowerAndNoSpaces
            
        default:
            return String(self)
        }
    }
    
    #if canImport(Foundation)
    /// Checks if the integer is odd.
    public var isOdd: Bool {
        return (self % 2 != 0)
    }
    
    /// Checks if the integer is even.
    public var isEven: Bool {
        return (self % 2 == 0)
    }
    
    /// Checks if the integer is negative.
    public var isNegative: Bool {
        return (self < 0)
    }
    
    /// Checks if the integer is positive.
    public var isPositive: Bool {
        return (self > 0)
    }
    
    /// Converts a (negative)integer value to a positive value.
    public var toPositive: Int {
        return abs(self)
    }
    
    /// Converts integer value to Double.
    public var toDouble: Double {
        return Double(self)
    }
    
    /// Converts integer value to Float.
    public var toFloat: Float {
        return Float(self)
    }
    
    /// Converts integer value to String.
    public var toString: String {
        return String(self)
    }
    
    /// Converts integer value to UInt.
    public var toUInt: UInt {
        return UInt(self)
    }
    
    /// Converts integer value to Int32.
    public var toInt32: Int32 {
        return Int32(self)
    }
    
    /// Converts integer value to a 0..<Int range. Useful in for loops.
    public var range: CountableRange<Int> {
        return 0..<self
    }
    #endif
    
    #if canImport(UIKit)
    /// Converts integer value to CGFloat.
    public var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    #endif
    
    /// Runs the code passed as a closure the specified number of times.
    ///
    /// - Parameters:
    ///   - closure: The code to be run multiple times.
    @inlinable
    public func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0 ..< self { closure() }
    }
    
    /// Runs the code passed as a closure the specified number of times
    /// and creates an array from the return values.
    ///
    /// Example:
    ///
    ///    // This returns [5, 5, 5, 5, 5]
    ///    5.timesMake({ () -> Int in
    ///      return 5
    ///    })
    ///
    /// - Parameters:
    ///   - closure: The code to deliver a return value multiple times.
    @inlinable
    public func timesMake<ReturnType>(_ closure: () -> ReturnType) -> [ReturnType] {
        guard self > 0 else { return [] }
        return (0 ..< self).map { _ in closure() }
    }
}
