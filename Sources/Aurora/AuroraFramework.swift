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
private var Aurora_Loaded: Bool = true

open class Aurora {
    /**
     The shared instance of the "WDGWVFramework"
     - Parameter sharedInstance: The "WDGWVFramework" shared instance
     */
    public static let shared = Aurora(!_isDebugAssertConfiguration())
    
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
    public init(_ silent: Bool = false) {
        self.log("Aurora Framework \(self.version) loaded")
        #if os(iOS)
        self.log("Hello iOS")
        #elseif os(OSX)
        self.log("Hello OS X")
        #elseif os(watchOS)
        self.log("Hello  Watch")
        #elseif os(tvOS)
        self.log("Hello  TV")
        #endif
        
        self.log("_isDebugAssertConfiguration() = \(_isDebugAssertConfiguration())")
        self.debug = silent
        
        let iCloud: WDGFrameworkiCloudSync = WDGFrameworkiCloudSync()
        iCloud.startSync()
    }
    
    public func printif(_ str: Any, file: String = #file, line: Int = #line, function: String = #function) {
        if (debug) {
            let x: String = (file.split("/").last)!.split(".").first!
            Swift.print("[DEBUG] \(x):\(line) \(function):\n \(str)\n")
        }
    }
    
    /**
     ?
     */
    @discardableResult
    open func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) -> Bool {
        if (debug) {
            let x: String = (file.split("/").last)!.split(".").first!
            Swift.print("[DEBUG] \(x):\(line) \(function):\n \(message)\n")
        }
        
        return true
    }
    
    /**
     Is the framework loaded
     - Returns: loaded or not (Bool)
     */
    open func loaded() -> Bool {
        return Aurora_Loaded
    }
    
    #if canImport(CryptoKit)
    func md5(phrase: String) -> String {
        return phrase.md5
    }
    #endif
}

/// Support older configurations
open class WDGFramework: Aurora { }

