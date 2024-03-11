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

#if canImport(SwiftUI) && canImport(SafariServices) && canImport(UIKit)
import SwiftUI
import SafariServices
import UIKit

/// Make a Safari View for SwiftUI
@available(iOS 14.0, *)
public struct SafariView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = SFSafariViewController

    @Binding public var urlString: String

    public init(url: Binding<URL>) {
        _urlString = Binding(get: {
            return url.wrappedValue.absoluteString
        }, set: { _ in
            // Ignore
        })
    }

    public init(url: Binding<String>) {
        _urlString = url
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        guard let safeURL = urlString.latinized.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: safeURL) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        let safariViewController = SFSafariViewController(url: url)
        #if !os(visionOS)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close
        #endif

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
