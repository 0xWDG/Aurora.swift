// $$HEADER$$

import Foundation

#if canImport(AppKit)
import AppKit

extension NSWindow {
    func bringToFront() {
        self.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

#endif
