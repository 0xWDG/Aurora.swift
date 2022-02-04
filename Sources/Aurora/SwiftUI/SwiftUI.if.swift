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
    /// Conditionally applies a modifier to a view.
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }

    /// Conditionally applies a modifier to a view.
    func `if`<Content: View>(
        _ condition: Bool,
        _ content1: (Self) -> Content,
        else content2: (Self) -> Content) -> some View {
        if condition {
            return AnyView(content1(self))
        } else {
            return AnyView(content2(self))
        }
    }
}
#endif
