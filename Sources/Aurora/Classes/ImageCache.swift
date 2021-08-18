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

import Foundation

#if os(iOS)
import UIKit

/// Temporary Directory
let TMP: String = NSTemporaryDirectory()

public extension UIImage {
    /// Get image from url
    /// - Parameter url: url
    /// - Returns: image
    func from(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return UIImage.init(data: data)
    }

    /// Cache image
    /// - Parameter image: image name
    func cacheImage(_ image: String) {
        let imageURL: URL = URL(string: image)!
        let filename: String = String(describing: imageURL).md5
        let fileStore: String = TMP + filename

        (
            (try?
                (try? Data(contentsOf: imageURL)
            )?.write(
                to: URL(fileURLWithPath: fileStore),
                options: [.atomic]
            )
        ) as ()??)
    }

    /// Reset image cache for image
    /// - Parameter image: image name
    func resetImage(_ image: String) {
        let imageURL: URL = URL(string: image)!
        let filename: String = String(describing: imageURL).md5
        let fileStore: String = TMP + filename

        do {
            try FileManager().removeItem(atPath: fileStore)
        } catch let err as NSError {
            Aurora.shared.log(err)
        } catch {
            Aurora.shared.log("error")
        }
    }

    /// Image exists?
    /// - Parameter image: Image name
    /// - Returns: Image
    func imageExists(_ image: String) -> Any {
        let imageURL: URL = URL(string: image)!
        let filename: String = String(describing: imageURL).md5
        let fileStore: String = TMP + filename
        var rimage: Any

        if FileManager().fileExists(atPath: fileStore) {
            do {
                let fMgr = try FileManager().attributesOfItem(atPath: fileStore)

                let fileTime = fMgr[FileAttributeKey.creationDate] as? Date
                let ourTime  = Date().addingTimeInterval(0)

                if fileTime?.timeIntervalSince(ourTime) ?? 99999 < Double(86400) {
                    rimage = UIImage(contentsOfFile: fileStore)!
                } else {
                    rimage = false
                }
            } catch let err as NSError {
                print(err)
                rimage = false
            } catch {
                Aurora.shared.log("error")
                rimage = false
            }
        } else {
            rimage = false
        }

        return rimage
    }

    /// Get image
    /// - Parameter image: image name
    /// - Returns: Image
    func getImage(_ image: String) -> UIImage {
        let imageURL: URL = URL(string: image)!
        let filename: String = String(describing: imageURL).md5
        let fileStore: String = TMP + filename
        var rimage: UIImage = UIImage()

        if UIImage(contentsOfFile: fileStore) != nil {
            do {
                let fMgr = try FileManager().attributesOfItem(atPath: fileStore)

                let fileTime = fMgr[FileAttributeKey.creationDate] as? Date
                let ourTime  = Date().addingTimeInterval(0)

                if fileTime?.timeIntervalSince(ourTime) ?? 99999 < Double(86400) {
                    rimage = UIImage(contentsOfFile: fileStore)!
                } else {
                    // Download & Cache image
                    do {
                        try FileManager().removeItem(atPath: fileStore)

                        UIImage().cacheImage(image)
                        rimage = UIImage(contentsOfFile: image)!
                    } catch {
                        fatalError("Something happend, this is terrible wrong!\nError: \(error)")
                    }
                }
            } catch {
                UIImage().cacheImage(image)
                rimage = UIImage(contentsOfFile: image)!
            }
        } else {
            UIImage().cacheImage(image)
            rimage = UIImage(contentsOfFile: image)!
        }

        return rimage
    }
}
#endif
