import Foundation

/// A type safe property wrapper to set and get values from UserDefaults with support for defaults values.
///
/// Usage:
/// ```
/// @UserDefault("has_seen_app_introduction", default: false)
/// static var hasSeenAppIntroduction: Bool
/// ```
///
/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@propertyWrapper
public struct UserDefault<Value: PropertyListValue> {
    /// <#Description#>
    let key: String
    
    /// <#Description#>
    let defaultValue: Value
    
    /// <#Description#>
    var userDefaults: UserDefaults
    
    /// <#Description#>
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - default: <#defaultValue description#>
    ///   - userDefaults: <#userDefaults description#>
    public init(_ key: String, `default`: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = `default`
        self.userDefaults = userDefaults
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
public protocol PropertyListValue {}

/// Make `Data` compliant to `PropertyListValue`
extension Data: PropertyListValue {}

/// Make `NSData` compliant to `PropertyListValue`
extension NSData: PropertyListValue {}

/// Make `String` compliant to `PropertyListValue`
extension String: PropertyListValue {}

/// Make `Date` compliant to `PropertyListValue`
extension Date: PropertyListValue {}

/// Make `NSDate` compliant to `PropertyListValue`
extension NSDate: PropertyListValue {}

/// Make `NSNumber` compliant to `PropertyListValue`
extension NSNumber: PropertyListValue {}

/// Make `Bool` compliant to `PropertyListValue`
extension Bool: PropertyListValue {}

/// Make `Int` compliant to `PropertyListValue`
extension Int: PropertyListValue {}

/// Make `Int8` compliant to `PropertyListValue`
extension Int8: PropertyListValue {}

/// Make `Int16` compliant to `PropertyListValue`
extension Int16: PropertyListValue {}

/// Make `Int32` compliant to `PropertyListValue`
extension Int32: PropertyListValue {}

/// Make `Int64` compliant to `PropertyListValue`
extension Int64: PropertyListValue {}

/// Make `UInt` compliant to `PropertyListValue`
extension UInt: PropertyListValue {}

/// Make `UInt8` compliant to `PropertyListValue`
extension UInt8: PropertyListValue {}

/// Make `UInt16` compliant to `PropertyListValue`
extension UInt16: PropertyListValue {}

/// Make `UInt32` compliant to `PropertyListValue`
extension UInt32: PropertyListValue {}

/// Make `UInt64` compliant to `PropertyListValue`
extension UInt64: PropertyListValue {}

/// Make `Double` compliant to `PropertyListValue`
extension Double: PropertyListValue {}

/// Make `Floar` compliant to `PropertyListValue`
extension Float: PropertyListValue {}

/// Make `Array` compliant to `PropertyListValue`
extension Array: PropertyListValue where Element: PropertyListValue {}

/// Make `Dictionary` compliant to `PropertyListValue`
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
