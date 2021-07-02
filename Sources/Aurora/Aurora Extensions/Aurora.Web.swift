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

// MARK: Imports
import Foundation

// MARK: ...
private var auroraFrameworkWebDebug: Bool = false

/// <#Description#>
open class SimpleTimer {
    typealias Tick = () -> Void
    /// <#Description#>
    var timer: Timer?
    /// <#Description#>
    var interval: TimeInterval
    /// <#Description#>
    var repeats: Bool
    /// <#Description#>
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
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    /// This method must be in the public or scope
    @objc func update() {
        tick()
    }
}

public extension Aurora {
    /// <#Description#>
    /// - Parameters:
    ///   - forURL: <#forURL description#>
    ///   - completion: <#completion description#>
    func dataTaskHelper(forURL: URL?, completion: @escaping (String) -> Void) {
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
                    let encoding = CFStringConvertEncodingToNSStringEncoding(
                        CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)
                    )
                    if encoding != UInt(kCFStringEncodingInvalidId) {
                        usedEncoding = String.Encoding(rawValue: encoding)
                    }
                }
                
                DispatchQueue.main.async {
                    if let myString = String(data: data, encoding: usedEncoding) {
                        self.log("Unwrapped and returning \(forURL?.absoluteString)")
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
    
    /// Remove all html elements from a string
    ///
    /// - Parameter html: The HTML String
    /// - Returns: the plain HTML String
    func removeHTML(_ html: String) -> String {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(
                pattern: "<.*?>",
                options: NSRegularExpression.Options.caseInsensitive
            )
            let range = NSRange(location: 0, length: html.count)
            let htmlLessString: String = regex.stringByReplacingMatches(
                in: html,
                options: [],
                range: range,
                withTemplate: ""
            )
            return htmlLessString
        } catch {
            Aurora.shared.log("Failed to parse HTML String")
            return html
        }
    }
    
    /// Newline to Break (br) [like-php]
    ///
    /// Parameter html: the string
    ///
    /// Returns: the string with `<br />` tags
    func nl2br(_ html: String) -> String {
        return html.replacingOccurrences(of: "\n", with: "<br />")
    }
    
    /// Break (br) to Newline [like-php (reversed)]
    ///
    /// - Parameter html: the html string to convert to a string
    /// - Returns: the string with line-breaks
    func br2nl(_ html: String) -> String {
        return html.replacingOccurrences(of: "<br />", with: "\n") // html 4
            .replacingOccurrences(of: "<br/>", with: "\n") // invalid html
            .replacingOccurrences(of: "<br>", with: "\n") // html <=4
        // should be regex.
        // \<(b|B)(r|R)( )?(\/)?\>
    }
    
    /// Set debug
    ///  - Parameter debugVal: Debugmode on/off
    func setDebug(_ debugVal: Bool) {
        auroraFrameworkWebDebug = debugVal
    }
}
