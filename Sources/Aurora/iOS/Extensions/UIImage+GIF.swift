// $$HEADER$$
import UIKit
import ImageIO

// Got this from https://github.com/hasnine/iOSUtilitiesSource/blob/master/iOSUtilitiesSource/GifImageLoader.swift
extension UIImageView {
    /// <#Description#>
    /// - Parameter name: <#name description#>
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter asset: <#asset description#>
    @available(iOS 9.0, *) public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

extension UIImage {
    /// <#Description#>
    /// - Parameter data: <#data description#>
    /// - Returns: <#description#>
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    /// <#Description#>
    /// - Parameter url: <#url description#>
    /// - Returns: <#description#>
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    /// <#Description#>
    /// - Parameter name: <#name description#>
    /// - Returns: <#description#>
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    /// <#Description#>
    /// - Parameter asset: <#asset description#>
    /// - Returns: <#description#>
    @available(iOS 9.0, *) public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - index: <#index description#>
    ///   - source: <#source description#>
    /// - Returns: <#description#>
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(
            cfProperties,
            Unmanaged.passUnretained(kCGImagePropertyGIFDictionary
        ).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - valueA: <#valueA description#>
    ///   - valueB: <#valueB description#>
    /// - Returns: <#description#>
    internal class func gcdForPair(_ valueA: Int?, _ valueB: Int?) -> Int {
        var valueA = valueA
        var valueB = valueB
        // Check if one of them is nil
        if valueB == nil || valueA == nil {
            if valueB != nil {
                return valueB!
            } else if valueA != nil {
                return valueA!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if valueA! < valueB! {
            let valueC = valueA
            valueA = valueB
            valueB = valueC
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = valueA! % valueB!
            
            if rest == 0 {
                return valueB! // Found it
            } else {
                valueA = valueB
                valueB = rest
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter array: <#array description#>
    /// - Returns: <#description#>
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    /// <#Description#>
    /// - Parameter source: <#source description#>
    /// - Returns: <#description#>
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for ctr in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, ctr, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(ctr),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for ctr in 0..<count {
            frame = UIImage(cgImage: images[Int(ctr)])
            frameCount = Int(delays[Int(ctr)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(
            with: frames,
            duration: Double(duration) / 1000.0
        )
        
        return animation
    }
}
