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

// MARK: Imports
import Foundation

// MARK: ...
private var auroraFrameworkWebDebug: Bool = false

public extension Aurora {
    /// Datatask helper (DEPRECATED)
    /// - Parameters:
    ///   - forURL: for URL
    ///   - completion: Completion
    @available(*, deprecated)
    func dataTaskHelper(forURL: URL?, completion: @escaping (String) -> Void) {
        let session = URLSession.shared

        let request = URLRequest.init(
            url: forURL ?? URL.init(string: "").unwrap(orError: "No URL"),
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
