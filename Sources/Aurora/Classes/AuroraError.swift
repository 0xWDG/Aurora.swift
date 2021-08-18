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

/// Aurora error
struct AuroraError {
    /// The error message
    let message: String
    
    /// Create an error message
    /// - Parameter message: the error description
    init(message: String) {
        self.message = message
    }
}

extension AuroraError: LocalizedError {
    /// the Error description
    var errorDescription: String? { return message }
    
    /// Failure reaseon
    var failureReason: String? { return message }
    
    /// Recovery suggestion
    var recoverySuggestion: String? { return message }
    
    /// Help anchor
    var helpAnchor: String? { return message }
}

extension String {
    /// Create an `Error` of the current string
    var auroraError: AuroraError {
        return AuroraError(message: self)
    }
}
