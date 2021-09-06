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

// Modified version of: https://github.com/evgenyneu/keychain-swift
// Less options.

#if canImport(Security)
import Foundation
import Security

extension Aurora {
    /// A collection of helper functions for saving text and data in the keychain.
    open class Keychain {
        var lastQueryParameters: [String: Any]? // Used by the unit tests

        /// Contains result code from the last operation. Value is noErr (0) for a successful result.
        open var lastResultCode: OSStatus = noErr

        /// Can be useful in test.
        var keyPrefix = ""

        /// Specify an access group that will be used to access keychain items.
        /// Access groups can be used to share keychain items between applications.
        /// When access group value is nil all application access groups are being accessed.
        /// Access group name is used by all functions: set, get, delete and clear.
        open var accessGroup: String?

        /// Specifies whether the items can be synchronized with other devices through iCloud
        open var synchronizable: Bool = true

        struct KQuery {
            // swiftlint:disable:previous nesting
            static let account = kSecAttrAccount as String
            static let `class` = kSecClass as String
            static let valueData = kSecValueData as String
            static let accessible = kSecAttrAccessible as String
            static let group = kSecAttrAccessGroup as String
            static let limit = kSecMatchLimit as String
            static let limitOne = kSecMatchLimitOne
            static let limitAll = kSecMatchLimitAll as String
            static let synchronizable = kSecAttrSynchronizable as String
            static let returnAttributes = kSecReturnAttributes as String
            static let returnData = kSecReturnData as String
            static let returnPReference = kSecReturnPersistentRef as String
            static let syncAny = kSecAttrSynchronizableAny

            /// The value that indicates a generic password item.
            static let password = kSecClassGenericPassword

            /// The data in the keychain item can be accessed only while the device is unlocked by the user.
            static let access = kSecAttrAccessibleWhenUnlocked
        }

        /// Create a lock
        private let lock = NSLock()

        /// Instantiate a KeychainSwift object
        public init() { }

        /// Init
        /// - parameter keyPrefix: a prefix that is added before the key in get/set methods.
        /// Note that `clear` method still clears everything from the Keychain.
        public init(keyPrefix: String) {
            self.keyPrefix = keyPrefix
        }

        /// Stores the text value in the keychain item under the given key.
        ///
        /// - parameter key: Key under which the text value is stored in the keychain.
        /// - parameter value: Text string to be written to the keychain.
        ///
        /// - returns: True if the text was successfully written to the keychain.
        @discardableResult
        open func set(_ value: String, forKey key: String) -> Bool {
            if let value = value.data(using: String.Encoding.utf8) {
                return set(value, forKey: key)
            }

            return false
        }

        /// Stores the data in the keychain item under the given key.
        ///
        /// - parameter key: Key under which the data is stored in the keychain.
        /// - parameter value: Data to be written to the keychain.
        ///
        /// - returns: True if the text was successfully written to the keychain.
        @discardableResult
        open func set(_ value: Data, forKey key: String) -> Bool {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }

            deleteNoLock(key) // Delete any existing key before saving it

            let prefixedKey = keyWithPrefix(key)

            var query: [String: Any] = [
                KQuery.class: KQuery.password,
                KQuery.account: prefixedKey,
                KQuery.valueData: value,
                KQuery.accessible: KQuery.access
            ]

            query = addSynchronizableIfRequired(query, addingItems: true)
            lastQueryParameters = query

            lastResultCode = SecItemAdd(query as CFDictionary, nil)

            return lastResultCode == noErr
        }

        /// Stores the boolean value in the keychain item under the given key.
        /// - parameter key: Key under which the value is stored in the keychain.
        /// - parameter value: Boolean to be written to the keychain.
        /// - parameter withAccess: Value that indicates when your app needs access to
        /// the value in the keychain item.
        /// By default the .AccessibleWhenUnlocked option is used that permits the data to
        /// be accessed only while the device is unlocked by the user.
        /// - returns: True if the value was successfully written to the keychain.
        @discardableResult
        open func set(_ value: Bool, forKey key: String) -> Bool {
            let bytes: [UInt8] = value ? [1] : [0]
            let data = Data(bytes)

            return set(data, forKey: key)
        }

        /// Retrieves the text value from the keychain that corresponds to the given key.
        ///
        /// - parameter key: The key that is used to read the keychain item.
        /// - returns: The text value from the keychain. Returns nil if unable to read the item.
        open func get(_ key: String) -> String? {
            if let data = getData(key) {

                if let currentString = String(data: data, encoding: .utf8) {
                    return currentString
                }

                lastResultCode = -67853 // errSecInvalidEncoding
            }

            return nil
        }

        /// Retrieves the data from the keychain that corresponds to the given key.
        ///
        /// - parameter key: The key that is used to read the keychain item.
        /// - parameter asReference: If true, returns the data as reference (needed for things like NEVPNProtocol).
        /// - returns: The text value from the keychain. Returns nil if unable to read the item.
        open func getData(_ key: String, asReference: Bool = false) -> Data? {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }

            let prefixedKey = keyWithPrefix(key)

            var query: [String: Any] = [
                KQuery.class: KQuery.password,
                KQuery.account: prefixedKey,
                KQuery.limit: KQuery.limitOne
            ]

            if asReference {
                query[KQuery.returnPReference] = kCFBooleanTrue
            } else {
                query[KQuery.returnData] =  kCFBooleanTrue
            }

            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query

            var result: AnyObject?

            lastResultCode = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }

            if lastResultCode == noErr {
                return result as? Data
            }

            return nil
        }

        ///  Retrieves the boolean value from the keychain that corresponds to the given key.
        /// - parameter key: The key that is used to read the keychain item.
        /// - returns: The boolean value from the keychain. Returns nil if unable to read the item.
        open func getBool(_ key: String) -> Bool? {
            guard let data = getData(key) else { return nil }
            guard let firstBit = data.first else { return nil }
            return firstBit == 1
        }

        /// Deletes the single keychain item specified by the key.
        ///
        /// - parameter key: The key that is used to delete the keychain item.
        /// - returns: True if the item was successfully deleted.
        @discardableResult
        open func delete(_ key: String) -> Bool {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }

            return deleteNoLock(key)
        }

        /// Return all keys from keychain
        ///
        /// - returns: An string array with all keys from the keychain.
        public var allKeys: [String] {
            var query: [String: Any] = [
                KQuery.class: KQuery.password,
                KQuery.returnData: true,
                KQuery.returnAttributes: true,
                KQuery.returnPReference: true,
                KQuery.limit: KQuery.limitAll
            ]

            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)

            var result: AnyObject?

            let lastResultCode = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }

            if lastResultCode == noErr {
                return (result as? [[String: Any]])?.compactMap {
                    $0[KQuery.account] as? String
                } ?? []
            }

            return []
        }

        /// Same as `delete` but is only accessed internally, since it is not thread safe.
        ///
        /// - parameter key: The key that is used to delete the keychain item.
        /// - returns: True if the item was successfully deleted.
        @discardableResult
        func deleteNoLock(_ key: String) -> Bool {
            let prefixedKey = keyWithPrefix(key)

            var query: [String: Any] = [
                KQuery.class: KQuery.password,
                KQuery.account: prefixedKey
            ]

            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query

            lastResultCode = SecItemDelete(query as CFDictionary)

            return lastResultCode == noErr
        }

        /// Deletes all Keychain items used by the app.
        /// Note that this method deletes all items regardless of the prefix settings used for initializing the class.
        ///
        /// - returns: True if the keychain items were successfully deleted.
        @discardableResult
        open func clear() -> Bool {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }

            var query: [String: Any] = [KQuery.class: KQuery.password]
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query

            lastResultCode = SecItemDelete(query as CFDictionary)

            return lastResultCode == noErr
        }

        /// Returns the key with currently set prefix.
        func keyWithPrefix(_ key: String) -> String {
            return "\(keyPrefix)\(key)"
        }

        func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
            guard let accessGroup = accessGroup else { return items }

            var result: [String: Any] = items
            result[KQuery.group] = accessGroup
            return result
        }

        /// Adds kSecAttrSynchronizable: kSecAttrSynchronizableAny` item to the dictionary
        /// when the `synchronizable` property is true.
        ///
        /// - parameter items: The dictionary where the kSecAttrSynchronizable items will be added when requested.
        /// - parameter addingItems: Use `true` when the dictionary will be used with
        /// `SecItemAdd` method (adding a keychain item).For getting and deleting items, use `false`.
        /// - returns: the dictionary with kSecAttrSynchronizable item added if it was requested.
        /// Otherwise, it returns the original dictionary.
        func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
            if !synchronizable { return items }
            var result: [String: Any] = items
            result[KQuery.synchronizable] = addingItems == true ? true : KQuery.syncAny
            return result
        }

        /// Get all the keys saved in the Keychain
        /// - Returns: Keys in the keychain
        open func getAllKeys() -> [String]? {
            var query: [String: Any] = [KQuery.class: KQuery.password]
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            query[KQuery.limit] = KQuery.limitAll
            query[KQuery.returnAttributes] = true
            lastQueryParameters = query

            var result: AnyObject?
            var keys = [String]()

            lastResultCode = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }

            if let items = result as? [[String: AnyObject]] {
                for item in items {
                    if let key = item[KQuery.account] as? String {
                        keys.append(key)
                    }
                }
            }

            if lastResultCode == noErr {
                return keys
            }

            return nil
        }
    }
}
#endif
