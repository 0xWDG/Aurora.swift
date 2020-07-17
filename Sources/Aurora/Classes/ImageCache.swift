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

import Foundation

#if os(iOS)
import UIKit

/// Temporary Directory
let TMP: String = NSTemporaryDirectory()

extension UIImage {
    /// <#Description#>
    /// - Parameter image: <#image description#>
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
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    func resetImage(_ image: String) {
        let imageURL: URL = URL(string: image)!
        let filename: String = String(describing: imageURL).md5
        let fileStore: String = TMP + filename
        
        do {
            try FileManager().removeItem(atPath: fileStore)
        } catch let err as NSError {
            print(err)
        } catch {
            print("error")
        }
    }
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    /// - Returns: <#description#>
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
                print("error")
                rimage = false
            }
        } else {
            rimage = false
        }
        
        return rimage
    }
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    /// - Returns: <#description#>
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
                        print("Something happend, this is terrible wrong!")
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
