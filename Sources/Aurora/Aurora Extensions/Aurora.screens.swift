// $$HEADER$$

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
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .carPlay
        }.first
    }

    /// Get the first (active) Mac screen.
    var getMacScreen: UIScreen? {
        if #available(iOS 14.0, *, tvOS 14.0, *) {
            return UIScreen.screens.filter {
                $0.traitCollection.userInterfaceIdiom == .mac
            }.first
        }

        // Not supported (yet)
        return nil
    }

    /// Get the first (active) iPad screen.
    var getiPadScreen: UIScreen? {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .pad
        }.first
    }

    /// Get the first (active) iPhone screen.
    var getiPhoneScreen: UIScreen? {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .phone
        }.first
    }

    /// Get the first (active) TV screen.
    var getTVScreen: UIScreen? {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .tv
        }.first
    }

    /// Get the first (active) unspecified screen.
    var getScreen: UIScreen? {
        return UIScreen.screens.filter {
            $0.traitCollection.userInterfaceIdiom == .unspecified
        }.first
    }
}
#endif
