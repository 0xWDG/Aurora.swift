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

#if canImport(MetricKit)
import MetricKit
#endif

/// Aurora Crash Handler (Metric Kit)
class AuroraCrashHandlerMK: NSObject {
    /// Shared instance
    public static let shared = AuroraCrashHandlerMK.init()

    /// Initialize
    override init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AuroraCrashHandlerMK.shared.startMonitoring()
        }
    }

    func startMonitoring() {
#if canImport(MetricKit) && !os(macOS)
        if #available(iOS 14, macOS 12.0, *) {
            MXMetricManager.shared.add(self)
        }
#endif
    }
}

#if canImport(MetricKit) && !os(macOS)
@available(iOS 13.0, macOS 12.0, *)
extension AuroraCrashHandlerMK: MXMetricManagerSubscriber {
#if os(iOS)
    func didReceive(_ payloads: [MXMetricPayload]) {
        // We don't do anything with metrics yet.
        for payload in payloads {
            Aurora.shared.log("METRIC KIT - (LEG)LOG")
            Aurora.shared.log(payload.jsonRepresentation())
        }
    }
#endif

    @available(iOS 14.0, macOS 12.0, *)
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        guard let payload = payloads.last else {
            // We only use the last payload to prevent duplicate logging as much as possible.
            return
        }

        // MXDiagnosticPayload
        Aurora.shared.log("METRIC KIT - LOG")
        Aurora.shared.log(payload.jsonRepresentation())
    }
}
#endif
