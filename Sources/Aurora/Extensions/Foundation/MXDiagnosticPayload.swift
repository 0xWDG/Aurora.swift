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
#if canImport(MetricKit) && !os(macOS)
// For whatever reason, this does fail the test on Github Actions.
// So, we just disable it for now.
import MetricKit

@available(iOS 14.0, macOS 12.0, *)
extension MXDiagnosticPayload {
    var logDescription: String {
        var logs: [String] = []
        logs.append(contentsOf: crashDiagnostics?.compactMap { $0.logDescription } ?? [])
        return logs.joined(separator: "\n")
    }

    var message: String {
            """
            ---
            MXDIAGNOSTICS RECEIVED:
            \(logDescription)
            ---
            """
    }
}

@available(iOS 14.0, macOS 12.0, *)
extension MXCrashDiagnostic {
    var logDescription: String {
        """
        Reason: \(terminationReason ?? "")
        Type: \(exceptionType?.stringValue ?? "")
        Code: \(exceptionCode?.stringValue ?? "")
        Signal: \(signal?.stringValue ?? "")
        OS: \(metaData.osVersion)
        Build: \(metaData.applicationBuildVersion)
        """
    }
}
#endif
