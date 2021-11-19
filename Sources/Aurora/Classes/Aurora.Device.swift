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

#if canImport(UIKit)
import UIKit
#endif

/// Operating Systems
public enum AuroraOS: String {
    case macOS = "Mac OS"
    case iOS
    case iPadOS
    case tvOS
    case watchOS
    case audioOS, homePod = "homePod"
    case bridgeOS, touchBar = "touchBar"
    case android = "Android"
    case linux = "Linux"
    case windows = "Windows"
    case freeBSD = "Free BSD"
    case openBSD = "Open BSD"
    case unknown = "Unknown"
}

/// User Interfaces
public enum AuroraUserInterface {
    /// Carplay
    case carPlay

    /// MacOS
    case mac

    /// iPad
    case pad

    /// iPhone
    case phone
    ///  TV
    case tv
    // swiftlint:disable:previous identifier_name

    ///  Watch
    case watch

    /// Window
    case window

    /// Unknown
    case unknown
}

/// On which device is the framework running?
public class AuroraDevice {
    /// Is running iOS app on Mac?
    var isiOSAppOnMac: Bool {
        if #available(macOS 11.0, *, iOS 14.0, *) {
            return ProcessInfo().isiOSAppOnMac
        }

        return false
    }

    /// Is running as Catalyst app on Mac?
    var isMacCatalystApp: Bool {
        if #available(macOS 11.0, *, iOS 13.0, *) {
            return ProcessInfo().isMacCatalystApp
        }

        return false
    }

#if canImport(UIKit)
    /// Are we running on Carplay?
    var isCarplay: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .carPlay
        }.count >= 1
    }

    /// Are we running on a Mac?
    var isMac: Bool {
        if #available(iOS 14.0, *, tvOS 14.0, *) {
            return UIScreen.screens.filter {
                $0.traitCollection.userInterfaceIdiom == .mac
            }.count >= 1
        }

        return false
    }

    /// Are we running on a iPad?
    var isiPad: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .pad
        }.count >= 1
    }

    /// Are we running on a iPhone?
    var isiPhone: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .phone
        }.count >= 1
    }

    /// Are we running on a TV?
    var isTV: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .tv
        }.count >= 1
    }

    /// Are we running on something unspecified??
    var isUnspecified: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .unspecified
        }.count >= 1
    }

    /// Get the first (active) carPlay screen.
    var getCarplayScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .carPlay
        })
    }

    /// Get the first (active) Mac screen.
    var getMacScreen: UIScreen? {
        if #available(iOS 14.0, *, tvOS 14.0, *) {
            return UIScreen.screens.first(where: {
                $0.traitCollection.userInterfaceIdiom == .mac
            })
        }

        // Not supported (yet)
        return nil
    }

    /// Get the first (active) iPad screen.
    var getiPadScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .pad
        })
    }

    /// Get the first (active) iPhone screen.
    var getiPhoneScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .phone
        })
    }

    /// Get the first (active) TV screen.
    var getTVScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .tv
        })
    }

    /// Get the first (active) unspecified screen.
    var getScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .unspecified
        })
    }
#endif

    /// Get device name
    /// - Returns: Devicename
    func getDeviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }

    /// Get the current operating system
    /// - Returns: current operating system
    func getOperatingSystem() -> AuroraOS {
        return Aurora.shared.operatingSystem
    }

    func getUserInterface() -> AuroraUserInterface {
#if canImport(UIKit)
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay:
            return .carPley

        case .mac:
            return .mac

        case .pad:
            return .pad

        case .phone:
            return .phone

        case .tv:
            return .tv

        default:
            return .unknown
        }
#else
        return .unknown
#endif
    }
}
