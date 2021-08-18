// $$HEADER$$

import Foundation

public extension Locale {
    
    /// Get the flag emoji for a given country region code.
    /// - Parameter isoRegionCode: The IOS region code.
    ///
    /// Adapted from https://stackoverflow.com/a/30403199/1627511
    static func flagEmoji(forRegionCode isoRegionCode: String) -> String? {
        guard isoRegionCodes.contains(isoRegionCode) else { return nil }
        
        return isoRegionCode.unicodeScalars.reduce(into: String()) {
            guard let flagScalar = UnicodeScalar(
                    UInt32(127397) + $1.value
            ) else { return }
            
            $0.unicodeScalars.append(flagScalar)
        }
    }
}
