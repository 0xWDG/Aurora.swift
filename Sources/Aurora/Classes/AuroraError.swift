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

/// <#Description#>
struct AuroraError {
    /// <#Description#>
    let message: String
    
    /// <#Description#>
    /// - Parameter message: <#message description#>
    init(message: String) {
        self.message = message
    }
}

extension AuroraError: LocalizedError {
    /// the Error description
    var errorDescription: String? { return message }
    
    /// <#Description#>
    var failureReason: String? { return message }
    
    /// <#Description#>
    var recoverySuggestion: String? { return message }
    
    /// <#Description#>
    var helpAnchor: String? { return message }
}

extension String {
    var auroraError: AuroraError {
        return AuroraError(message: self)
    }
}
