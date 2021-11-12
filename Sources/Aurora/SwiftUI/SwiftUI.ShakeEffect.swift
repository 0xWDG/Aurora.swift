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

import Foundation
import SwiftUI

/// Shake Effect
/// From:  https://learntalks.com/FrenchKit/2019/FrenchKit-2019-Animations-with-SwiftUI-Chris-Eidhof/
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ShakeEffect: GeometryEffect {
    var position: CGFloat = 0

    public var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(
            CGAffineTransform(translationX: sin(position * 2 * .pi), y: 0)
        )
    }
}

#endif
