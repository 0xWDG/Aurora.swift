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

#if os(iOS)
#if canImport(UIKit)
import Foundation
import UIKit

public extension Aurora {
    /// Calls action when a screen shot is taken
    static func onScreenshot(_ action: @escaping () -> Void) {
        let mainQueue = OperationQueue.main
        _ = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
        object: nil,
        queue: mainQueue
        ) { _ in
            // executes after screenshot
            action()
        }
    }

    /// Is the screen currently being recorded?
    var isScreenRecording: Bool {
        return UIScreen.screens.filter { $0.isCaptured }.count >= 1
    }
}
#endif
#endif
