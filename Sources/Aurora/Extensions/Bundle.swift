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
private class AuroraBundleFinder {}

public extension Bundle {
    /// The app name
    var appName: String {
        return string(for: kCFBundleNameKey as String)
    }
    
    /// The app version
    @objc var appVersion: String {
        return string(for: "CFBundleShortVersionString")
    }
    
    /// The display name
    var displayName: String {
        return string(for: "CFBundleDisplayName")
    }
    
    /// The app build number
    var appBuild: String {
        return string(for: kCFBundleVersionKey as String)
    }
    
    /// The app bundle identifier
    var bundleId: String {
        return string(for: "CFBundleIdentifier")
    }
    
    /// Check either the app has been installed using TestFlight.
    var isInTestFlight: Bool {
        return appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    
    /// Runtime code to check if the code runs in an app extension
    var isAppExtension: Bool {
        return executablePath?.contains(".appex/") ?? false
    }
    
    /// Is the device running with "Low Power Mode" enabled?
    var isOnLowPowerMode: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    /// Get the system uptime
    var uptime: TimeInterval {
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
    var schemes: [String] {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let urlTypes = infoDictionary["CFBundleURLTypes"] as? [AnyObject],
            let urlType = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlType["CFBundleURLSchemes"] as? [String] else {
                return []
        }
        return urlSchemes
    }
    
    /// <#Description#>
    var mainScheme: String? {
        return schemes.first
    }
}

import class Foundation.Bundle

public extension Foundation.Bundle {
    // Thanks 'DateTimePicker'
    // https://github.com/itsmeichigo/DateTimePicker/pull/104/files
    // Since Xcode isnt fixed, we'll use this.

    /// The resource bundle associated with the current module..
    /// important: When `Aurora` is distributed via Swift Package Manager,
    /// it will be synthesized automatically in the name of `Bundle.module`.
    static var resource: Bundle = {
         let moduleName = "Aurora"
         #if COCOAPODS
         let bundleName = moduleName
         #else
         let bundleName = "\(moduleName)_\(moduleName)"
         #endif

          let candidates = [
             // Bundle should be present here when the package is linked into an App.
             Bundle.main.resourceURL,

              // Bundle should be present here when the package is linked into a framework.
             Bundle(for: AuroraBundleFinder.self).resourceURL,

              // For command-line tools.
             Bundle.main.bundleURL
         ]

          for candidate in candidates {
             let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
             if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                 return bundle
             }
         }

          fatalError("Unable to find bundle named \(bundleName)")
     }()
 }

#if !SWIFT_PACKAGE
        // AS DEFINED IN SWIFTPM
        // https://github.com/apple/swift-package-manager/blob/main/Sources/Build/BuildPlan.swift#L591-L606
        // extension Foundation.Bundle {
        //     static var module: Bundle = {
        //         let mainPath = "\(mainPath.asSwiftStringLiteralConstant)"
        //         let buildPath = "\(bundlePath.asSwiftStringLiteralConstant)"
        //         let preferredBundle = Bundle(path: mainPath)
        //         guard let bundle = preferredBundle != nil ? preferredBundle : Bundle(path: buildPath) else {
        //             fatalError("could not load resource bundle: from \\(mainPath) or \\(buildPath)")
        //         }
        //         return bundle
        //     }()
        // }
#endif
#endif
