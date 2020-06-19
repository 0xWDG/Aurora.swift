//
//  crashHandler.swift
//  Aurora
//
//  Created by Wesley de Groot on 10/04/2020.
//

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

//#if canImport(CoreTelephony)
//import CoreTelephony
//#endif

/// <#Description#>
class AuroraCrashHandler {
    /// <#Description#>
    static public let shared: AuroraCrashHandler = AuroraCrashHandler.init()
    
    /// <#Description#>
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
    
    /// <#Description#>
    private static let RecieveSignal : @convention(c) (Int32) -> Void = {
        (signal) -> Void in       
        AuroraCrashHandler.createReport(from: signal)
    }
    
    /// <#Description#>
    private static let RecieveException: @convention(c) (NSException) -> Swift.Void = {
        (theExteption) -> Void in
        AuroraCrashHandler.createReport(from: theExteption)
    }
    
    /// <#Description#>
    /// - Parameter from: <#from description#>
    private class func createReport(from: Any) {
        var crashReport = ""
        crashReport += "Aurora Framework (v\(Aurora.shared.version)) crash report\n\n"
        
        #if canImport(UIKit)
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
        
//        #if canImport(CoreTelephony)
//        let networkInfo = CTTelephonyNetworkInfo()
//        if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
//            if let carrierName = carrier.carrierName {
//                crashReport += "\t\tCarrier: \(carrierName)\n"
//            }
//        }
//        #endif
        #endif
        
        if let fromException = from as? NSException {
            crashReport += "\n"
            crashReport += "\tException:\n"
            crashReport += "\t\tName: \(fromException.name)\n"
            crashReport += "\t\tReason: \(fromException.reason ?? "Unknown")\n"
            crashReport += "\t\tStack trace:\n\t\t\t\(fromException.callStackSymbols.joined(separator: "\n\t\t\t"))\n"
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
            let fileURL = dir.appendingPathComponent("crash.txt")
            do {
                try Data(crashReport.utf8).write(to: fileURL)
                
                Aurora.shared.log("Saved crash report to: \(fileURL)")
            } catch let error as NSError {
                Aurora.shared.log("Failed to write to \(fileURL)")
                Aurora.shared.log(error.description)
            }
        }
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getLastCrashLog() -> String? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("crash.txt")
            if let crashLog = try? String(contentsOf: fileURL) {
                return crashLog
            }
        }
        
        return nil
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    @discardableResult
    public func deleteLastCrashLog() -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("crash.txt")
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
    
    /// <#Description#>
    init() {
        // Ok.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AuroraCrashHandler.shared.registerForSignals()
        }
    }
    
    /// <#Description#>
    func registerForSignals() {
        if !didRegister {
            NSSetUncaughtExceptionHandler(AuroraCrashHandler.RecieveException)
            
            for (signalCode, _) in signalCodes {
                signal(signalCode, AuroraCrashHandler.RecieveSignal)
            }
            
            didRegister = true
        }
    }
}

#endif
