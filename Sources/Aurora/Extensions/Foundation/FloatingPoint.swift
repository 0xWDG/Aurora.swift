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

public extension FloatingPoint {
    /// Returns the opposite number.
    var additiveInverse: Self {
        return self * -1
    }
    
    /// Returns the value to the power of `-1`.
    var multiplicativeInverse: Self? {
        let zero: Self = 0
        guard self != zero else { return nil }
        
        return 1 / self
    }
    
    /// Converts an angle measured in degrees to radians.
    var degreesToRadians: Self {
        guard let val = 180.0 as? Self else {
            fatalError("Unable to convert")
        }
        
        return self * .pi / val
    }
    
    /// Converts an angle measured in radians to degrees.
    var radiansToDegrees: Self {
        guard let val = 180.0 as? Self else {
            fatalError("Unable to convert")
        }
        
        return self * val / .pi
    }
}
