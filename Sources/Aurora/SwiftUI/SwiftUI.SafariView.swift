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

#if canImport(swiftUI) && canImport(SafariServices)
import SwiftUI
import SafariServices
import UIKit
import Aurora

/// Make a Safari View for SwiftUI
struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    @Binding var urlString: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        guard let url = URL(string: urlString.latinized) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close

        return safariViewController
    }

    func updateUIViewController(
        _ safariViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
        ) {
        return
    }
}
#endif
