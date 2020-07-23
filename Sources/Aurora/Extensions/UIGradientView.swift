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

#if os(iOS) && canImport(UIKit)
import UIKit
import QuartzCore

@IBDesignable
public class UIGradientView: UIView {
    /// Light color: First Gradient color
    @IBInspectable public var lightFirstColor: UIColor = UIColor.init(
        red: 0.439216,
        green: 0.74902,
        blue: 0.254902,
        alpha: 1
    )
    
    /// Light color: Second Gradient color
    @IBInspectable public var lightSecondColor: UIColor = UIColor.init(
        red: 0.0117647,
        green: 0.396078,
        blue: 0.752941,
        alpha: 1
    )
    
    /// Dark mode: First Gradient color
    @IBInspectable public var darkFirstColor: UIColor = UIColor.init(
        red: 0,
        green: 204 / 255,
        blue: 68 / 255,
        alpha: 1
    )
    
    /// Dark mode: Second Gradient color
    @IBInspectable public var darkSecondColor: UIColor = UIColor.init(
        red: 0,
        green: 0,
        blue: 1,
        alpha: 1
    )
    
    /// Start point
    @IBInspectable public var startPoint: CGPoint = CGPoint(
        x: 0.0,
        y: 0.0
    )
    
    /// End point
    @IBInspectable public var endPoint: CGPoint = CGPoint(
        x: 0.5,
        y: 1.2
    )
    
    /// layer
    private var _layer: CALayer!
    
    /// Old orientation
    private var _oldOrientation = UIDevice.current.orientation
    
    /// Somethings have changed, if it is the orientation, then update
    public override func layoutSubviews() {
        if _oldOrientation != UIDevice.current.orientation {
            updateBackground(rect: frame)
        }
    }
    
    /// Draw the background
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Create our gradient layer
        let gradientLayer = CAGradientLayer()
        
        // Append the colors.
        gradientLayer.colors = [
            lightFirstColor.cgColor,
            lightSecondColor.cgColor
        ]
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                gradientLayer.colors = [
                    darkFirstColor.cgColor,
                    darkSecondColor.cgColor
                ]
            } else {
                gradientLayer.colors = [
                    lightFirstColor.cgColor,
                    lightSecondColor.cgColor
                ]
            }
        }
        
        // Define the start point
        gradientLayer.startPoint = self.startPoint
        
        // Define the end point
        gradientLayer.endPoint = self.endPoint
        
        // Define the size (full screen)
        gradientLayer.frame = self.bounds
        
        self._layer = gradientLayer
        
        // Append (on background)
        self.layer.insertSublayer(
            self._layer,
            at: 0
        )
    }
    
    /// <#Description#>
    /// - Parameter rect: <#rect description#>
    func updateBackground(rect: CGRect) {
        let oldLayer = self._layer
        self._layer = getLayer(rect: rect)
        _oldOrientation = UIDevice.current.orientation
        
        DispatchQueue.main.async {
            guard let oldLayer = oldLayer else { return }
            
            self.layer.replaceSublayer(oldLayer, with: self._layer)
            self.setNeedsLayout()
        }
    }
    
    /// Get the CA Layer
    /// - Parameter rect: Which size
    /// - Returns: CALayer (with CAGradient)
    func getLayer(rect: CGRect) -> CALayer {
        // Create our gradient layer
        let gradientLayer = CAGradientLayer()
        
        // Append the colors.
        gradientLayer.colors = [
            lightFirstColor.cgColor,
            lightSecondColor.cgColor
        ]
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                gradientLayer.colors = [
                    darkFirstColor.cgColor,
                    darkSecondColor.cgColor
                ]
            } else {
                gradientLayer.colors = [
                    lightFirstColor.cgColor,
                    lightSecondColor.cgColor
                ]
            }
        }
        
        // Define the start point
        gradientLayer.startPoint = self.startPoint
        
        // Define the end point
        gradientLayer.endPoint = self.endPoint
        
        // Define the size (full screen)
        gradientLayer.frame = self.bounds
        
        return gradientLayer
    }
    
    /// The trait collection did change
    /// - Parameter previousTraitCollection: UITraitCollection
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.updateBackground(rect: self.bounds)
        }
    }
    
}
#endif
