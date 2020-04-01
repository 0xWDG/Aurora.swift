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

open class Aurora {
    /**
     The shared instance of the "WDGWVFramework"
     - Parameter sharedInstance: The "WDGWVFramework" shared instance
     */
    public static let shared = Aurora()
    
    /**
     The version of WDGWVFramework
     - Parameter version: The version of WDGWVFramework
     */
    public let version = "0.1a"//WDGFrameworkVersionNumber
    
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
        #endif
                
        let iCloud: WDGFrameworkiCloudSync = WDGFrameworkiCloudSync()
        iCloud.startSync()
    }
    
    /**
     ?
     */
    @discardableResult
    func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) -> Bool {
        if (debug) {
            let x: String = (file.split("/").last)!.split(".").first!
            Swift.print("[Aurora.Framework] \(x):\(line) \(function):\n \(message)\n")
        }
        
        return debug
    }
    
    #if canImport(CryptoKit)
    func md5(phrase: String) -> String {
        return phrase.md5
    }
    #endif
}

/// Support older configurations
open class WDGFramework: Aurora { }

