// $$HEADER$$

// MARK: Imports
import Foundation

// MARK: ...
private var auroraFrameworkWebDebug: Bool = false

/// <#Description#>
open class SimpleTimer {/*<--was named Timer, but since swift 3, NSTimer is now Timer*/
    typealias Tick = () -> Void
    var timer: Timer?
    var interval: TimeInterval /*in seconds*/
    var repeats: Bool
    var tick: Tick
    
    /// <#Description#>
    /// - Parameters:
    ///   - interval: <#interval description#>
    ///   - repeats: <#repeats description#>
    ///   - onTick: <#onTick description#>
    init(interval: TimeInterval, repeats: Bool = false, onTick: @escaping Tick) {
        self.interval = interval
        self.repeats = repeats
        self.tick = onTick
    }
    
    /// <#Description#>
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true
        )
    }
    
    /// <#Description#>
    func stop() {
        if (timer != nil) {
            timer!.invalidate()
        }
    }

    /**
     * This method must be in the public or scope
     */
    @objc func update() {
        tick()
    }
}

extension Aurora {
    /// <#Description#>
    /// - Parameters:
    ///   - forURL: <#forURL description#>
    ///   - completion: <#completion description#>
    open func dataTaskHelper(forURL: URL?, completion: @escaping (String) -> Void) {
        let session = URLSession.shared
        let request = URLRequest.init(
            url: forURL ?? URL.init(string: "")!,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10
        )
        
        let task = session.dataTask(
            with: request,
            completionHandler: { (data, response, _) -> Void in
            
            self.log("Got response")
            
            guard let data = data else {
                self.log("Failed to decode data")
                completion("Error")
                return
            }
            
            var usedEncoding = String.Encoding.utf8 // Some fallback value
            if let encodingName = response?.textEncodingName {
                let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString))
                if encoding != UInt(kCFStringEncodingInvalidId) {
                    usedEncoding = String.Encoding(rawValue: encoding)
                }
            }
            
            DispatchQueue.main.async {
                if let myString = String(data: data, encoding: usedEncoding) {
                    self.log("Unwrapped and returning")
                    completion(myString)
                } else {
                    self.log("Failed to use the proper encoding")
                    // ... Error
                    completion("Error")
                }
            }
        })
        task.resume()
    }
    
    /// <#Description#>
    /// - Parameter url: <#url description#>
    /// - Returns: <#description#>
    open func getSiteAsText(url: URL) -> String {
        log("getSiteAsText init(url: \"\(url)\")")
        var returnString: String = ""

        self.dataTaskHelper(forURL: url) { (dataTaskString) in
            self.log("Return: \(dataTaskString)")
            returnString = dataTaskString
        }

//        while(returnString==""){}
        
        log("After the datatask = \(returnString)")

//        if (returnString != "Error") {
//            return returnString
//        } else {
            do {
                let myHTMLString = try NSString(
                    contentsOf: url,
                    encoding: String.Encoding.utf8.rawValue
                )
                
                return myHTMLString as String
            } catch _ {
                do {
                    let myHTMLString = try NSString(
                        contentsOf: url,
                        encoding: String.Encoding.utf16.rawValue
                    )
                    
                    return myHTMLString as String
                } catch _ {
                    do {
                        let myHTMLString = try NSString(
                            contentsOf: url,
                            encoding: String.Encoding.isoLatin1.rawValue
                        )
                        
                        return myHTMLString as String
                    } catch _ {
                        do {
                            let myHTMLString = try NSString(
                                contentsOf: url,
                                encoding: String.Encoding.isoLatin2.rawValue
                            )
                            
                            return myHTMLString as String
                        } catch {
                            do {
                                let myHTMLString = try NSString(
                                    contentsOf: url,
                                    encoding: String.Encoding.utf32.rawValue
                                )
                                
                                return myHTMLString as String
                            } catch let error {
                                if (returnString != "") {
                                    return returnString
                                }
                                
                                return "Decoding Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }
            }
//        }
    }
    /**
     Get data as (plain) text
     
     - Parameter url: the URL of the file
     
     - Returns: the contents of the file
     */
    open func getDataAsText(_ url: String, _ post: Dictionary<String, String>? = ["nothing": "send"]) -> String {
        log("Init.")
        if let myURL = URL(string: url) {
            if (post == ["nothing": "send"]) {
                log("get site as text")
                return getSiteAsText(url: myURL)
            } else {
                var waiting = true
                var data = ""
                var request = URLRequest(url: myURL)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded",
                                 forHTTPHeaderField: "Content-Type")
                
                var httpBody = ""
                var idx = 0
                for (key, val) in post! {
                    if (idx == 0) {
                        httpBody.append(contentsOf:
                            "\(key)=\(val.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
                    } else {
                        httpBody.append(contentsOf:
                            "&\(key)=\(val.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
                    }
                    idx += 1
                }
                request.httpBody = httpBody.data(using: .utf8)
                
                let session = URLSession.shared
                session.dataTask(with: request) { (sitedata, _, _) in
                    if let sitedata = sitedata {
                        data = String(data: sitedata, encoding: .utf8)!
                        waiting = false
                    } else {
                        data = "Error"
                        waiting = false
                    }
                    
                    }.resume()
                
                while (waiting) {
                 print("Waiting...")
                }
                
                return data
            }
        } else {
            return "Error: \(url) doesn't appear to be a URL"
        }
    }
    
    /**
     Get data as Data
     
     - Parameter url: the URL of the file
     
     - Returns: the contents of the file
     */
    open func getDataAsData(_ url: String, _ post: Dictionary<String, String>? = ["nothing": "send"]) -> Data {
        if let myURL = URL(string: url) {
            var error: NSError?
            
            if (String(describing: error) == "fuckswifterrors") {
                error = NSError(
                    domain: "this",
                    code: 89,
                    userInfo: ["n": "o", "n": "e"]
                )
            }
            
            if (post == ["nothing": "send"]) {
                return getSiteAsText(url: myURL).data(using: .utf8)!
            } else {
                var waiting = true
                var data = "".data(using: .utf8)
                var request = URLRequest(url: myURL)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded",
                                 forHTTPHeaderField: "Content-Type")
                
                var httpBody = ""
                var idx = 0
                for (key, val) in post! {
                    if (idx == 0) {
                        httpBody.append(contentsOf:
                            "\(key)=\(val.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
                    } else {
                        httpBody.append(contentsOf:
                            "&\(key)=\(val.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
                    }
                    idx += 1
                }
                request.httpBody = httpBody.data(using: .utf8)
                
                let session = URLSession.shared
                session.dataTask(with: request) { (sitedata, _, _) in
                    if let sitedata = sitedata {
                        data = sitedata
                        waiting = false
                    } else {
                        data = "Error".data(using: .utf8)
                        waiting = false
                    }
                    
                    }.resume()
                
                while (waiting) {
                    //                    print("Waiting...")
                }
                
                return data!
            }
        } else {
            return "Error: \(url) doesn't  URL".data(using: String.Encoding.utf8)!
        }
    }
    
    /**
     Remove all html elements from a string
     
     - Parameter html: The HTML String
     
     - Returns: the plain HTML String
     */
    open func removeHTML(_ html: String) -> String {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "<.*?>", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSRange(location: 0, length: html.count)
            let htmlLessString: String = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
            return htmlLessString
        } catch {
            print("Failed to parse HTML String")
            return html
        }
    }
    
    /**
     Newline to Break (br) [like-php]
     
     - Parameter html: the string
     
     - Returns: the string with <br /> tags
     */
    open func nl2br(_ html: String) -> String {
        return html.replacingOccurrences(of: "\n", with: "<br />")
    }
    
    /**
     Break (br) to Newline [like-php (reversed)]
     
     - Parameter html: the html string to convert to a string
     
     - Returns: the string with line-breaks
     */
    open func br2nl(_ html: String) -> String {
        return html.replacingOccurrences(of: "<br />", with: "\n") // html 4
            .replacingOccurrences(of: "<br/>", with: "\n") // invalid html
            .replacingOccurrences(of: "<br>", with: "\n") // html <=4
        // should be regex.
        // \<(b|B)(r|R)( )?(\/)?\>
    }
    
    /**
     Set debug
     
     - Parameter debugVal: Debugmode on/off
     */
    open func setDebug(_ debugVal: Bool) {
        auroraFrameworkWebDebug = debugVal
    }
}
