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
}
#endif
