//
//  Aurora.Config.swift
//
//
//  Created by Wesley de Groot on 14/05/2021.
//

import Foundation

/// A type safe property wrapper to set and get values from UserDefaults with support for defaults values.
///
/// Usage:
/// ```
/// @AuroraConfig("isReady", default: false)
/// static var isReady: Bool
/// ```
///
/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@propertyWrapper
public struct AuroraConfig<Value: AuroraConfigStoreValue> {
    /// <#Description#>
    let key: String
    
    /// <#Description#>
    let defaultValue: Value
    
    /// <#Description#>
    var userDefaults: UserDefaults
    
    /// <#Description#>
    /// - Parameters:
    ///   - key: Configuration Key
    ///   - default: Default value
    public init(_ key: String, `default`: Value) {
        self.key = "Aurora." + key
        self.defaultValue = `default`
        self.userDefaults = .standard
    }
    
    /// <#Description#>
    public var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}

/// A type than can be stored in `UserDefaults`.
///
/// From UserDefaults;
/// The value parameter can be only property list objects: NSData, NSString, NSNumber, NSDate, NSArray,
/// or NSDictionary.
/// For NSArray and NSDictionary objects, their contents must be property list objects. For more information,
/// see What is a Property List? in Property List Programming Guide.
public protocol AuroraConfigStoreValue {}

/// Make `Data` compliant to `AuroraConfigStoreValue`
extension Data: AuroraConfigStoreValue {}

/// Make `NSData` compliant to `AuroraConfigStoreValue`
extension NSData: AuroraConfigStoreValue {}

/// Make `String` compliant to `AuroraConfigStoreValue`
extension String: AuroraConfigStoreValue {}

/// Make `Date` compliant to `AuroraConfigStoreValue`
extension Date: AuroraConfigStoreValue {}

/// Make `NSDate` compliant to `AuroraConfigStoreValue`
extension NSDate: AuroraConfigStoreValue {}

/// Make `NSNumber` compliant to `AuroraConfigStoreValue`
extension NSNumber: AuroraConfigStoreValue {}

/// Make `Bool` compliant to `AuroraConfigStoreValue`
extension Bool: AuroraConfigStoreValue {}

/// Make `Int` compliant to `AuroraConfigStoreValue`
extension Int: AuroraConfigStoreValue {}

/// Make `Int8` compliant to `AuroraConfigStoreValue`
extension Int8: AuroraConfigStoreValue {}

/// Make `Int16` compliant to `AuroraConfigStoreValue`
extension Int16: AuroraConfigStoreValue {}

/// Make `Int32` compliant to `AuroraConfigStoreValue`
extension Int32: AuroraConfigStoreValue {}

/// Make `Int64` compliant to `AuroraConfigStoreValue`
extension Int64: AuroraConfigStoreValue {}

/// Make `UInt` compliant to `AuroraConfigStoreValue`
extension UInt: AuroraConfigStoreValue {}

/// Make `UInt8` compliant to `AuroraConfigStoreValue`
extension UInt8: AuroraConfigStoreValue {}

/// Make `UInt16` compliant to `AuroraConfigStoreValue`
extension UInt16: AuroraConfigStoreValue {}

/// Make `UInt32` compliant to `AuroraConfigStoreValue`
extension UInt32: AuroraConfigStoreValue {}

/// Make `UInt64` compliant to `AuroraConfigStoreValue`
extension UInt64: AuroraConfigStoreValue {}

/// Make `Double` compliant to `AuroraConfigStoreValue`
extension Double: AuroraConfigStoreValue {}

/// Make `Floar` compliant to `AuroraConfigStoreValue`
extension Float: AuroraConfigStoreValue {}

/// Make `Array` compliant to `AuroraConfigStoreValue`
extension Array: AuroraConfigStoreValue where Element: AuroraConfigStoreValue {}

/// Make `Dictionary` compliant to `AuroraConfigStoreValue`
extension Dictionary: AuroraConfigStoreValue where Key == String, Value: AuroraConfigStoreValue {}
