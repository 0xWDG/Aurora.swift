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

#if canImport(UIKit) && os(iOS)
import UIKit

public extension UIImageView {
    /// Sets placeholder image and then downloads an image in asynchronous way using the `URLSession`\
    /// and sets it as the current image.
    ///
    /// If the image from the URL to be retrieved is set correctly, the `success` parameter \
    /// of the completion handler block is `true`. If the function fails, the `success` parameter is `false`.
    ///
    /// - parameter url: The URL to be retrieved.
    /// - parameter placeholder: The image to be set before sending the load request. \
    /// If you pass `nil` then the current image would not be changed.
    /// - parameter completion: The completion handler to call when the load request is complete. \
    /// This handler is executed on the main queue.
    func setImage(from url: URL, placeholder placeholderImage: UIImage? = nil, completion: ((Bool) -> Void)? = nil) {
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        }
        UIImage.get(from: url) { image in
            guard let image = image else { completion?(false); return }
            self.image = image
            completion?(true)
        }
    }
}

#endif
