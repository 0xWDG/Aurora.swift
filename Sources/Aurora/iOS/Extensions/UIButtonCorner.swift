// $$HEADER$$

#if canImport(UIKit)
import UIKit

@IBDesignable extension UIButton {
    /// <#Description#>
    @IBInspectable public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    /// <#Description#>
    @IBInspectable public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    /// <#Description#>
    @IBInspectable public var borderColor: UIColor? {
        set {
            guard newValue != nil else { return }
            layer.borderColor = .dinnerGreen
        }
        get {
            guard layer.borderColor != nil else { return nil }
            if #available(iOS 13.0, *) {
                return .systemBackground
            } else {
                return .white
            }
        }
    }
    // swiftlint:enable valid_ibinspectable implicit_getter
    
    /// <#Description#>
    override public var isHighlighted: Bool {
        didSet {
            guard let currentBorderColor = borderColor else {
                return
            }
            
            let fadedColor = currentBorderColor.withAlphaComponent(0.2).cgColor
            
            if isHighlighted {
                layer.borderColor = fadedColor
            } else {
                
                self.layer.borderColor = currentBorderColor.cgColor
                
                let animation = CABasicAnimation(keyPath: "borderColor")
                animation.fromValue = fadedColor
                animation.toValue = currentBorderColor.cgColor
                animation.duration = 0.4
                self.layer.add(animation, forKey: "")
            }
        }
    }
}

#endif
