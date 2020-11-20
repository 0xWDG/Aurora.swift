//
//  File 2.swift
//  
//
//  Created by Wesley de Groot on 20/11/2020.
//

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
