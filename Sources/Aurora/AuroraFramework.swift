// $$HEADER$$

import Foundation
import CommonCrypto

#if os(iOS)
import UIKit
#endif
#if os(OSX)
import AppKit
#endif
#if canImport(CryptoKit)
import CryptoKit
#endif

/// The Aurora framework for swift
///
/// The **Aurora.framework** contains a base for your project.
///
/// It has a lot of extensions built-in to make development easier
///
/// - Version: 1.0
/// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
///  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
open class Aurora {
    /**
     The shared instance of the "AuroraFramework"
     - Parameter sharedInstance: The "AuroraFramework" shared instance
     */
    public static let shared = Aurora()
    
    /**
     The version of
     - Parameter version: The version of AuroraFramework
     */
    public let version = "1.0"
    
    /**
     The product name
     - Parameter product: The product name
     */
    public let product = "Aurora Framework"
    
    /// Should we debug right now?
    private var debug = _isDebugAssertConfiguration()
    
    /**
     This will setup iCloud sync!
     NSUserDefaults to iCloud & Back.
     */
    public init(_ silent: Bool = true) {
        #if os(iOS)
        self.log("Aurora Framework for iOS \(self.version) loaded")
        #elseif os(macOS)
        self.log("Aurora Framework for Mac OS \(self.version) loaded")
        #elseif os(watchOS)
        self.log("Aurora Framework for WachtOS \(self.version) loaded")
        #elseif os(tvOS)
        self.log("Aurora Framework for tvOS \(self.version) loaded")
        #elseif os(Android)
        self.log("Aurora Framework for Android \(self.version) loaded")
        #elseif os(Windows)
        self.log("Aurora Framework for Windows \(self.version) loaded")
        #elseif os(Linux)
        self.log("Aurora Framework for Linux \(self.version) loaded")
        #else
        self.log("Aurora Framework \(self.version) loaded")
        self.log("Unknown platform")
        #endif
        
        #if os(iOS)
        let iCloud: WDGFrameworkiCloudSync = WDGFrameworkiCloudSync()
        iCloud.startSync()
        #endif
        
        _ = AuroraCrashHandler.shared
    }
    
    /**
     ?
     */
    @discardableResult
    public func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) -> Bool {
        if (debug) {
            let fileName: String = (file.split("/").last)!.split(".").first!
            Swift.print("[Aurora.Framework] \(fileName):\(line) \(function):\n \(message)\n")
        }
        
        return debug
    }
    
    #if canImport(CryptoKit)
    public func md5(phrase: String) -> String {
        return phrase.md5
    }
    #endif
}

/// Support older configurations
open class WDGFramework: Aurora { }
