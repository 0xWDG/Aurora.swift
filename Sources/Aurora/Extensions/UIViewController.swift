// $$HEADER$$

#if os(iOS)
import UIKit

extension UIViewController {
    ///  Get class name
    public var className: String {
        return NSStringFromClass(self.classForCoder)
    }
    
    public func canPerformSegue(withIdentifier id: String) -> Bool {
        guard let segues = UIApplication.shared.delegate?.window??.rootViewController?.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return segues.first { $0.value(forKey: "identifier") as? String == id } != nil
    }
    
    /// Performs segue with passed identifier, if self can perform it.
    public func performSegueIfPossible(id: String?, sender: AnyObject? = nil) {
        guard let id = id, canPerformSegue(withIdentifier: id) else { return }
        UIApplication.shared.delegate?.window??.rootViewController?.performSegue(withIdentifier: id, sender: sender)
    }
    
    public func openSegue(name: String?, sender: AnyObject? = nil) {
        guard let name = name else {
            return
        }
        
        if !canPerformSegue(withIdentifier: name) {
            return
        }
        
        UIApplication.shared.delegate?.window??.rootViewController?.performSegue(withIdentifier: name, sender: sender)
        
    }
    
    public func showInputDialog(title: String? = nil,
                                subtitle: String? = nil,
                                actionTitle: String? = "Add",
                                cancelTitle: String? = "Cancel",
                                inputPlaceholder: String? = nil,
                                inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
#endif
