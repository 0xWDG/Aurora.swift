//
//  File.swift
//  File
//
//  Created by Wesley de Groot on 05/09/2021.
//

import Foundation

extension Aurora {
    /// Private enum to return possible errors
    internal enum AKError: Error {
        /// Error with the keychain creting and checking
        case creatingError

        /// Error for operation
        case operationError
    }

    public class Keychain: NSObject {
        /// Function to store a keychain item
        /// - parameters:
        ///   - value: Value to store in keychain in `data` format
        ///   - account: Account name for keychain item
        public static func set(value: String?, account: String) throws {
            guard let value = value else {
                try delete(account: account)
                return
            }

            // If the value exists `update the value`
            if try self.exists(account: account) {
                shared.log("Update")
                try self.update(value: value, account: account)
            } else {
                shared.log("Update")
                try self.add(value: value, account: account)
            }
        }
        /// Function to retrieve an item in ´Data´ format (If not present, returns nil)
        /// - parameters:
        ///   - account: Account name for keychain item
        /// - returns: Data from stored item
        public static func get(account: String) throws -> String? {
            if try self.exists(account: account) {
                return try self.retreive(account: account)
            } else {
                throw AKError.operationError
            }
        }

        /// Function to delete a single item
        /// - parameters:
        ///   - account: Account name for keychain item
        public static func delete(account: String) throws {
            if try self.exists(account: account) {
                return try self.deleteItem(account: account)
            } else {
                shared.log("Item does not exists")
//                throw AKError.operationError
            }
        }

        /// Funtion to add an item to keychain
        /// - parameters:
        ///   - value: Value to save in `data` format (String, Int, Double, Float, etc)
        ///   - account: Account name for keychain item
        internal static func add(value: String, account: String) throws {
            let dict = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrSynchronizable: true,
                kSecAttrAccount: account,
                kSecAttrService: shared.product, // service,
                // Allow background access:
                kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                kSecValueData: value.data(using: .utf8),
            ] as NSDictionary

            let status = SecItemAdd(dict, nil)

            guard status == errSecSuccess else {
                shared.log("Failed to execute query")
                shared.log("OSStatus: \(status)")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
        }

        /// Function to update an item to keychain
        /// - parameters:
        ///   - value: Value to replace for
        ///   - account: Account name for keychain item
        internal static func update(value: String, account: String) throws {
            guard let data = value.data(using: .utf8) else {
                shared.log("Failed to convert to data")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
            
            let update = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: shared.product, // service,
            ] as NSDictionary

            let value = [
                kSecValueData: data
            ] as NSDictionary

            let status = SecItemUpdate(update, value)

            guard status == errSecSuccess else {
                shared.log("Failed to execute query")
                shared.log("OSStatus: \(status)")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
        }

        /// Function to retrieve an item to keychain
        /// - parameters:
        ///   - account: Account name for keychain item
        internal static func retreive(account: String) throws -> String? {
            /// Result of getting the item
            var result: AnyObject?

            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: shared.product, // service,
                kSecReturnData: true,
            ] as NSDictionary

            /// Status for the query
            let status = SecItemCopyMatching(query, &result)

            // Switch to conditioning statement
            switch status {
            case errSecSuccess:
                guard let data = result as? Data else {
                    return nil
                }

                return String.init(
                    data: data,
                    encoding: .utf8
                )
            case errSecItemNotFound:
                return nil
            default:
                shared.log("Failed to execute query")
                shared.log("OSStatus: \(status)")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
        }

        /// Function to delete a single item
        /// - parameters:
        ///   - account: Account name for keychain item
        internal static func deleteItem(account: String) throws {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: shared.product, // service,
            ] as NSDictionary

            /// Status for the query
            let status = SecItemDelete(query)
            guard status == errSecSuccess else {
                shared.log("Failed to execute query")
                shared.log("OSStatus: \(status)")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
        }

        /// Function to delete all items for the app
        internal static func deleteAll() throws {
            let query = [
                kSecClass: kSecClassGenericPassword,
            ] as NSDictionary

            let status = SecItemDelete(query)

            guard status == errSecSuccess else {
                shared.log("Failed to execute query")
                shared.log("OSStatus: \(status)")
                shared.log("Group: \(shared.product)")
                throw AKError.operationError
            }
        }

        /// Function to check if we've an existing a keychain `item`
        /// - parameters:
        ///   - account: String type with the name of the item to check
        /// - returns: Boolean type with the answer if the keychain item exists
        static func exists(account: String) throws -> Bool {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: shared.product, // service,
                kSecReturnData: false,
            ] as NSDictionary

            /// Constant with current status about the keychain to check
            let status = SecItemCopyMatching(query, nil)

            // Switch to conditioning statement
            switch status {
            case errSecSuccess:
                return true
            case errSecItemNotFound:
                return false
            default:
                shared.log("Failed to execute query")
                throw AKError.creatingError
            }
        }
    }
}
