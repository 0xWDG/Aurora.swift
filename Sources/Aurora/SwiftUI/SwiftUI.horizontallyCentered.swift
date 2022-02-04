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

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.15, iOS 13, watchOS 6.0, tvOS 13.0, *)
public extension View {
    /// Horizontally centers the view by embedding it
    /// in a HStack bookended by Spacers.
    public func horizontallyCentered() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

#endif
