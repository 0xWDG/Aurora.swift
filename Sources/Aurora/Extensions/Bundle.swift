// $$HEADER$$

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
