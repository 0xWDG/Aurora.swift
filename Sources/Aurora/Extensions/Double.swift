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

import Foundation

public extension Double {
    /// Converts float value to a positive one, if not already
    var toPositive: Double {
        return fabs(self)
    }
    
    /// To string
    var toString: String {
        return String(format: "%.02f", self)
    }
    
    /// Double to price
    /// - Parameter currency: currency symbol (Defaults to: €)
    /// - Returns: ""
    func toPrice(currency: String = "€") -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return currency + " " + (nf.string(from: NSNumber(value: self)) ?? "?")
    }
}
