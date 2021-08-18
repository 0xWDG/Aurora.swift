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

#if canImport(UIKit) && !os(watchOS)
import UIKit
import ImageIO

// Got this from https://github.com/hasnine/iOSUtilitiesSource/blob/master/iOSUtilitiesSource/GifImageLoader.swift
public extension UIImageView {
    /// load GIF
    /// - Parameter name: name
    func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    /// load GIF
    /// - Parameter asset: asset name
    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}

public extension UIImage {
    /// GIF from DATA
    /// - Parameter data: GIF Data
    /// - Returns: Animated GIF
    class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            Aurora.shared.log("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    /// GIF from URL
    /// - Parameter url: GIF URL
    /// - Returns: Animated GIF
    class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            Aurora.shared.log("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            Aurora.shared.log("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    /// GIF from name
    /// - Parameter name: GIF Name
    /// - Returns: Animated GIF
    class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            Aurora.shared.log("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            Aurora.shared.log("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    /// GIF from Asset
    /// - Parameter asset: Asset name
    /// - Returns: Animated GIF
    @available(iOS 9.0, *)
    class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            Aurora.shared.log("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    /// Delay for image at index
    /// - Parameters:
    ///   - index: image index
    ///   - source: Source
    /// - Returns: Animated GIF Frames
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
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self
            )
        }

        delay = delayObject as? Double ?? 0

        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    /// greatest common divisor (GCD)
    /// - Parameters:
    ///   - valueA: Int 1
    ///   - valueB: Int 2
    /// - Returns:Greatest common divisor
    internal class func gcdForPair(_ valueA: Int?, _ valueB: Int?) -> Int {
        var valueA = valueA
        var valueB = valueB
        // Check if one of them is nil
        if valueB == nil || valueA == nil {
            if valueB != nil {
                return valueB.unwrap(orError: "Failed to unwrap")
            } else if valueA != nil {
                return valueA.unwrap(orError: "Failed to unwrap")
            } else {
                return 0
            }
        }

        guard let valueA = valueA, let valueB = valueB else {
            fatalError("Invalid values")
        }

        // Swap for modulo
        if valueA < valueB {
            let valueC = valueA
            valueA = valueB
            valueB = valueC
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = valueA % valueB

            if rest == 0 {
                return valueB // Found it
            } else {
                valueA = valueB
                valueB = rest
            }
        }
    }

    /// GDC for array
    /// - Parameter array: Ints
    /// - Returns: GDC
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    /// Animated image with source
    /// - Parameter source: source
    /// - Returns: Animated GIF Frames
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
#endif
