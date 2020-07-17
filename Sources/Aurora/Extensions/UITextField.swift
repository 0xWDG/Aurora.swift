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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

import Foundation

#if canImport(UIKit)
import UIKit

extension UITextField {
    /// <#Description#>
    @IBInspectable public var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    // swiftlint:enable implicit_getter valid_ibinspectable
    
    /// <#Description#>
    public func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar().configure {
            $0.frame = CGRect.init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 50
            )
            
            $0.barStyle = .default
        }
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    /// <#Description#>
    @objc
    func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    /// <#Description#>
    /// - Parameter icon: <#icon description#>
    public func addShowPasswordButton(with icon: String? = "👁️") {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle(icon, for: .normal)
        
        rightButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 30,
            height: 30
        )
        
        self.rightViewMode = .always
        self.rightView = rightButton
        
        rightButton.addTarget(
            self,
            action: #selector(self.showPasswordView),
            for: .touchDown
        )
        
        rightButton.addTarget(
            self,
            action: #selector(self.hidePasswordView),
            for: .touchUpInside
        )
        
        rightButton.addTarget(
            self,
            action: #selector(self.hidePasswordView),
            for: .touchDragExit
        )
    }
    
    /// <#Description#>
    @objc
    func showPasswordView() {
        isSecureTextEntry = false
        isUserInteractionEnabled = false
    }
    
    /// <#Description#>
    @objc
    func hidePasswordView() {
        isSecureTextEntry = true
        isUserInteractionEnabled = true
    }
}

#endif
