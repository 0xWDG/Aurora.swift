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

#if os(iOS) || os(tvOS)
#if canImport(AudioToolbox)
import AudioToolbox
#endif

public extension UIDevice {
    /// Generate a random uuid string.
    var idForVendor: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    /// Returns the systeme name.
    func systemName() -> String {
        return UIDevice.current.systemName
    }

    /// Returns the systeme version.
    @objc class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// Is the device running on low power mode?
    var lowPowerMode: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    /// Returns the device name.
    var deviceName: String {
        return UIDevice.current.name
    }

    /// Returns the device language.
    var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// Check if the device is either a Phone or not.
    var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// Check if the device is either a iPad or not.
    var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// Check if the device is either a TV or not.
    var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    /// Check if the we're running on CarPlay.
    var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }

    /// Check if the we're running on an Simulator.
    static var isSimulator: Bool = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()

    #if canImport(AudioToolbox)
    /// Vibrate the device
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
    #endif

    #if os(iOS) && !os(tvOS)
    /// Current screen orientation
    static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    #endif

    /// Screen width
    var screenWidth: CGFloat {
        #if os(iOS)
        if UIDevice.screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
        #elseif os(tvOS)
        return UIScreen.main.bounds.size.width
        #endif
    }

    /// Screen height
    static var screenHeight: CGFloat {
        #if os(iOS)
        if UIDevice.screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }
        #elseif os(tvOS)
        return UIScreen.main.bounds.size.height
        #endif
    }
}

// MARK: - Rotation
public extension UIDevice {
    #if !os(tvOS)
    /// Force the device rotation.
    /// - Parameter orientation: The orientation that the device will be forced to.
    class func forceRotation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.forceRotation(orientation)
    }

    /// Force the device rotation.
    /// - Parameter orientation: The orientation that the device will be forced to.
    func forceRotation(_ orientation: UIInterfaceOrientation) {
        setValue(orientation.rawValue, forKey: "orientation")
    }

    /// StatusBar height
    static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// Screen's height without StatusBar
    static var screenHeightWithoutStatusBar: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }
    #endif

    /// Returns the locale country code. An example value might be "ES".
    static var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }
}
#endif
#endif
