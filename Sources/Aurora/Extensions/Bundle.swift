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
    /// Version number
    public var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Build number
    public var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
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
}
#endif
