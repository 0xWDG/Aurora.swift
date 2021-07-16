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
import Network

/// Network status (monitor)
@available(tvOS 12.0, *)
public class NetworkStatus {
    
    // MARK: - Properties
    
    /// Shared instance of NetworkStatus
    public static let shared = NetworkStatus()
    
    /// Initialize our network monitor
    var monitor: NWPathMonitor?
    
    /// Are we monitoring
    var isMonitoring = false
    
    /// Completion handler to execute after we start monitoring
    public var didStartMonitoringHandler: (() -> Void)?
    
    /// Completion handler to execute after we stop monitoring
    public var didStopMonitoringHandler: (() -> Void)?
    
    /// Completion handler to execute after the network status changes
    public var netStatusChangeHandler: (() -> Void)?
    
    /// Are we connected to the internet?
    public var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    /// Which interface type is available
    public var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type)
        }.first?.type
    }
    
    /// Which interface types are available
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    /// isExpensive (on mobile internet)
    public var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    // MARK: - Init & Deinit
    
    /// Initialize
    private init() {
        startMonitoring()
    }
    
    /// Deinitialize
    deinit {
        stopMonitoring()
    }
    
    // MARK: - Method Implementation
    /// Start monitoring
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    /// Stop monitoring
    public func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
