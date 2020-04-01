// $$HEADER$$

import UIKit

extension CGColor {
    public static let dinnerGreen = UIColor.dinnerGreen.cgColor
    public static let dinnerBlue = UIColor.dinnerBlue.cgColor
}

extension UIColor {
    public static let dinnerGreen = UIColor.init(
        red: 0.439216,
        green: 0.74902,
        blue: 0.254902,
        alpha: 1
    )
    
    public static let dinnerBlue = UIColor.init(
        red: 0.0117647,
        green: 0.396078,
        blue: 0.752941,
        alpha: 1
    )
    
    public static let button = UIColor.init(
        red: 0,
        green: 176/255,
        blue: 0,
        alpha: 1.0
    )
    
    public static var cellBackgroundcolor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground // .systemGray6 
        } else {
            return .white
        }
    }
    
    public class func random(randomAlpha randomApha: Bool = false) -> UIColor {
        let redValue = CGFloat.random(in: 0...255) / 255.0
        let greenValue = CGFloat.random(in: 0...255) / 255.0
        let blueValue = CGFloat.random(in: 0...255) / 255.0
        let alphaValue = randomApha ? CGFloat.random(in: 0...255) / 255.0 : 1
        
        return UIColor(
            red: redValue,
            green: greenValue,
            blue: blueValue,
            alpha: alphaValue
        )
    }
}
