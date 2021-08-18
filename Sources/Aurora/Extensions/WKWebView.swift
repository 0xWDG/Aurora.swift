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

#if canImport(WebKit)
import Foundation
import WebKit

extension WKWebView {
func load(_ urlString: String) {
    if let url = URL(string: urlString) {
        let request = URLRequest(url: url)
        load(request)
    }
}
}
#endif
