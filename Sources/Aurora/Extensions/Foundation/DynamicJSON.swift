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
//  Modified for usage within BaaS
//  Original content, and thanks to:
//     Saoud Rizwan
//     https://github.com/saoudrizwan/DynamicJSON

/// JSON
@dynamicMemberLookup public enum JSON {
    // MARK: Cases
    /// Dictionary
    case dictionary([String: JSON])
    /// Array
    case array([JSON])
    /// String
    case string(String)
    /// Number
    case number(NSNumber)
    /// Bool
    case bool(Bool)
    /// Null
    case null
    
    // MARK: Dynamic Member Lookup
    /// Subscript (index)
    /// - Returns: JSON
    public subscript(index: Int) -> JSON? {
        if case .array(let arr) = self {
            return index < arr.count ? arr[index]: nil
        }
        return nil
    }
    
    /// Subscript (key)
    /// - Returns: JSON
    public subscript(key: String) -> JSON? {
        if case .dictionary(let dict) = self {
            return dict[key]
        }
        return nil
    }
    
    /// Subscript (dynamic member)
    /// - Returns: JSON
    public subscript(dynamicMember member: String) -> JSON? {
        if case .dictionary(let dict) = self {
            return dict[member]
        }
        return nil
    }
    
    // MARK: Initializers
    
    /// Init with DATA
    /// - Parameters:
    ///   - data: JSON Data
    ///   - options: JSONSerialization options
    /// - Throws: Error if invalid JSON
    public init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self = JSON(object)
    }
    
    /// Init objects
    /// - Parameter object: objects (Data: (JSON, nil), Array, Any, Bool, Number, String)
    public init(_ object: Any) {
        if let data = object as? Data {
            if let converted = try? JSON(data: data) {
                self = converted
            } else if let fragments = try? JSON(data: data, options: .allowFragments) {
                self = fragments
            } else {
                self = JSON.null
            }
        } else if let dictionary = object as? [String: Any] {
            self = JSON.dictionary(dictionary.mapValues { JSON($0) })
        } else if let array = object as? [Any] {
            self = JSON.array(array.map { JSON($0) })
        } else if let string = object as? String {
            self = JSON.string(string)
        } else if let bool = object as? Bool {
            self = JSON.bool(bool)
        } else if let number = object as? NSNumber {
            self = JSON.number(number)
        } else {
            self = JSON.null
        }
    }
    
    // MARK: Accessors
    
    /// Dictionary value
    public var dictionary: [String: JSON]? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
    
    /// Array value
    public var array: [JSON]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    /// String value
    public var string: String? {
        if case .string(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return value ? "true": "false"
        } else if case .number(let value) = self {
            return value.stringValue
        }
        return nil
    }
    
    /// Number value
    public var number: NSNumber? {
        if case .number(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return NSNumber(value: value)
        } else if case .string(let value) = self, let doubleValue = Double(value) {
            return NSNumber(value: doubleValue)
        }
        return nil
    }
    
    /// Double value
    public var double: Double? {
        return number?.doubleValue
    }
    
    /// Int value
    public var int: Int? {
        return number?.intValue
    }
    
    /// Boolean value
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        } else if case .number(let value) = self {
            return value.boolValue
        } else if case .string(let value) = self,
                  (["true", "t", "yes", "y", "1"].contains {
                    value.caseInsensitiveCompare($0) == .orderedSame
                  }
                  ) {
            return true
        } else if case .string(let value) = self,
                  (["false", "f", "no", "n", "0"].contains {
                    value.caseInsensitiveCompare($0) == .orderedSame
                  }) {
            return false
        }
        return nil
    }
    
    // MARK: Helpers
    
    /// Objects
    public var object: Any {
        switch self {
        case .dictionary(let value):
            return value.mapValues { $0.object }
            
        case .array(let value):
            return value.map { $0.object }
            
        case .string(let value):
            return value
            
        case .number(let value):
            return value
            
        case .bool(let value):
            return value
            
        case .null:
            return NSNull()
        }
    }
    
    /// JSON to Data
    /// - Parameter options: JSON Options
    /// - Returns: Data
    public func data(options: JSONSerialization.WritingOptions = []) -> Data {
        return (
            try? JSONSerialization.data(
                withJSONObject: self.object,
                options: options
            )
        ) ?? Data()
    }
}
