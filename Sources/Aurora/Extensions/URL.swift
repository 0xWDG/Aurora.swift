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

extension URL: ExpressibleByStringLiteral {
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            fatalError("\(value) is an invalid url")
        }
        self = url
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension URL {
    /// Extract the query items from an URL.
    /// - Returns: A dictionary containing all the query items found. If no items found then it will return nil.
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self as URL, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return nil
        }
        
        var parameters = [String: String]()
        queryItems.forEach {
            parameters[$0.name] = $0.value
        }
        return parameters
    }
    
    /// Add the `URLResourceKey.isExcludedFromBackupKey` attribute to the URL.
    ///
    /// This key is used to determine whether the resource is excluded from all backups of app data.
    public func addSkipBackupAttribute() throws {
        try (self as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
    }
}
