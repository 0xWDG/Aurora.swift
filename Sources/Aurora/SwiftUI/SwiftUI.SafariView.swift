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

#if canImport(swiftUI) && canImport(SafariServices) && canImport(UIKit)
import SwiftUI
import SafariServices
import UIKit

/// Make a Safari View for SwiftUI
@available(iOS 14.0, *)
public struct SafariView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = SFSafariViewController

    @Binding var urlString: String

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        guard let url = URL(string: urlString.latinized) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close

        return safariViewController
    }

    public func updateUIViewController(
        _ safariViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
        ) {
        return
    }
}
#endif
