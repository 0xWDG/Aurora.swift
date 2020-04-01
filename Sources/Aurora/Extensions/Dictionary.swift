// $$HEADER$$

// We'll need a strong foundation.
import Foundation

/// Support Dynamic Member Lookups for a Dictionary.
@dynamicMemberLookup
protocol DictionaryDynamicLookup {
    /// We have a  "Key"
    associatedtype Key
    
    /// and a "Value"
    associatedtype Value
    
    /// We want to subscript at our "Key"
    /// like dict["Key"]
    subscript(key: Key) -> Value? { get }
}

// Extend, if key equals the string (so dict["Key"] exists.
extension DictionaryDynamicLookup where Key == String {
    // then return the value (optional, conform Dictionary protocol, not needed, but still required)
    subscript(dynamicMember member: String) -> Value? {
        // return our member
        return self[member]
    }
}

// Extend Dictionary for Dynamic Member Lookup support
extension Dictionary: DictionaryDynamicLookup {}

// Extend NSMutableDictionary for Dynamic Member Lookup support
extension NSMutableDictionary: DictionaryDynamicLookup {}
