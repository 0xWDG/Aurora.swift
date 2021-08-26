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
