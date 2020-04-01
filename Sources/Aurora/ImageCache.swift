// $$HEADER$$

import Foundation



#if os(iOS)
import UIKit
let TMP: String = NSTemporaryDirectory()
    
    extension UIImage {
        //- (void) cacheImage: (NSString *) ImageURLString
        func cacheImage(_ image : String) {
            let imageURL: URL = URL(string: image)!
            let filename: String = String(describing: imageURL).md5
            let fileStore: String = TMP + filename
            
            ((try? (try? Data(contentsOf: imageURL))?.write(to: URL(fileURLWithPath: fileStore), options: [.atomic])) as ()??)
        }
        
        //- (void) resetImage: (NSString *) iURL
        func resetImage(_ image: String) {
            let imageURL:URL = URL(string: image)!
            let filename:String = String(describing: imageURL).md5
            let fileStore:String = TMP + filename
            
            do {
                try FileManager().removeItem(atPath: fileStore)
            }
            catch let e as NSError {
                print(e)
            }
            catch {
                print("error")
            }
        }
        
        //- (UIImage *) imageExists: (NSString *) ImageURLString
        func imageExists(_ image: String) -> Any {
            let imageURL:URL = URL(string: image)!
            let filename:String = String(describing: imageURL).md5
            let fileStore:String = TMP + filename
            var rimage:Any
            
            if (FileManager().fileExists(atPath: fileStore)) {
                do {
                    let fm = try FileManager().attributesOfItem(atPath: fileStore)
                    
                    let fileTime = fm[FileAttributeKey.creationDate] as? Date
                    let ourTime  = Date().addingTimeInterval(0)
                    
                    if (fileTime?.timeIntervalSince(ourTime) ?? 99999 < Double(86400)) {
                        rimage = UIImage(contentsOfFile: fileStore)!
                    } else {
                        rimage = false
                    }
                }
                catch let e as NSError {
                    print(e)
                    rimage = false
                }
                catch {
                    print("error")
                    rimage = false
                }
            } else {
                rimage = false
            }
            
            return rimage;
        }
        
        // - (UIImage *) getImage: (NSString *) ImageURLString
        func getImage(_ image: String) -> UIImage {
            let imageURL:URL = URL(string: image)!
            let filename:String = String(describing: imageURL).md5
            let fileStore:String = TMP + filename
            var rimage:UIImage = UIImage()
            
            if ((UIImage(contentsOfFile: fileStore)) != nil) {
                do {
                    let fm = try FileManager().attributesOfItem(atPath: fileStore)
                    
                    let fileTime = fm[FileAttributeKey.creationDate] as? Date
                    let ourTime  = Date().addingTimeInterval(0)
                    
                    if (fileTime?.timeIntervalSince(ourTime) ?? 99999 < Double(86400)) {
                        rimage = UIImage(contentsOfFile: fileStore)!
                    } else {
                        // Download & Cache image
                        do {
                            try FileManager().removeItem(atPath: fileStore)
                            
                            UIImage().cacheImage(image)
                            rimage = UIImage(contentsOfFile: image)!
                        }
                        catch {
                            print("Something happend, this is terrible wrong!")
                        }
                    }
                }
                catch {
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
