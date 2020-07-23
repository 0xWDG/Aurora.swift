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

#if os(iOS)
extension Bundle {
    /// The app name
    public var appName: String {
        string(for: kCFBundleNameKey as String)
    }
    
    /// The app version
    @objc public var appVersion: String {
        string(for: "CFBundleShortVersionString")
    }
    
    /// The display name
    public var displayName: String {
        string(for: "CFBundleDisplayName")
    }
    
    /// The app build number
    public var appBuild: String {
        string(for: kCFBundleVersionKey as String)
    }
    
    /// The app bundle identifier
    public var bundleId: String {
        string(for: "CFBundleIdentifier")
    }
    
    /// Check either the app has been installed using TestFlight.
    public var isInTestFlight: Bool {
        appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    
    /// Runtime code to check if the code runs in an app extension
    public var isAppExtension: Bool {
        return executablePath?.contains(".appex/") ?? false
    }
    
    /// Is the device running with "Low Power Mode" enabled?
    public var isOnLowPowerMode: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    /// Get the system uptime
    public var uptime: TimeInterval {
        return ProcessInfo.processInfo.systemUptime
    }
    
    /// <#Description#>
    /// - Parameter key: <#key description#>
    /// - Returns: <#description#>
    private func string(for key: String) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let value = infoDictionary[key] as? String else {
                return ""
        }
        return value
    }
    
    /// <#Description#>
    public var schemes: [String] {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let urlTypes = infoDictionary["CFBundleURLTypes"] as? [AnyObject],
            let urlType = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlType["CFBundleURLSchemes"] as? [String] else {
                return []
        }
        return urlSchemes
    }
    
    /// <#Description#>
    public var mainScheme: String? {
        schemes.first
    }
}
#endif
