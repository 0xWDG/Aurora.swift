// $$HEADER$$

import Foundation
import Network

/// <#Description#>
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
