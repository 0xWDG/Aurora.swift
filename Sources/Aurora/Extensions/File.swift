//
//  File.swift
//  
//
//  Created by Wesley de Groot on 25/09/2020.
//

import Foundation

#if canImport(UIKit) && !os(watchOS)
import UIKit
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
#endif
