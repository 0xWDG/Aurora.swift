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

#if os(iOS)
import UIKit

public extension UIViewController {  
    /// Can i perform a segue?
    /// - Parameter id: segue name
    /// - Returns: boolean
    func canPerformSegue(withIdentifier: String) -> Bool {
        guard let segues = UIApplication.shared.delegate?.window??.rootViewController?.value(
            forKey: "storyboardSegueTemplates"
            ) as? [NSObject] else { return false }
        
        return segues.first {
            $0.value(forKey: "identifier") as? String == withIdentifier
            } != nil
    }
    
    /// Open/Run a segue
    /// - Parameters:
    ///   - name: Segue name
    ///   - sender: a Sender
    func performSegueIfPossible(segueID: String?, sender: AnyObject? = nil) {
        guard let segueID = segueID,
            canPerformSegue(withIdentifier: segueID) else { return }
        
        UIApplication.shared.delegate?.window??.rootViewController?.performSegue(
            withIdentifier: segueID,
            sender: sender
        )
    }
    
    /// Open/Run a segue
    /// - Parameters:
    ///   - name: Segue name
    ///   - sender: a Sender
    func openSegue(name: String?, sender: AnyObject? = nil) {
        guard let name = name else {
            return
        }
        
        if !canPerformSegue(withIdentifier: name) {
            return
        }
        
        UIApplication.shared.delegate?.window??.rootViewController?.performSegue(withIdentifier: name, sender: sender)
        
    }
    
    /// <#Description#>
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// <#Description#>
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - subtitle: <#subtitle description#>
    ///   - actionTitle: <#actionTitle description#>
    ///   - cancelTitle: <#cancelTitle description#>
    ///   - inputPlaceholder: <#inputPlaceholder description#>
    ///   - inputKeyboardType: <#inputKeyboardType description#>
    ///   - cancelHandler: <#cancelHandler description#>
    ///   - actionHandler: <#actionHandler description#>
    func showInputDialog(title: String? = nil,
                                subtitle: String? = nil,
                                actionTitle: String? = "Add",
                                cancelTitle: String? = "Cancel",
                                inputPlaceholder: String? = nil,
                                inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(
            title: title,
            message: subtitle,
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        alert.addAction(
            UIAlertAction(
                title: actionTitle,
                style: .destructive,
                handler: { (_: UIAlertAction) in
                    guard let textField =  alert.textFields?.first else {
                        actionHandler?(nil)
                        return
                    }
                    actionHandler?(textField.text)
            }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: cancelTitle,
                style: .cancel,
                handler: cancelHandler
            )
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}
#endif
