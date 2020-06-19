// $$HEADER$$

import Foundation
import CloudKit

private var WDGIiCloudSyncInProgress: Bool = false

open class WDGFrameworkiCloudSync {
    public static let shared = WDGFrameworkiCloudSync()
    private let keyValueStore = NSUbiquitousKeyValueStore.default
    private let notificationCenter = NotificationCenter.default
    
    public init () {
        if (WDGIiCloudSyncInProgress == false) {
            // Start the sync!
            self.startSync()
        }
    }
    
    open func startSync ( ) {
        if (keyValueStore.isKind(of: NSUbiquitousKeyValueStore.self)) {
            notificationCenter.addObserver(
                self,
                selector: #selector(WDGFrameworkiCloudSync.fromCloud),
                name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: nil
            )
            
            notificationCenter.addObserver(
                self,
                selector: #selector(WDGFrameworkiCloudSync.toCloud),
                name: UserDefaults.didChangeNotification,
                object: nil
            )
            
            if (keyValueStore.dictionaryRepresentation.count == 0) {
                self.toCloud()
            }
            self.fromCloud()
            
            // Say i'm syncing
            WDGIiCloudSyncInProgress = true
        } else {
            // Say i'm not syncing :'(
            WDGIiCloudSyncInProgress = false
            print("Can't start sync!")
        }
    }
    
    @objc
    private func fromCloud () {
        // iCloud to a Dictionary
        let dict: NSDictionary = keyValueStore.dictionaryRepresentation as NSDictionary
        
        // Disable ObServer temporary...
        notificationCenter.removeObserver(
            self,
            name: UserDefaults.didChangeNotification,
            object: nil
        )
        
        // Enumerate & Duplicate
        dict.enumerateKeysAndObjects(options: []) { (key, value, _) -> Void in
            guard let key: String = key as? String else { return }
            
            UserDefaults.standard.set(value, forKey: key)
        }
        
        // Sync!
        UserDefaults.standard.synchronize()
        
        // Enable ObServer
        notificationCenter.addObserver(
            self,
            selector: #selector(WDGFrameworkiCloudSync.toCloud),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
        
        // Post a super cool notification.
        notificationCenter.post(
            name: Notification.Name(rawValue: "iCloudSyncDidUpdateToLatest"),
            object: nil
        )
    }
    
    @objc
    private func toCloud() {
        //        print("Going to iCloud")
        // NSUserDefaults to a dictionary
        let dict: NSDictionary = UserDefaults.standard.dictionaryRepresentation() as NSDictionary
        
        // Disable ObServer temporary...
        notificationCenter.removeObserver(
            self,
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil
        )
        
        // Enumerate & Duplicate
        dict.enumerateKeysAndObjects { (key, value, _) -> Void in
            guard let key: String = key as? String else { return }

            keyValueStore.set(value, forKey: key as String)
        }
        
        // Sync!
        keyValueStore.synchronize()
        
        // Enable ObServer
        notificationCenter.addObserver(
            self,
            selector: #selector(WDGFrameworkiCloudSync.fromCloud),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil
        )
    }
    
    fileprivate func unset ( ) {
        // Say i'm not syncing anymore
        WDGIiCloudSyncInProgress = false
        
        // Disable ObServers
        notificationCenter.removeObserver(
            self,
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil
        )
        
        notificationCenter.removeObserver(
            self,
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
    
    open func sync() {
        // If not started (impossible, but ok)
        if (WDGIiCloudSyncInProgress == false) {
            // Just for starting.
            self.startSync()
        } else {
            // Sync!
            keyValueStore.synchronize()
        }
    }
    
    deinit {
        // Remove it all
        self.unset()
    }
}
