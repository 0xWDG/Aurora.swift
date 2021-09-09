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

#if !os(watchOS)
import CloudKit

extension Aurora {
    private static var isSyncInProgress: Bool = false

    /// AuroraFramework iCloudSync
    open class AuroraiCloudSync {
        /// Shared instance of `AuroraFrameworkiCloudSync`
        public static let shared = AuroraiCloudSync()
        private let keyValueStore = NSUbiquitousKeyValueStore.default
        private let notificationCenter = NotificationCenter.default

        /// Initialize
        public init() {
            if isSyncInProgress == false {
                // Start the sync!
                self.start()
            }
        }

        /// Start iCloud synchronization, and Observe changes.
        open func start() {
            if keyValueStore.isKind(of: NSUbiquitousKeyValueStore.self) {
                notificationCenter.addObserver(
                    self,
                    selector: #selector(AuroraiCloudSync.fromCloud),
                    name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                    object: nil
                )

                notificationCenter.addObserver(
                    self,
                    selector: #selector(AuroraiCloudSync.toCloud),
                    name: UserDefaults.didChangeNotification,
                    object: nil
                )

                if keyValueStore.dictionaryRepresentation.count >= 1 {
                    self.toCloud()
                }

                self.fromCloud()

                // Say i'm syncing
                isSyncInProgress = true
            } else {
                // Say i'm not syncing :'(
                isSyncInProgress = false
                Aurora.shared.log("Can't start sync!")
            }
        }

        @objc
        private func fromCloud() {
            // iCloud to a Dictionary
            let dict = keyValueStore.dictionaryRepresentation as NSDictionary

            // Disable ObServer temporary...
            notificationCenter.removeObserver(
                self,
                name: UserDefaults.didChangeNotification,
                object: nil
            )

            if !dict.allKeys.isEmpty {
                // Enumerate & Duplicate
                dict.enumerateKeysAndObjects(options: []) { (key, value, _) -> Void in
                    guard let key: String = key as? String,
                          key.length < 60 else { return }

                    UserDefaults.standard.set(value, forKey: key)
                }
            }

            // Sync!
            UserDefaults.standard.synchronize()

            // Enable ObServer
            notificationCenter.addObserver(
                self,
                selector: #selector(AuroraiCloudSync.toCloud),
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
            //        Aurora.shared.log("Going to iCloud")
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
                guard let key: String = key as? String,
                      key.length < 60 else { return }

                keyValueStore.set(value, forKey: key as String)
            }

            // Sync!
            keyValueStore.synchronize()

            // Enable ObServer
            notificationCenter.addObserver(
                self,
                selector: #selector(AuroraiCloudSync.fromCloud),
                name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: nil
            )
        }

        fileprivate func unset() {
            // Say i'm not syncing anymore
            isSyncInProgress = false

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

        /// Force a sync
        open func sync() {
            // If not started (impossible, but ok)
            if isSyncInProgress == false {
                // Just for starting.
                self.start()
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
}
#endif
