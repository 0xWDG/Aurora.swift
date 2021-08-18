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
// Licence: MIT

import Foundation

public extension NSError {
    /// A convenience initializer for NSError to set its description.
    ///
    /// - Parameters:
    ///   - domain: The error domain.
    ///   - code: The error code.
    ///   - description: Some description for this error.
    convenience init(domain: String, code: Int, description: String) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [
                (kCFErrorLocalizedDescriptionKey as CFString) as String: description
            ]
        )
    }
    
    /// A convenience initializer for NSError to set its description.
    ///
    /// - Parameters:
    ///   - message: Some description for this error.
    convenience init(message: String) {
        self.init(domain: message, code: 0, description: message)
    }
}
