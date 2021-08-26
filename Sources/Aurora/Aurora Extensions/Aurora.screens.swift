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

#if canImport(UIKit)
import Foundation
import UIKit

extension Aurora {
    /// Are we running on Carplay?
    var isCarplay: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .carPlay
        }.count >= 1
    }

    /// Are we running on a Mac?
    var isMac: Bool {
        if #available(iOS 14.0, *, tvOS 14.0, *) {
            return UIScreen.screens.filter {
                $0.traitCollection.userInterfaceIdiom == .mac
            }.count >= 1
        }

        return false
    }

    /// Are we running on a iPad?
    var isiPad: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .pad
        }.count >= 1
    }

    /// Are we running on a iPhone?
    var isiPhone: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .phone
        }.count >= 1
    }

    /// Are we running on a TV?
    var isTV: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .tv
        }.count >= 1
    }

    /// Are we running on something unspecified??
    var isUnspecified: Bool {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .unspecified
        }.count >= 1
    }

    /// Get the first (active) carPlay screen.
    var getCarplayScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .carPlay
        })
    }

    /// Get the first (active) Mac screen.
    var getMacScreen: UIScreen? {
        if #available(iOS 14.0, *, tvOS 14.0, *) {
            return UIScreen.screens.first(where: {
                $0.traitCollection.userInterfaceIdiom == .mac
            })
        }

        // Not supported (yet)
        return nil
    }

    /// Get the first (active) iPad screen.
    var getiPadScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .pad
        })
    }

    /// Get the first (active) iPhone screen.
    var getiPhoneScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .phone
        })
    }

    /// Get the first (active) TV screen.
    var getTVScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .tv
        })
    }

    /// Get the first (active) unspecified screen.
    var getScreen: UIScreen? {
        return UIScreen.screens.first(where: {
            $0.traitCollection.userInterfaceIdiom == .unspecified
        })
    }
}
#endif
