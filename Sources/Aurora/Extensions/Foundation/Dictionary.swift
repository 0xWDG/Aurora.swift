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

// We'll need a strong foundation.
import Foundation

/// Support Dynamic Member Lookups for a Dictionary.
@dynamicMemberLookup
public protocol DictionaryDynamicLookup {
    /// We have a  "Key"
    associatedtype Key
    
    /// and a "Value"
    associatedtype Value
    
    /// We want to subscript at our "Key"
    /// like dict["Key"]
    subscript(key: Key) -> Value? { get }
}

// Extend, if key equals the string (so dict["Key"] exists.
public extension DictionaryDynamicLookup where Key == String {
    // then return the value (optional, conform Dictionary protocol, not needed, but still required)
    /// Get the dynamic member of the dictionary
    /// - Parameters:
    ///     dynamicMember: member
    subscript(dynamicMember member: String) -> Value? {
        // return our member
        return self[member]
    }
}

// Extend Dictionary for Dynamic Member Lookup support
extension Dictionary: DictionaryDynamicLookup {}

// Extend NSMutableDictionary for Dynamic Member Lookup support
extension NSMutableDictionary: DictionaryDynamicLookup {}
