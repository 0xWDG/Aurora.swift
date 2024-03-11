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

#if canImport(UIKit)
import UIKit
#endif

#if !os(tvOS) && canImport(CoreTelephony)
import CoreTelephony
#endif

extension Aurora {
    /// Get the last crash log
    /// - Returns: The last crashlog
    public func getLastCrashLog() -> String? {
        return crashLogger.getLastCrashLog()
    }

    /// Delete the last crash log
    /// - Returns: Bool if deleted
    @discardableResult
    public func deleteLastCrashLog() -> Bool {
        return crashLogger.deleteLastCrashLog()
    }

    /// Crash
    public func generateCrash() {
        crashLogger.generateCrash()
    }
}

/// Aurora Crash Handler
class AuroraCrashHandler {
    /// Shared Instance
    public static let shared: AuroraCrashHandler = AuroraCrashHandler.init()

    /// Signal codes
    private let signalCodes = [
        SIGABRT: "SIGABRT: abort()",
        SIGILL: "SIGILL: illegal instruction (not reset when caught)",
        SIGSEGV: "SIGSEGV: segmentation violation",
        SIGFPE: "SIGFPE: floating point exception",
        SIGBUS: "SIGBUS: Bus error",
        SIGHUP: "SIGHUP: hangup",
        SIGINT: "SIGINT: interrupt",
        SIGQUIT: "SIGQUIT: quit",
        SIGTRAP: "SIGTRAP: trace trap (not reset when caught) [Swift]",
        SIGKILL: "SIGKILL: kill (cannot be caught or ignored)",
        SIGPIPE: "SIGPIPE: write on a pipe with no one to read it",
        SIGTERM: "SIGTERM: software termination signal from kill",
        SIGEMT: "SIGEMT: EMT instruction",
        SIGSYS: "SIGSYS: bad argument to system call",
        SIGALRM: "SIGALRM: alarm clock",
        SIGURG: "SIGURG: urgent condition on IO channel",
        SIGSTOP: "SIGSTOP: sendable stop signal not from tty",
        SIGTSTP: "SIGTSTP: stop signal from tty",
        SIGCONT: "SIGCONT: continue a stopped process",
        SIGCHLD: "SIGCHLD: to parent on child stop or exit",
        SIGTTIN: "SIGTTIN: to readers pgrp upon background tty read",
        SIGTTOU: "SIGTTOU: like TTIN for output if (tp->t_local&LTOSTOP)",
        SIGIO: "SIGIO: input/output possible signal",
        SIGXCPU: "SIGXCPU: exceeded CPU time limit",
        SIGXFSZ: "SIGXFSZ: exceeded file size limit",
        SIGVTALRM: "SIGVTALRM: virtual time alarm",
        SIGPROF: "SIGPROF: profiling time alarm",
        SIGWINCH: "SIGWINCH: window size changes",
        SIGINFO: "SIGINFO: information request",
        SIGUSR1: "SIGUSR1: user defined signal 1",
        SIGUSR2: "SIGUSR2: user defined signal 2"
    ]

    /// Receive signal (C Bridge)
    private static let RecieveSignal: @convention(c) (Int32) -> Void = { (signal) -> Void in
        AuroraCrashHandler.createReport(from: signal)
    }

    /// Receive exception (C Bridge)
    private static let RecieveException: @convention(c) (NSException) -> Swift.Void = { (theExteption) -> Void in
        AuroraCrashHandler.createReport(from: theExteption)
    }

    /// Create crash/exception report
    /// - Parameter from: from data
    private class func createReport(from: Any) { // swiftlint:disable:this function_body_length
        var crashReport = ""
        crashReport += "Aurora Framework (v\(Aurora.shared.version)) crash report\n\n"

#if canImport(UIKit) && !os(watchOS)
        let device = UIDevice.current
        var deviceType: String {
            var utsnameInstance = utsname()
            uname(&utsnameInstance)
            let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    String.init(validatingUTF8: $0)
                }
            }

            return optionalString ?? "N/A"
        }

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
        let appVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")
        let appBuild = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "")

        crashReport += "\tApp:\n"
        crashReport += "\t\tName: \(appName)\n"
        crashReport += "\t\tVersion: \(appVersion)\n"
        crashReport += "\t\tBuild: \(appBuild)\n"

        crashReport += "\n"
        crashReport += "\tDevice:\n"
        crashReport += "\t\tName: \(device.name)\n"
        crashReport += "\t\tModel: \(deviceType)\n"
        crashReport += "\t\tSoftware: \(device.systemName) \(device.systemVersion)\n"

        // For some weird reason this will crash,
        // Even if canImport says true.
#if !os(tvOS) && canImport(CoreTelephony)
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
            if let carrierName = carrier.carrierName {
                crashReport += "\t\tCarrier: \(carrierName)\n"
            }
        }
#endif
#endif

        if let fromException = from as? NSException {
            crashReport += "\n"
            crashReport += "\tException:\n"
            crashReport += "\t\tName: \(fromException.name)\n"
            crashReport += "\t\tReason: \(fromException.reason ?? "Unknown")\n"
            crashReport += "\t\tStack trace:\n\t\t\t"
            crashReport += fromException.callStackSymbols.joined(separator: "\n\t\t\t")
            crashReport += "\n"
        }

        if let signal = from as? Int32 {
            var stack = Thread.callStackSymbols
            stack.removeFirst(2)

            crashReport += "\n"
            crashReport += "\tSignal:\n"
            crashReport += "\t\tName: Signal (\(signal)) was raised.\n"
            crashReport += "\t\tStack trace:\n\t\t\t\(stack.joined(separator: "\n\t\t\t"))\n"
        }

        crashReport += "\nEnd of Aurora crash report\n\n"
        Aurora.shared.log(crashReport)

        // Try to save to the disk

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("AuroraCrashDump")
            do {
                try Data(crashReport.utf8).write(to: fileURL)

                Aurora.shared.log("Saved crash report to: \(fileURL)")
            } catch let error as NSError {
                Aurora.shared.log("Failed to write to \(fileURL)")
                Aurora.shared.log(error.description)
            }
        }
    }

    /// Get last crash log
    /// - Returns: last crash log
    public func getLastCrashLog() -> String? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("AuroraCrashDump")
            if let crashLog = try? String(contentsOf: fileURL) {
                return crashLog
            }
        }

        return nil
    }

    /// Delete last crash log
    /// - Returns: succeed?
    @discardableResult
    public func deleteLastCrashLog() -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("AuroraCrashDump")
            do {
                try FileManager.default.removeItem(at: fileURL)

                return true
            } catch let error as NSError {
                Aurora.shared.log("Failed to remove \(fileURL)")
                Aurora.shared.log(error.description)
            }
        }

        return false
    }

    /// Did we already register?
    private var didRegister = false

    /// Initialize
    init() {
        // Ok.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AuroraCrashHandler.shared.registerForSignals()
        }
    }

    /// Register for signals
    func registerForSignals() {
        if !didRegister {
            NSSetUncaughtExceptionHandler(AuroraCrashHandler.RecieveException)

            for (signalCode, _) in signalCodes {
                signal(signalCode, AuroraCrashHandler.RecieveSignal)
            }

            didRegister = true
        }
    }

    /// generate a crash.
    @discardableResult
    public func generateCrash() -> String {
        return ["hi", "crash"][2]
    }
}
#endif
