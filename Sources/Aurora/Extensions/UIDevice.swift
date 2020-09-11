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
#if canImport(UIKit)
import UIKit

#if os(iOS)
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
    
    #if canImport(AudioToolbox)
    /// Vibrate the device
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
    #endif
}

// MARK: - Rotation
#if os(iOS)
extension UIDevice {
    /// Force the device rotation.
    /// - Parameter orientation: The orientation that the device will be forced to.
    public class func forceRotation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.forceRotation(orientation)
    }
    
    /// Force the device rotation.
    /// - Parameter orientation: The orientation that the device will be forced to.
    public func forceRotation(_ orientation: UIInterfaceOrientation) {
        setValue(orientation.rawValue, forKey: "orientation")
    }
    
}
#endif
#endif
#endif
