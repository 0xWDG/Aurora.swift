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

/// A type safe property wrapper to set and get values from the Keychain
///
/// Usage:
/// ```
/// @Keychain(item: "password")
/// var myPassword: String?
///
/// // Read
/// print(myPassword)
///
/// // Update password
/// myPassword = "my new password"
///
/// // Delete
/// myPassword = nil
/// ```
@propertyWrapper
public struct Keychain {
    /// Verbose logging (default: off)
    private let verbose: Bool = true

    /// Value to be written/saved (temporary)
    private var value: String = ""

    /// Is the first set action done?
    private var firstSet: Bool = false

    /// Which item are we using
    private var item: String

    /// Wrapped value
    public var wrappedValue: String? {
        get {
            let kcVal = Aurora.Keychain().get(item)

            log(action: "read", item: item, value: kcVal)

            return kcVal
        }
        set {
            guard let newValue = newValue else {
                log(action: "delete (nil)", item: item, value: nil)
                Aurora.Keychain().delete(item)
                return
            }

            log(action: "set", item: item, value: newValue)

            Aurora.Keychain().set(newValue, forKey: item)
            firstSet = false
        }
    }

    /// Init
    /// - Parameter item: Keychain item
    public init(item: String) {
        self.firstSet = true
        self.item = item
        self.wrappedValue = wrappedValue

        log(action: "init", item: item, value: "")
    }

    /// Init
    /// - Parameters:
    ///   - wrappedValue: Value
    ///   - item: Keychain item
    public init(wrappedValue: String, item: String) {
        self.firstSet = true
        self.item = item
        self.wrappedValue = wrappedValue

        log(action: "init", item: item, value: wrappedValue)
    }

    /// Built-in logger
    /// - Parameters:
    ///   - action: Action
    ///   - key: Key/Item
    ///   - value: Value
    private func log(action: String, item: String, value: String?) {
        if firstSet && action != "delete" {
            return
        }

        if verbose {
            // Init message
            var message = ""

            // Action (Init, Set, Get)
            message.append(contentsOf: action)

            // Fill to 7 characters
            for _ in stride(from: action.count, to: 7, by: 1) {
                message.append(contentsOf: " ")
            }

            // @KeychainItem (Propertywrapper name)
            message.append(contentsOf: " @Keychain")

            // Key
            message.append(contentsOf: "(item: \"\(item)\")")

            // Value (check for empty
            if let value = value {
                message.append(contentsOf: " = \"\(value)\"")
            }

            print(message)
        }
    }

    /// For SwiftUI
    public var projectedValue: String {
        return value
    }
}
