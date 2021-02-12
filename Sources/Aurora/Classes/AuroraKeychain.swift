// AURORA Keychain.

#if canImport(Security)
import Foundation
import Security

/**
 A collection of helper functions for saving text and data in the keychain.
 */
open class AuroraKeychain {
    
    var lastQueryParameters: [String: Any]? // Used by the unit tests
    
    /// Contains result code from the last operation. Value is noErr (0) for a successful result.
    open var lastResultCode: OSStatus = noErr
    
    var keyPrefix = "" // Can be useful in test.
    
    /**
     Specify an access group that will be used to access keychain items. Access groups can be used to share keychain items between applications. When access group value is nil all application access groups are being accessed. Access group name is used by all functions: set, get, delete and clear.
     */
    open var accessGroup: String?
    
    
    /**
     
     Specifies whether the items can be synchronized with other devices through iCloud. Setting this property to true will
     add the item to other devices with the `set` method and obtain synchronizable items with the `get` command. Deleting synchronizable items will remove them from all devices. In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
     
     Does not work on macOS.
     
     */
    open var synchronizable: Bool = true
    
    private let lock = NSLock()
    
    
    /// Instantiate a KeychainSwift object
    public init() { }
    
    /**
     
     - parameter keyPrefix: a prefix that is added before the key in get/set methods. Note that `clear` method still clears everything from the Keychain.
     */
    public init(keyPrefix: String) {
        self.keyPrefix = keyPrefix
    }
    
    /**
     
     Stores the text value in the keychain item under the given key.
     
     - parameter key: Key under which the text value is stored in the keychain.
     - parameter value: Text string to be written to the keychain.
     - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
     
     - returns: True if the text was successfully written to the keychain.
     */
    @discardableResult
    open func set(_ value: String, forKey key: String,
                  withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        
        if let value = value.data(using: String.Encoding.utf8) {
            return set(value, forKey: key, withAccess: access)
        }
        
        return false
    }
    
    /**
     
     Stores the data in the keychain item under the given key.
     
     - parameter key: Key under which the data is stored in the keychain.
     - parameter value: Data to be written to the keychain.
     - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
     
     - returns: True if the text was successfully written to the keychain.
     
     */
    @discardableResult
    open func set(_ value: Data, forKey key: String,
                  withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        deleteNoLock(key) // Delete any existing key before saving it
        let accessible = access?.value ?? KeychainSwiftAccessOptions.defaultOption.value
        
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String : Any] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : prefixedKey,
            KeychainSwiftConstants.valueData   : value,
            KeychainSwiftConstants.accessible  : accessible
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: true)
        lastQueryParameters = query
        print(query)
        
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
        
        return lastResultCode == noErr
    }
    
    /**
     Stores the boolean value in the keychain item under the given key.
     - parameter key: Key under which the value is stored in the keychain.
     - parameter value: Boolean to be written to the keychain.
     - parameter withAccess: Value that indicates when your app needs access to the value in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
     - returns: True if the value was successfully written to the keychain.
     */
    @discardableResult
    open func set(_ value: Bool, forKey key: String,
                  withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        
        let bytes: [UInt8] = value ? [1] : [0]
        let data = Data(bytes)
        
        return set(data, forKey: key, withAccess: access)
    }
    
    /**
     
     Retrieves the text value from the keychain that corresponds to the given key.
     
     - parameter key: The key that is used to read the keychain item.
     - returns: The text value from the keychain. Returns nil if unable to read the item.
     
     */
    open func get(_ key: String) -> String? {
        if let data = getData(key) {
            
            if let currentString = String(data: data, encoding: .utf8) {
                return currentString
            }
            
            lastResultCode = -67853 // errSecInvalidEncoding
        }
        
        return nil
    }
    
    /**
     
     Retrieves the data from the keychain that corresponds to the given key.
     
     - parameter key: The key that is used to read the keychain item.
     - parameter asReference: If true, returns the data as reference (needed for things like NEVPNProtocol).
     - returns: The text value from the keychain. Returns nil if unable to read the item.
     
     */
    open func getData(_ key: String, asReference: Bool = false) -> Data? {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String: Any] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : prefixedKey,
            KeychainSwiftConstants.matchLimit  : kSecMatchLimitOne
        ]
        
        if asReference {
            query[KeychainSwiftConstants.returnReference] = kCFBooleanTrue
        } else {
            query[KeychainSwiftConstants.returnData] =  kCFBooleanTrue
        }
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        lastQueryParameters = query
        
        print(query)
        
        var result: AnyObject?
        
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr {
            return result as? Data
        }
        
        return nil
    }
    
    /**
     Retrieves the boolean value from the keychain that corresponds to the given key.
     - parameter key: The key that is used to read the keychain item.
     - returns: The boolean value from the keychain. Returns nil if unable to read the item.
     */
    open func getBool(_ key: String) -> Bool? {
        guard let data = getData(key) else { return nil }
        guard let firstBit = data.first else { return nil }
        return firstBit == 1
    }
    
    /**
     Deletes the single keychain item specified by the key.
     
     - parameter key: The key that is used to delete the keychain item.
     - returns: True if the item was successfully deleted.
     
     */
    @discardableResult
    open func delete(_ key: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        return deleteNoLock(key)
    }
    
    /**
     Return all keys from keychain
     
     - returns: An string array with all keys from the keychain.
     
     */
    public var allKeys: [String] {
        var query: [String: Any] = [
            KeychainSwiftConstants.klass : kSecClassGenericPassword,
            KeychainSwiftConstants.returnData : true,
            KeychainSwiftConstants.returnAttributes: true,
            KeychainSwiftConstants.returnReference: true,
            KeychainSwiftConstants.matchLimit: KeychainSwiftConstants.secMatchLimitAll
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr {
            return (result as? [[String: Any]])?.compactMap {
                $0[KeychainSwiftConstants.attrAccount] as? String } ?? []
        }
        
        return []
    }
    
    /**
     
     Same as `delete` but is only accessed internally, since it is not thread safe.
     
     - parameter key: The key that is used to delete the keychain item.
     - returns: True if the item was successfully deleted.
     
     */
    @discardableResult
    func deleteNoLock(_ key: String) -> Bool {
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String: Any] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : prefixedKey
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        lastQueryParameters = query
        
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr
    }
    
    /**
     
     Deletes all Keychain items used by the app. Note that this method deletes all items regardless of the prefix settings used for initializing the class.
     
     - returns: True if the keychain items were successfully deleted.
     
     */
    @discardableResult
    open func clear() -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        var query: [String: Any] = [ kSecClass as String : kSecClassGenericPassword ]
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
        result[KeychainSwiftConstants.accessGroup] = accessGroup
        return result
    }
    
    /**
     
     Adds kSecAttrSynchronizable: kSecAttrSynchronizableAny` item to the dictionary when the `synchronizable` property is true.
     
     - parameter items: The dictionary where the kSecAttrSynchronizable items will be added when requested.
     - parameter addingItems: Use `true` when the dictionary will be used with `SecItemAdd` method (adding a keychain item). For getting and deleting items, use `false`.
     
     - returns: the dictionary with kSecAttrSynchronizable item added if it was requested. Otherwise, it returns the original dictionary.
     
     */
    func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
        if !synchronizable { return items }
        var result: [String: Any] = items
        result[KeychainSwiftConstants.attrSynchronizable] = addingItems == true ? true : kSecAttrSynchronizableAny
        return result
    }
}
/**
 These options are used to determine when a keychain item should be readable. The default value is AccessibleWhenUnlocked.
 */
public enum KeychainSwiftAccessOptions {
    
    /**
     
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
     
     This is the default value for keychain items added without explicitly setting an accessibility constant.
     
     */
    case accessibleWhenUnlocked
    
    /**
     
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     
     */
    case accessibleWhenUnlockedThisDeviceOnly
    
    /**
     
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
     
     */
    case accessibleAfterFirstUnlock
    
    /**
     
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     
     */
    case accessibleAfterFirstUnlockThisDeviceOnly
    
    /**
     
     The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
     
     This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
     
     */
    case accessibleWhenPasscodeSetThisDeviceOnly
    
    static var defaultOption: KeychainSwiftAccessOptions {
        return .accessibleWhenUnlocked
    }
    
    var value: String {
        switch self {
        case .accessibleWhenUnlocked:
            return toString(kSecAttrAccessibleWhenUnlocked)
            
        case .accessibleWhenUnlockedThisDeviceOnly:
            return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
            
        case .accessibleAfterFirstUnlock:
            return toString(kSecAttrAccessibleAfterFirstUnlock)
            
        case .accessibleAfterFirstUnlockThisDeviceOnly:
            return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
            
        case .accessibleWhenPasscodeSetThisDeviceOnly:
            return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        }
    }
    
    func toString(_ value: CFString) -> String {
        return KeychainSwiftConstants.toString(value)
    }
}
/// Constants used by the library
public struct KeychainSwiftConstants {
    /// Specifies a Keychain access group. Used for sharing Keychain items between apps.
    public static var accessGroup: String { return toString(kSecAttrAccessGroup) }
    
    /**
     
     A value that indicates when your app needs access to the data in a keychain item. The default value is AccessibleWhenUnlocked. For a list of possible values, see KeychainSwiftAccessOptions.
     
     */
    public static var accessible: String { return toString(kSecAttrAccessible) }
    
    /// Used for specifying a String key when setting/getting a Keychain value.
    public static var attrAccount: String { return toString(kSecAttrAccount) }
    
    /// Used for specifying synchronization of keychain items between devices.
    public static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
    
    /// An item class key used to construct a Keychain search dictionary.
    public static var klass: String { return toString(kSecClass) }
    
    /// Specifies the number of values returned from the keychain. The library only supports single values.
    public static var matchLimit: String { return toString(kSecMatchLimit) }
    
    /// A return data type used to get the data from the Keychain.
    public static var returnData: String { return toString(kSecReturnData) }
    
    /// Used for specifying a value when setting a Keychain value.
    public static var valueData: String { return toString(kSecValueData) }
    
    /// Used for returning a reference to the data from the keychain
    public static var returnReference: String { return toString(kSecReturnPersistentRef) }
    
    /// A key whose value is a Boolean indicating whether or not to return item attributes
    public static var returnAttributes : String { return toString(kSecReturnAttributes) }
    
    /// A value that corresponds to matching an unlimited number of items
    public static var secMatchLimitAll : String { return toString(kSecMatchLimitAll) }
    
    static func toString(_ value: CFString) -> String {
        return value as String
    }
}

/// Aurora Keychain
/// **WARNING DO NOT USE IT DOES NOT WORK WELL FOR A STRANGE REASON**
///
/// Aurora Keychain wrapper.
///
/// ⠀
///
/// **Add/update item**
///
/// `AuroraKeychain.shared.set(value: "MyValue", account: "Accountname")`
///
/// ⠀
///
/// **Fetch item**
///
/// `AuroraKeychain.shared.get(account: "Accountname")`
///
/// ⠀
///
/// **Delete (untested)**
///
/// `AuroraKeychain.shared.delete(account: "Accountname")`
///
/// ⠀
open class OLDAuroraKeychain {
    // MARK: - Shared
    /// Shared instance of AuroraKeychain
    public static let shared = OLDAuroraKeychain()
    
    // MARK: - Last statusses
    /// Last status returned by keychain
    public var lastStatus: OSStatus = OSStatus.init()
    
    /// Last result of keychain
    public var lastResult: CFTypeRef?
    
    /// Last query
    private var lastQuery: NSDictionary = [:]
    
    // MARK: - Private constants
    /// (default) Service name (Aurora)
    private let service: String = "Aurora"
    private let aShared: Aurora = Aurora.shared
    private let debug: Bool = true
    private let lock = NSLock()
    
    /// Success
    private let success = errSecSuccess
    /// Not found
    private let notfound = errSecItemNotFound
    
    /// Password classes
    private let secItemClasses = [
        kSecClassGenericPassword,
        kSecClassInternetPassword,
        kSecClassCertificate,
        kSecClassKey,
        kSecClassIdentity
    ]
    // MARK: - Init
    public init() {
        
    }
    
    private func kcDebug(query: NSDictionary, result: CFTypeRef?, status: OSStatus) -> NSDictionary {
        var description = "Not initialized"
        var resultType = "Unknown"
        
        switch status {
        case errSecDuplicateItem:
            description = "Keychain item already exists"
            
        /// -0
        case errSecSuccess:
            description = "Keychain query success"
            
        ///
        case errSecParam:
            description = "Something is wrong in your parameters"
            
        /// -25300
        case errSecItemNotFound:
            description = "Keychain item not found"
            
        ///
        case errSecNotAvailable:
            description = "Keychain query could not be run. Your device probably does not have a passcode."
            
        case errSecDiskFull:
            description = "The disk is full"
            
        default:
            description = "Keychain query resulted in status: \(status)"
        }
        
        if let resType = result {
            resultType = "\(type(of: resType))"
        }
        
        return [
            "query": query,
            "result": [
                "type": resultType,
                "result": result as Any
            ],
            "status": [
                "code": status,
                "description": description
            ]
        ]
    }
    
    // MARK: - Add
    /// Adds an item to the keychain.
    /// - Parameters:
    ///   - username: <#username description#>
    ///   - password: <#password description#>
    ///   - server: <#server description#>
    /// - Returns: <#description#>
    private func add(username: String, password: String, server: String) -> Bool {
        lastQuery = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: username,
            kSecValueData: password.data(using: .utf8)!,
            kSecAttrServer: server,
            kSecAttrSynchronizable: true,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecReturnAttributes: true
        ] as NSDictionary
        
        lastStatus = SecItemAdd(
            lastQuery,
            &lastResult
        )
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        
        return lastStatus == success
    }
    
    /// Adds an item to the keychain.
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - account: <#account description#>
    /// - Returns: <#description#>
    private func add(value: Data, account: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrSynchronizable: true,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
        ] as NSDictionary
        
        lastStatus = SecItemAdd(lastQuery, &lastResult)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        
        return lastStatus == success
    }
    
    // MARK: - Exists
    /// Does a certain item exist?
    /// - Parameter account: <#account description#>
    /// - Returns: <#description#>
    private func exists(account: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lastQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        
        lastStatus = SecItemCopyMatching(lastQuery, &lastResult)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        
        if lastStatus == success {
            if let _ = lastResult as? Data {
                return true
            }
            
            return true
        }
        
        return false
    }
    
    /// Does a certain item exist?
    /// - Parameters:
    ///   - username: <#username description#>
    ///   - server: <#server description#>
    /// - Returns: <#description#>
    private func exists(username: String, server: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: username,
            kSecAttrServer: server,
            kSecReturnData: false,
        ] as NSDictionary
        
        lastStatus = SecItemCopyMatching(lastQuery, &lastResult)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        
        return lastStatus == success
    }
    
    // MARK: - Set
    /// Stores a keychain item.
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - account: <#account description#>
    /// - Returns: <#description#>
    @discardableResult public func set(value: String, account: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else {
            return false
        }
        
        delete(account: account)
        
        return add(value: valueData, account: account)
    }
    
    /// Stores a keychain item.
    /// - Parameters:
    ///   - username: <#username description#>
    ///   - password: <#password description#>
    ///   - server: <#server description#>
    /// - Returns: <#description#>
    @discardableResult private func set(username: String, password: String, server: String) -> Bool {
        
        delete(account: username, server: server)
        
        return add(username: username, password: password, server: server)
    }
    
    // MARK: - Get
    
    /// <#Description#>
    /// - Parameters:
    ///   - account: <#account description#>
    ///   - server: <#server description#>
    /// - Returns: <#description#>
    /// - Example:
    ///
    ///
    private func get(account: String, server: String) -> (username: String?, password: String?) {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: server,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        
        lastStatus = SecItemCopyMatching(
            lastQuery,
            &lastResult
        )
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        if lastStatus == success {
            if let dict = lastResult as? NSDictionary,
               let username = dict[kSecAttrAccount] as? String,
               let passwordData = dict[kSecValueData] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                return (username: username, password: password)
            }
        }
        
        return (username: nil, password: nil)
    }
    
    /// <#Description#>
    /// - Parameter account: <#account description#>
    /// - Returns: <#description#>
    public func get(account: String) -> String? {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        
        lastStatus = SecItemCopyMatching(lastQuery, &lastResult)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        if lastStatus == success {
            if let data = lastResult as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        return nil
    }
    
    // MARK: - Delete
    /// Delete a single item.
    /// - Parameter account: <#account description#>
    /// - Returns: <#description#>
    @discardableResult public func delete(account: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ]
        
        lastStatus = SecItemDelete(lastQuery)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        
        return lastStatus == success
    }
    
    /// Delete a single item.
    /// - Parameters:
    ///   - account: <#account description#>
    ///   - server: <#server description#>
    /// - Returns: <#description#>
    @discardableResult private func delete(account: String, server: String) -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        lastQuery = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: account,
            kSecAttrServer: server,
        ] as NSDictionary
        
        lastStatus = SecItemDelete(lastQuery)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        return lastStatus == success
    }
    
    /// Delete all items for my app. Useful on eg logout.
    /// - Returns: true if deleted.
    @discardableResult public func deleteAll() -> Bool {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        var resultArray: [Bool] = []
        
        for itemClass in secItemClasses {
            lastQuery = [kSecClass: itemClass]
            lastStatus = SecItemDelete(lastQuery)
            
            aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
            
            resultArray.append(lastStatus == success)
        }
        
        return resultArray.map { $0 == false }.count == 0
    }
    
    /// Dump all passwords
    public func getAllKeychainItems() {
        // The lock prevents the code to be run simultaneously
        // from multiple threads which may result in crashing
        lock.lock()
        defer { lock.unlock() }
        
        for secClass in secItemClasses {
            getAllKeyChainItemsOfClass(secClass)
        }
    }
    
    /// <#Description#>
    /// - Parameter secClass: <#secClass description#>
    private func getAllKeyChainItemsOfClass(_ secClass: CFString) {
        lastQuery = [
            kSecClass: secClass,
            kSecMatchLimit: kSecMatchLimitAll,
            kSecReturnData: true
        ]
        
        lastStatus = SecItemCopyMatching(lastQuery, &lastResult)
        
        aShared.log(kcDebug(query: lastQuery, result: lastResult, status: lastStatus))
        
        if lastStatus == success {
            if let loop = lastResult as? NSMutableArray {
                for lastResult in loop {
                    
                    if let data = lastResult as? Data,
                       let password = String(data: data, encoding: .utf8) {
                        print(password)
                    }
                    
                    if let dict = lastResult as? NSDictionary,
                       let username = dict[kSecAttrAccount] as? String,
                       let passwordData = dict[kSecValueData] as? Data,
                       let password = String(data: passwordData, encoding: .utf8) {
                        print("username: \(username), password: \(password)")
                    }
                }
            }
        }
    }
}
#endif
