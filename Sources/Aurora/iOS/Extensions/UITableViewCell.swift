// $$HEADER$$

#if os(iOS)
    import UIKit

    public extension UITableViewCell {
        /// Hides the separator below the cell.
        func hideSeparator() {
            let largeIndent = CGFloat.infinity
            separatorInset = UIEdgeInsets(top: 0.0, left: largeIndent, bottom: 0.0, right: 0.0)
            indentationWidth = largeIndent * -1.0
            indentationLevel = 1
        }
    }
#endif
