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

import Foundation

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITextField {
    #if !os(tvOS)
    /// done accessory
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        // swiftlint:disable:next unused_setter_value
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }

    /// add "Done" button on keyboard
    func addDoneButtonOnKeyboard() {
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
            title: NSLocalizedString("Done", comment: "Done"),
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    /// Done button actio (resign)
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    #endif

    /// Add show password button
    /// - Parameter icon: 👁️
    func addShowPasswordButton(with icon: String? = "👁️") {
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

    /// show password
    @objc func showPasswordView() {
        isSecureTextEntry = false
        isUserInteractionEnabled = false
    }

    /// hide password
    @objc func hidePasswordView() {
        isSecureTextEntry = true
        isUserInteractionEnabled = true
    }

    /// Add a custom clear button to the textfield.
    /// - Parameter image: The image representing the clear button.
    func setClearButton(with image: UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(origin: .zero, size: CGSize(width: self.height, height: self.height))
        clearButton.contentMode = .right
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButtonMode = .never

        rightView = clearButton
        rightViewMode = .whileEditing
    }

    /// Clear text
    @objc func clear() {
        text = ""
        sendActions(for: .editingChanged)
    }

    /// Change the textfield's placeholder color.
    /// - Parameter color: The new placeholder's color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let placeholder = placeholder, !placeholder.isEmpty else {
            return
        }
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: attributes)
    }

    /// Set a dynamic font to the label.
    /// - Parameters:
    ///   - style: The UIFont.TextStyle that will set to the label.
    ///   - traits: Optional symbolic traits applied to the font. Default value is nil.
    ///   - adjustToFit: A Boolean value indicating whether the font size should be reduced
    ///                  in order to fit the text string into the text field’s bounding rectangle.
    @available(iOS 11.0, tvOS 11.0, *)
    func configureDynamicStyle(_ style: UIFont.TextStyle,
                               traits: UIFontDescriptor.SymbolicTraits? = nil,
                               adjustToFit: Bool = true) {
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = adjustToFit
    }
}
#endif
