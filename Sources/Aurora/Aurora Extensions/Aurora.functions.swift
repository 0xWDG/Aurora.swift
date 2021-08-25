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

extension Aurora {
    #if canImport(CryptoKit)
    /// Create a MD5 string
    /// - Parameter phrase: The phrase which needs to be converted into MD5
    /// - Returns: MD5 Hash
    public func md5(phrase: String) -> String {
        return phrase.md5
    }
    #endif

    /// **No op**eration
    /// - Parameter something: Whay ever you want.
    public func noop(_ something: Any...) {
        // Great.
    }

    /// **No op**eration
    /// - Parameter something: Whay ever you want. (object)
    public func noop(_ something: AnyObject...) {
        // Great.
    }

    /// This is a demo func, thing for deprecation things.
    /// - Returns: Void
    @available(*, deprecated)
    func deprecatedFunc() {
    }

    /// This is a demo func, thing for unavailable things.
    /// - Returns: Void
    @available(*, unavailable)
    func unavailableFunc() {
    }
}
