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

/// <#Description#>
@available(tvOS 12.0, *)
public class NetworkStatus {
    
    // MARK: - Properties
    
    /// <#Description#>
    public static let shared = NetworkStatus()
    
    /// <#Description#>
    var monitor: NWPathMonitor?
    
    /// <#Description#>
    var isMonitoring = false
    
    /// <#Description#>
    public var didStartMonitoringHandler: (() -> Void)?
    
    /// <#Description#>
    public var didStopMonitoringHandler: (() -> Void)?
    
    /// <#Description#>
    public var netStatusChangeHandler: (() -> Void)?
    
    /// <#Description#>
    public var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    /// <#Description#>
    public var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type)
        }.first?.type
    }
    
    /// <#Description#>
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    /// <#Description#>
    public var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    // MARK: - Init & Deinit
    
    /// <#Description#>
    private init() {
        startMonitoring()
    }
    
    /// <#Description#>
    deinit {
        stopMonitoring()
    }
    
    // MARK: - Method Implementation
    /// <#Description#>
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
    
    /// <#Description#>
    public func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
