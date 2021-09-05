//
//  File.swift
//  File
//
//  Created by Wesley de Groot on 05/09/2021.
//

import Foundation

/// A type safe property wrapper to set and get values from KeychainItem with support for defaults values.
///
/// Usage:
/// ```
/// @KeychainItem("itemName")
/// var itemName: String
/// // Does not work as expected yet,
/// // could be a ios 15 issue. or Xcode-beta issue.
/// // Xcode stable doesnt work at my Mac, cannot test.
/// ```
@propertyWrapper
public struct KeychainItem<Value: AKStore> {
    let OSStatusses = [
        "-34018": "Missing entitlement"
    ]
    /// A key in the current user‘s defaults database.
    let key: String

    /// A default value for the key in the current user‘s defaults database.
    let defaultValue: Value

    /// Returns/set the object associated with the specified key.
    /// - Parameters:
    ///   - key: A key in the current user‘s defaults database.
    ///   - default: A default value for the key in the current user‘s defaults database.
    public init(_ key: String, `default`: Value) {
        self.key = key
        self.defaultValue = `default`
    }

    /// Wrapped userdefault
    public var wrappedValue: Value {
        get {
            guard let val = try? Aurora.Keychain.get(account: key) as? Value else {
                print("Failed to turn in to \(Value.Type.self)")
                return defaultValue
            }

            print("Returning: \(val)")
            return val
        }
        set {
            print("Setting (test)")
            if let Val = newValue as? String {
                print("Saving")
                try? Aurora.Keychain.set(value: Val, account: key)
            }
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
public protocol AKStore {}

/// Make `Data` compliant to `AuroraConfigStoreValue`
//extension Data: AuroraConfigStoreValue {}

/// Make `NSData` compliant to `AuroraConfigStoreValue`
//extension NSData: AuroraConfigStoreValue {}

/// Make `String` compliant to `AuroraConfigStoreValue`
extension String: AKStore {}

///// Make `Date` compliant to `AuroraConfigStoreValue`
//extension Date: AuroraConfigStoreValue {}
//
///// Make `NSDate` compliant to `AuroraConfigStoreValue`
//extension NSDate: AuroraConfigStoreValue {}
//
///// Make `NSNumber` compliant to `AuroraConfigStoreValue`
//extension NSNumber: AuroraConfigStoreValue {}
//
///// Make `Bool` compliant to `AuroraConfigStoreValue`
//extension Bool: AuroraConfigStoreValue {}
//
///// Make `Int` compliant to `AuroraConfigStoreValue`
//extension Int: AuroraConfigStoreValue {}
//
///// Make `Int8` compliant to `AuroraConfigStoreValue`
//extension Int8: AuroraConfigStoreValue {}
//
///// Make `Int16` compliant to `AuroraConfigStoreValue`
//extension Int16: AuroraConfigStoreValue {}
//
///// Make `Int32` compliant to `AuroraConfigStoreValue`
//extension Int32: AuroraConfigStoreValue {}
//
///// Make `Int64` compliant to `AuroraConfigStoreValue`
//extension Int64: AuroraConfigStoreValue {}
//
///// Make `UInt` compliant to `AuroraConfigStoreValue`
//extension UInt: AuroraConfigStoreValue {}
//
///// Make `UInt8` compliant to `AuroraConfigStoreValue`
//extension UInt8: AuroraConfigStoreValue {}
//
///// Make `UInt16` compliant to `AuroraConfigStoreValue`
//extension UInt16: AuroraConfigStoreValue {}
//
///// Make `UInt32` compliant to `AuroraConfigStoreValue`
//extension UInt32: AuroraConfigStoreValue {}
//
///// Make `UInt64` compliant to `AuroraConfigStoreValue`
//extension UInt64: AuroraConfigStoreValue {}
//
///// Make `Double` compliant to `AuroraConfigStoreValue`
//extension Double: AuroraConfigStoreValue {}
//
///// Make `Floar` compliant to `AuroraConfigStoreValue`
//extension Float: AuroraConfigStoreValue {}
//
///// Make `Array` compliant to `AuroraConfigStoreValue`
//extension Array: AuroraConfigStoreValue where Element: AuroraConfigStoreValue {}
//
///// Make `Dictionary` compliant to `AuroraConfigStoreValue`
//extension Dictionary: AuroraConfigStoreValue where Key == String, Value: AuroraConfigStoreValue {}
