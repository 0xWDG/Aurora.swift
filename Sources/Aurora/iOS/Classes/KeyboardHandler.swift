// $$HEADER$$

import Foundation
#if canImport(UIKit)
import UIKit

/// Fixes the issue for screens being to small and that inputfields will be gone!
///
/// Fixes the issue for screens being to small and that inputfields will be gone!
///
/// .
///
/// **usage:**
///
///     keyboardHandler(forViewController: self)
///
/// made for views which uses autolayout.
///
/// Please note, it's a simple solution, so please don't expect micacles.
///
/// _WARNING, do not use if the input field is on the upper-part of the screen,
/// there's no protection for such things built-in._
public class KeyboardHandler {
    /// Fixes the issue for screens being to small and that inputfields will be gone!
    ///
    ///     keyboardHandler(forViewController: self)
    ///
    /// - Parameter forViewController: Viewcontroller (mostly `self`)
    @discardableResult public init(forViewController: UIViewController) {
        // Add a notification handler for 'keyboard will show'
        _ = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { (notification) in
            // force set viewcontroller frame to 0
            // (needed if a previous keyboard was smaller)
            forViewController.view.frame.origin.y = 0
            
            // get frame key
            let key = UIResponder.keyboardFrameEndUserInfoKey
            
            // Extract the keyboard size
            if let keyboardSize = (notification.userInfo?[key] as? NSValue)?.cgRectValue {
                // Check if the frame is 0
                if forViewController.view.frame.origin.y == 0 {
                    // Move the frame up
                    forViewController.view.frame.origin.y -= (
                        // Keyboard height
                        keyboardSize.height
                            // - Safe area insets (bottom)
                            - forViewController.view.safeAreaInsets.bottom
                    )
                    
                    // Ask to renew the layout (if needed)
                    forViewController.view.layoutIfNeeded()
                }
            }
        }
        
        // Add a notification handler for 'keyboard will hide'
        _ = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { (notification) in
            // get the frame
            let key = UIResponder.keyboardFrameEndUserInfoKey
            
            // Extract the keyboard size
            if let keyboardSize = (notification.userInfo?[key] as? NSValue)?.cgRectValue {
                // Check if the frame is not 0
                if forViewController.view.frame.origin.y != 0 {
                    // Move the frame down
                    forViewController.view.frame.origin.y += (
                        // Keyboard height
                        keyboardSize.height
                            // - Safe area insets (bottom)
                            - forViewController.view.safeAreaInsets.bottom
                    )
                    
                    // Ask to renew the layout (if needed)
                    forViewController.view.layoutIfNeeded()
                }
            }
        }
    }
}
#endif
