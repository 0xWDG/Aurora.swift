// $$HEADER$$

import Foundation
#if canImport(UIKit)
import UIKit

extension UIApplication {
    /// Clear the cache of the launchscreen
    func clearLaunchScreenCache() {
        do {
            let cache = NSHomeDirectory() + "/Library/SplashBoard"
            try FileManager.default.removeItem(
                at: URL.init(
                    string: cache
                    )!
            )
        } catch {
            print("Failed to delete launch screen cache with error: \(error)")
        }
    }
}
#endif
