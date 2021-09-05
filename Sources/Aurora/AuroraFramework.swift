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

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(CryptoKit)
import CryptoKit
#endif

#if canImport(CommonCrypto)
import CommonCrypto
#endif

/// The Aurora framework for swift
///
/// **Aurora.framework** contains a base for your project.
///
/// It has a lot of extensions, functions and classes built-in to make development easier.
///
/// See the [Online documentation](https://github.com/AuroraFramework/Aurora.swift/wiki) \
/// for more information about all the built-in extensions, functions and classes.
///
/// - Experiment: to start experimental functions use the following code in your app(delegate):
///
/// ``Aurora.shared.startExperimentalFunctions()``
/// - Version: 1.0
/// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
///  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
open class Aurora {
    /// The shared instance of **Aurora.framework**
    public static let shared = Aurora()

    /// **Aurora.framework** reference (to use `Aurora.load.className`)
    public static let load = Aurora.self

    /// Initialize crash handler
    internal static let crashLogger = Aurora.load.CrashHandler.shared

    /// the version
    public let version = "1.0"

    /// The product name
    public let product = "Aurora.Framework"

    /// Extra detailed logging?
    internal var detailedLogging = true

    /// Should we debug right now?
    internal var debug = _isDebugAssertConfiguration()

    /// If this is non-nil, we will call it with the same string that we
    /// are going to print to the console. You can use this to pass log
    /// messages along to your crash reporter, analytics service, etc.
    /// - warning: Be mindful of private user data that might end up in
    ///            your log statements! Use log levels appropriately
    ///            to keep private data out of logs that are sent over
    ///            the Internet.
    public var logHandler: ((String) -> Void)?

    /// Logging history
    internal var logHistory: [String] = []

    /// Date format
    /// Describe here how the date logging needs to be done
    /// within `Aurora.shared.log(...)` log messages/functions
    ///
    /// If the full date is required use:
    ///
    /// `Aurora.shared.dateFormat = "yyyy-MM-dd HH:mm:ss"`
    ///
    /// Defaults to:
    /// `Aurora.shared.dateFormat = "HH:mm:ss"`
    internal var dateFormat = "HH:mm:ss"

    /// Dateformatter
    internal var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    /// logTemplate
    ///
    /// This is used to send log messages with the following syntax
    ///
    ///     [Aurora.Framework] datetime Filename:line functionName(...) @Main/Background:
    ///      Message
    ///
    /// **Want to use a custom template?**
    ///
    /// Put the following (preffered in your AppDelegate):
    ///
    ///      Aurora.shared.logTemplate = "[$product] $datetime $file:$line $function @$queue:\n $message"
    ///
    ///
    /// **$datetime**
    ///
    /// _Datetime string_
    ///
    /// ‎
    ///
    /// **$file**
    /// 
    /// _Filename where the log function is called_
    ///
    /// ‎
    ///
    /// **$extension**
    ///
    /// _File extension_
    ///
    /// ‎
    ///
    /// **$line**
    ///
    /// _Line where the log function is called_
    ///
    /// ‎
    ///
    /// **$function**
    ///
    /// _The function wherein the log function is called_
    ///
    /// ‎
    ///
    /// **$queue**
    ///
    /// _The queue wherein the log function is called (Main/Background)_
    ///
    /// ‎
    ///
    /// **$message**
    ///
    /// _Message to log_
    ///
    /// ‎
    public var logTemplate = "[$product] $datetime $file:$line $function @$queue:\n $message"

    /// userAgent
    ///
    /// This is used to generate the user agent
    ///
    ///     Mozilla/5.0 (Aurora/1.0; MyAppName/appVersion; iOS/15.0)
    ///
    /// **Want to use a custom template?**
    ///
    /// Put the following (preffered in your AppDelegate):
    ///
    ///      Aurora.shared.userAgentTemplate = "Mozilla/5.0 ($product/$version; $appName/$appVersion; $os/$osVersion)"
    ///
    ///
    /// **$product**
    ///
    /// _Aurora.framework_
    ///
    /// ‎
    ///
    /// **$version**
    ///
    /// _Aurora Framework version_
    ///
    /// ‎
    ///
    /// **$appName**
    ///
    /// _Your app's name_
    ///
    /// ‎
    ///
    /// **$version**
    ///
    /// _Your app's version_
    ///
    /// ‎
    ///
    /// **$os**
    ///
    /// _Current OS_
    ///
    /// ‎
    ///
    /// **$osVersion**
    ///
    /// _Current OS Version_
    ///
    /// ‎
    ///
    /// **$deviceType**
    ///
    /// _Device type_
    ///
    /// ‎
    ///
    public var userAgent: String {
        get {
            var returnValue = userAgentTemplate
                .replace("$product", withString: self.product)
                .replace("$auroraVersion", withString: self.version)
                .replace("$version", withString: self.version)
                .replace("$osVersion", withString: self.operatingVersion)

            #if canImport(UIKit) && !os(watchOS)
            var utsnameInstance = utsname()
            uname(&utsnameInstance)
            let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    String.init(validatingUTF8: $0)
                }
            }

            returnValue = returnValue
                .replace(
                    "$appName",
                    withString:
                        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
                        ?? ""
                )
                .replace(
                    "$deviceType",
                    withString: optionalString ?? "N/A"
                )
                .replace(
                    "$appVersion",
                    withString:
                        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
                        ?? ""
                )
                .replace(
                    "$appBuild",
                    withString:
                        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
                        ?? ""
                )
            #else
            returnValue = returnValue
                .replace("$appName", withString: "")
                .replace("$appVersion", withString: "")
                .replace("$appBuild", withString: "")
            #endif

            #if os(Android)
            returnValue = returnValue.replace("$os", withString: "Android")
            #elseif os(iOS)
            returnValue = returnValue.replace("$os", withString: "iOS")
            #elseif os(Linux)
            returnValue = returnValue.replace("$os", withString: "Linux")
            #elseif os(macOS)
            returnValue = returnValue.replace("$os", withString: "macOS")
            #elseif os(tvOS)
            returnValue = returnValue.replace("$os", withString: "tvOS")
            #elseif os(watchOS)
            returnValue = returnValue.replace("$os", withString: "watchOS")
            #elseif os(Windows)
            returnValue = returnValue.replace("$os", withString: "Windows")
            #else
            returnValue = returnValue.replace("$os", withString: "Aurora")
            #endif

            return returnValue
        }
        set {
            userAgentTemplate = newValue
        }
    }

    /// userAgentTemplate
    ///
    /// This is used to generate the user agent
    ///
    ///     Mozilla/5.0 (Aurora/1.0; MyAppName/appVersion; iOS/15.0)
    private var userAgentTemplate = "Mozilla/5.0 ($product/$version; $appName/$appVersion; $os/$osVersion)"

    /// Is it already started?
    var isInitialized: Bool = false

    /// Which os we are running on?
    var operatingSystem: AuroraOS = .unknown

    /// Which os we are running on?
    var operatingVersion: String = "Unknown"

    /// **Aurora.framework** Nil value
    static public let AFnil = "AuroraFramework=Nilvalue"

    /// Initialize
    public init(experimentalFunctions: Bool = false) {
        #if os(iOS)
        self.operatingSystem = .iOS
        #elseif os(macOS)
        self.operatingSystem = .macOS
        #elseif os(watchOS)
        self.operatingSystem = .watchOS
        #elseif os(tvOS)
        self.operatingSystem = .tvOS
        #elseif os(Android)
        self.operatingSystem = .android
        #elseif os(Windows)
        self.operatingSystem = .windows
        #elseif os(Linux)
        self.operatingSystem = .linux
        #endif

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        self.operatingVersion = [
            ProcessInfo().operatingSystemVersion.majorVersion,
            ProcessInfo().operatingSystemVersion.minorVersion,
            ProcessInfo().operatingSystemVersion.patchVersion
        ].map { $0.toString }.joined(separator: ".")
#endif

        self.log(
            self.translate(message: "Aurora.loaded", [
                "$VERSION": self.version,
                "$OVersion": self.operatingVersion,
                "$OS": self.operatingSystem.rawValue
            ])
        )

        self.log("Device name: \(ProcessInfo().hostName)")

        isInitialized = true
    }

    private func translate(message: String, _ replacements: [String: String]?) -> String {
        var msg = NSLocalizedString(
            message,
            bundle: Bundle.module,
            comment: message
        )

        if let replacement = replacements {
            for (replace, with) in replacement {
                msg = msg.replace(replace, withString: with)
            }
        }

        return msg
    }

    /// Start Aurora classes/functions
    private func startAuroraFunctions() {
        #if os(iOS)
        let iCloudSync: AuroraiCloudSync = AuroraiCloudSync()
        iCloudSync.start()
        #endif
    }

    /// Start experimental functions
    public func startExperimentalFunctions() {
        AuroraNetworkLogger.register()
    }
}

/// Run block
public typealias AuroraBlock = () -> Void

/// Support older configurations
open class WDGFramework: Aurora { }
