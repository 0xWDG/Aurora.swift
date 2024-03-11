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

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(CommonCrypto)
import CommonCrypto
#endif

#if canImport(CommonCrypto)
import CryptoKit
#endif

// swiftlint:disable file_length
public extension String {
    /// Gets the translation from the Aurora bundle
    var auroraTranslate: String {
        return NSLocalizedString(
            self,
            bundle: Bundle.module,
            comment: self
        )
    }

    /// Encode with XOR
    /// - Parameter byte: byte
    /// - Returns: XOR string
    func encodeWith(byte: UInt8) -> String {
        return String(
            bytes: self.utf8.map { $0 ^ byte },
            encoding: .utf8
        ) ?? ""
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)

        let end = index(
            startIndex,
            offsetBy: (self.count <= bounds.upperBound ? bounds.upperBound : self.count) - 1
        )

        // If self is empty, then do nothing with it.
        if self.isBlank {
            return self
        }

        return String(self[start...end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }

    /// A subscript to get the character at a specified index.
    /// - Parameter integerIndex: The index of the character that we search for.
    /// - Returns: The character found at the specified index.
    subscript(integerIndex: Int) -> Character {
        self[index(startIndex, offsetBy: integerIndex)]
    }

    /// base64 encoded of string
    var base64: String {
        let plainData = self.data(using: .utf8)
        let base64String = plainData.unwrap(
            orError: "Invalid data"
        ).base64EncodedString(options: .init(rawValue: 0))
        return base64String
    }

    /// Truncate text
    /// - Parameters:
    ///   - after: maximum length
    ///   - trailing: …
    /// - Returns: truncated string
    func truncate(after: Int, trailing: String = "…") -> String {
        return (self.count > after) ? self.prefix(after) + trailing : self
    }

#if canImport(CommonCrypto)
    /// MD5 hash of string
    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        let digestString = digest.map { String(format: "%02hhx", $0) }.joined()
        return digestString
    }
#endif

    #if os(iOS)
    /// copy string to pasteboard
    func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    #endif

    /// Extracts URLS from String
    var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }

        let text = self

        if let detector = detector {
            detector.enumerateMatches(in: text,
                                      options: [],
                                      range: NSRange(location: 0, length: text.count),
                                      using: { (result: NSTextCheckingResult?, _, _) -> Void in
                                        if let result = result, let url = result.url {
                                            urls.append(url)
                                        }
                                      })
        }

        return urls
    }

    /// Check if a string contains a text with dedicated options.
    /// - Parameters:
    ///   - text: The text to search for.
    ///   - compareOptions: The options available to many of the string classes’ search and comparison methods.
    func contains(_ text: String, compareOption: NSString.CompareOptions) -> Bool {
        self.range(of: text, options: compareOption) != nil
    }

    /// Is it an email adress
    var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

        let firstMatch = dataDetector?.firstMatch(
            in: self,
            options: NSRegularExpression.MatchingOptions.reportCompletion,
            range: NSRange(location: 0, length: count)
        )

        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    /// String as URL
    var asURL: URL? {
        URL(string: self)
    }

    /// Contains only digits?
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }

    /// JSON to Dictionary
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }

    /// JSON to Dictionary
    var asStrDict: [String: String]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String]
    }

    /// JSON to Array
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }

    #if canImport(UIKit) && !os(visionOS)
    /// Messagebox
    /// - Parameters:
    ///   - viewController: onViewcontroller?
    ///   - style: style?
    func messageBox(_ viewController: UIViewController?, style: UIAlertController.Style = .alert) {
        let alertView = UIAlertController.init(
            title: nil,
            message: self,
            preferredStyle: style
        )

        alertView.addAction(
            .init(
                title: NSLocalizedString(
                    "Aurora.general.ok",
                    bundle: Bundle.module,
                    comment: "Aurora.general.ok"
                ),
                style: .default,
                handler: { (_) in

                }
            )
        )

        // active view controller
        let activeVC = viewController ?? UIApplication.shared.key?.rootViewController
        alertView.popoverPresentationController?.sourceView = activeVC?.view
        activeVC?.present(alertView, animated: true, completion: nil)
    }
    #endif

    /// String to attributedString
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    /// Check if the string contains an IP4 address.
    var isIP4Address: Bool {
        confirmIPisValid(ip4: self)
    }

    /// Check if the string contains an IP6 address.
    var isIP6Address: Bool {
        confirmIPisValid(ip6: self)
    }

    /// Check if the string contains an IP4 or an IP6 address.
    var isIPAddress: Bool {
        confirmIPisValid(ip4: self) || confirmIPisValid(ip6: self)
    }

    /// Is it a valid IPv4 IP-Adress
    /// - Parameter ip4: IP-Address
    /// - Returns: Boolean
    private func confirmIPisValid(ip4: String) -> Bool {
        var sin = sockaddr_in()
        return ip4.withCString { cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) } == 1
    }

    /// Is it a valid IPv6 IP-Adress
    /// - Parameter ip6: IP-Address
    /// - Returns: Boolean
    private func confirmIPisValid(ip6: String) -> Bool {
        var sin6 = sockaddr_in6()
        return ip6.withCString { cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) } == 1
    }

    /// Uncamelized the string.
    var uncamelized: String {
        let upperCase = CharacterSet.uppercaseLetters
        return self.unicodeScalars.map {
            upperCase.contains($0) ? "_" + String($0).lowercased(): String($0)

        }.joined()
    }

    /// Capitalized first character of the String.
    var capitalizedFirst: String {
        let first = prefix(1).capitalized
        let other = dropFirst()
        return first + other
    }

    /// Truncate the string if it's number of character go beyong a specified limit.
    /// - Parameter limit: The number max of characters in the String.
    mutating func truncate(limit: Int) {
        self = truncated(limit: limit)
    }

    /// Truncate the string if it's number of character go beyong a specified limit.
    /// - Parameter limit: The number max of characters in the String.
    /// - Returns: The string truncated.
    func truncated(limit: Int) -> String {
        if self.count > limit {
            var truncatedString = self[0..<limit]
            truncatedString = truncatedString.appending("...")
            return truncatedString
        }
        return self
    }

    /// Split the string in several substrings of a specified size.
    /// - Parameter chunkSize: The size of each substring.
    /// - Returns: An array containing all the substrings.
    func split(intoChunksOf chunkSize: Int) -> [String] {
        var output = [String]()
        let splittedString = Array(self).split(intoChunksOf: chunkSize)
        splittedString.forEach {
            output.append($0.map { String($0) }.joined())
        }
        return output
    }

    #if canImport(UIKit)
    /// As Image
    var asImage: UIImage? {
        return self.textToImage()
    }

    /// As Image
    var emojiToImage: UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()

        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)

        (self as AnyObject).draw(
            in: rect,
            withAttributes: [
                .font: UIFont.systemFont(ofSize: 30)
            ]
        )

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    /// Text to image
    /// - Returns: IMage
    private func textToImage() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    #endif
    /// contains
    ///
    /// - Parameter str: String to check
    /// - Returns: true/false
    func contains(_ str: String) -> Bool {
        return self.range(of: str) != nil ? true: false
    }

    /// Replace
    ///
    /// - Parameter target: String
    /// - Parameter withString: Replacement
    /// - Returns: Replaced string
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(
            of: target,
            with: withString,
            options: NSString.CompareOptions.literal,
            range: nil
        )
    }

    /// Checks if string is empty or consists only of whitespace and newline characters
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }

    /// split
    /// - Parameter separator: seporator
    /// - Returns: Splitted string
    func split(_ separator: Character) -> [String] {
        return self.split {
            $0 == separator
        }.map(String.init)
    }

    /// Replace (Case Insensitive)
    ///
    /// - Parameter target: String
    /// - Parameter withString: Replacement
    /// - Returns: Replaced string
    func ireplace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(
            of: target,
            with: withString,
            options: NSString.CompareOptions.caseInsensitive,
            range: nil
        )
    }

    /// Character At Index
    ///
    /// - Parameter index: The index
    /// - Returns Character
    func characterAtIndex(_ index: Int) -> Character! {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur += 1
        }
        return nil
    }

    /// Character Code At Index
    /// - Parameter index: The index
    /// - Returns Character
    func charCodeAtindex(_ index: Int) -> Int! {
        return self.charCodeAt(index)
    }

    /// Finds the string between two bookend strings if it can be found.
    ///
    /// - parameter left:  The left bookend
    /// - parameter right: The right bookend
    ///
    /// - returns: The string between the two bookends, or nil if the bookends cannot be found,\
    /// the bookends are the same or appear contiguously.
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left),
              let rightRange = range(of: right, options: .backwards),
              left != right && leftRange.upperBound != rightRange.lowerBound
        else {
            return nil
        }

        //        return self[leftRange.upperBound...(before: rightRange.lowerBound)]
        return self

    }

    /// join
    /// - Parameter elements: Elements
    /// - Returns: Joined elements
    func join<S: Sequence>(_ elements: S) -> String {
        return elements.map {
            String(describing: $0)
        }.joined(separator: self)
    }

    /// Text lines
    var textLines: [String] {
        return split("\n")
    }

    /// Convert to `Float`
    /// - Returns: Float
    func toFloat() -> Float? {
        if let number = NumberFormatter().number(from: self) {
            return number.floatValue
        }

        return nil
    }

    /// Convert to `Int`
    /// - Returns: Int
    func toInt() -> Int? {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }

    /// Convert to `Double`
    /// - Parameter locale: Locale
    /// - Returns: Double
    func toDouble(_ locale: Locale = Locale.current) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale as Locale
        if let number = numberFormatter.number(from: self) {
            return number.doubleValue
        }
        return nil
    }

    /// Lowercased and no spaces
    var lowerAndNoSpaces: String {
        return self.lowercased().replace(" ", withString: "")
    }

#if canImport(Foundation)
    /// Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server.
    /// It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        // swiftlint:disable:next line_length
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"

        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
#endif

    /// Convert to Date
    /// - Parameter format: Dateformat
    /// - Returns: Date
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /// Convert to date & time
    /// - Parameter format: Format
    /// - Returns: Date & Time
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }

    /// Convert the number in the string to the corresponding\
    /// Unicode character
    ///
    /// e.g.
    ///
    ///     decodeNumeric("64", 10)   → "@"
    ///     decodeNumeric("20ac", 16) → "€"
    ///
    /// - Parameter string
    /// - Parameter base
    /// - Returns: Character
    fileprivate func decodeNumeric(_ string: String, base: Int32) -> Character? {
        let code = UInt32(strtoul(string, nil, base))
        return Character(UnicodeScalar(code).unwrap(orError: "Failed to get Unicode Scalar"))
    }

    /// Charcode for the character at index x
    ///
    /// - Parameter Char: the character index
    /// - Returns: charcode (int)
    func charCodeAt(_ character: Int) -> Int {
        if self.count > character {
            let character = String(self.characterAtIndex(character))
            return Int(
                String(
                    character.unicodeScalars.first.unwrap(
                        orError: "Failed to get the first unicode scalar").value
                )
            ).unwrap(orError: "Failed to convert to Int")
        } else {
            return 0
        }
    }

    /// Get character at index
    subscript (idx: Int) -> String {
        return String(self[idx] as Character)
    }

    /// Convert HTML to NSAttributedString
    /// - Returns: NSAttributedString
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }

    #if canImport(Foundation)
    /// CamelCase of string.
    ///
    ///        "sOme vAriable naMe".camelCased -> "someVariableName"
    ///
    var camelCased: String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    #endif

    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x1F1E6...0x1F1FF, // Regional country flags
                 0x2600...0x26FF, // Misc symbols
                 0x2700...0x27BF, // Dingbats
                 0xE0020...0xE007F, // Tags
                 0xFE00...0xFE0F, // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 127000...127600, // Various asian characters
                 65024...65039, // Variation selector
                 9100...9300, // Misc items
                 8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// Check if string is palindrome.
    ///
    ///     "abcdcba".isPalindrome -> true
    ///     "Mom".isPalindrome -> true
    ///     "A man a plan a canal, Panama!".isPalindrome -> true
    ///     "Mama".isPalindrome -> false
    ///
    var isPalindrome: Bool {
        let letters = filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex..<midIndex]
        let secondHalf = letters[midIndex..<letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    #if canImport(Foundation)
    /// Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid Swift number. Note: In North America, \
    /// "." is the decimal separator, while in many parts of Europe "," is used,
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal() != nil && scanner.isAtEnd
    }
    #endif

    #if canImport(Foundation)
    /// Check if string only contains digits.
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    #endif

    /// Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }

    #if canImport(Foundation)
    /// Latinized string.
    ///
    ///        "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    #endif

    #if canImport(Foundation)
    /// Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    #endif

    #if canImport(Foundation)
    /// Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".date -> Optional(Date)
    ///
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    #endif

    #if canImport(Foundation)
    /// Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///        "2007-06-29 14:23:09".dateTime -> Optional(Date)
    ///
    var dateTime: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    #endif

    /// Integer value from string (if applicable).
    ///
    ///        "101".int -> 101
    ///
    var int: Int? {
        return Int(self)
    }

    /// Lorem ipsum string of given length.
    ///
    /// - Parameter length: number of characters to limit lorem ipsum to (default is 445 - full lorem ipsum).
    /// - Returns: Lorem ipsum dolor sit amet... string.
    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        // swiftlint:disable:next line_length
        let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    #if canImport(Foundation)
    /// URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    #endif

    #if canImport(Foundation)
    /// String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".trimmed -> "hello"
    ///
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    #endif

    #if canImport(Foundation)
    /// Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    #endif

    #if canImport(Foundation)
    /// URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    #endif

    #if canImport(Foundation)
    /// String without spaces and new lines.
    ///
    ///        "   \n Aurora   .\n  Framework  ".withoutSpacesAndNewLines -> "Aurora.Framework"
    ///
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    #endif

    #if canImport(Foundation)
    /// Check if the given string contains only white spaces
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// Check if the given string spelled correctly
    var isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)

        let misspelledRange = checker.rangeOfMisspelledWord(
            in: self,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelledRange.location == NSNotFound
    }
    #endif

}

// MARK: - Methods
public extension String {
    #if canImport(Foundation)
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    #endif

    #if canImport(Foundation)
    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    #endif

    #if canImport(CoreGraphics) && canImport(Foundation)
    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    #endif

    #if canImport(Foundation)
    /// Array of strings separated by new lines.
    ///
    ///        "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns: Strings separated by new lines.
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    #endif

    #if canImport(Foundation)
    /// Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    #endif

    /// The most common character in string.
    ///
    ///        "This is a test, since e is appearing everywhere" +
    ///        " e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns: The most common character.
    func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key

        return mostCommon
    }

    /// Array with unicodes for all characters in a string.
    ///
    ///        "Aurora".unicodeArray() -> [65, 117, 114, 111, 114, 97]
    ///
    /// - Returns: The unicodes for all characters in a string.
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }

    #if canImport(Foundation)
    /// an array of all words in a string
    ///
    ///        "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    #endif

    #if canImport(Foundation)
    /// Count of words in a string.
    ///
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    #endif

    #if canImport(Foundation)
    /// First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    /// Transforms the string into a slug string.
    ///
    ///        "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: The string in slug format.
    func toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }
    #endif

    /// Safely subscript string with index.
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// Safely subscript string within a given range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Range expression.
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
              let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
            return nil
        }

        return String(self[lowerIndex..<upperIndex])
    }

    #if os(iOS) || os(macOS)
    /// Copy string to global pasteboard.
    ///
    ///        "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
    #endif

    /// Converts string format to CamelCase.
    ///
    ///        var str = "sOme vaRiabLe Name"
    ///        str.camelize()
    ///        print(str) // prints "someVariableName"
    ///
    @discardableResult
    mutating func camelize() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            self = first + rest
            return self
        }
        let rest = String(source.dropFirst())

        self = first + rest
        return self
    }

    /// First character of string uppercased(if applicable) while keeping the original string.
    ///
    ///        "hello world".firstCharacterUppercased() -> "Hello world"
    ///        "".firstCharacterUppercased() -> ""
    ///
    mutating func firstCharacterUppercased() {
        guard let first = first else { return }
        self = String(first).uppercased() + dropFirst()
    }

    /// Check if string contains only unique characters.
    ///
    func hasUniqueCharacters() -> Bool {
        guard !self.isBlank else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    #if canImport(Foundation)
    /// Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    #endif

    #if canImport(Foundation)
    /// Count of substring in string.
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    #endif

    /// Check if string ends with substring.
    ///
    ///        "Hello World!".ends(with: "!") -> true
    ///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }

    #if canImport(Foundation)
    /// Latinize string.
    ///
    ///        var str = "Hèllö Wórld!"
    ///        str.latinize()
    ///        print(str) // prints "Hello World!"
    ///
    @discardableResult
    mutating func latinize() -> String {
        self = folding(options: .diacriticInsensitive, locale: Locale.current)
        return self
    }
    #endif

    /// Random string of given length.
    ///
    ///        String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(
                base.randomElement().unwrap(orError: "Failed to get random character")
            )
        }
        return randomString
    }

    /// Reverse string.
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// Sliced string from a start index with length.
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) \
    /// (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count  else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index..<count]
        }
        guard length > 0 else { return "" }
        return self[safe: index..<index.advanced(by: length)]
    }

    /// Slice given string from a start index with length (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }

    /// Slice given string from a start index to an end index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return self }
        if let str = self[safe: start..<end] {
            self = str
        }
        return self
    }

    /// Slice given string from a start index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter index: string index the slicing should start from.
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < count else { return self }
        if let str = self[safe: index..<count] {
            self = str
        }
        return self
    }

    /// Check if string starts with substring.
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    #if canImport(Foundation)
    /// Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }
    #endif

    /// Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "…") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// Truncated string (limited to a given number of characters).
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 1..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    #if canImport(Foundation)
    /// Convert URL string to readable string.
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
        return self
    }
    #endif

    #if canImport(Foundation)
    /// Escape string.
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }
    #endif

    #if canImport(Foundation)
    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif

    /// Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padStart(10) -> "       hue"
    ///   "hue".padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        self = paddingStart(length, with: string)
        return self
    }

    /// Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        self = paddingEnd(length, with: string)
        return self
    }

    /// Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// Removes given prefix from the string.
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// Removes given suffix from the string.
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// Adds prefix to the string.
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: Prefix to add to the string.
    /// - Returns: The string with the prefix prepended.
    func withPrefix(_ prefix: String) -> String {
        // https://www.hackingwithswift.com/articles/141/8-useful-swift-extensions
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

// MARK: - Initializers
public extension String {

    #if canImport(Foundation)
    /// Create a new string from a base64 string (if applicable).
    ///
    ///        String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///        String(base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    #endif

    /// Create a new random string of given length.
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }

        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            guard let element = base.randomElement() else {
                fatalError("Cannot create a random string")
            }

            randomString.append(element)
        }
        self = randomString
    }

}

#if !os(Linux)

// MARK: - NSAttributedString
public extension String {

    #if canImport(UIKit)
    /// Font (UIFont)
    typealias Font = UIFont
    #endif

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// Font (NSFont)
    typealias Font = NSFont
    #endif

    #if os(iOS) || os(macOS)
    /// Bold string.
    var bold: NSAttributedString {
        return NSMutableAttributedString(
            string: self,
            attributes: [
                .font: Font.boldSystemFont(ofSize: Font.systemFontSize)
            ]
        )
    }
    #endif

    #if canImport(Foundation)
    /// Underlined string
    var underline: NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
    }
    #endif

    #if canImport(Foundation)
    /// Strikethrough string.
    var strikethrough: NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)
            ]
        )
    }
    #endif

    #if os(iOS)
    /// Italic string.
    var italic: NSAttributedString {
        return NSMutableAttributedString(
            string: self,
            attributes: [
                .font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
            ]
        )
    }
    #endif

    #if canImport(UIKit)
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    #endif

}

#endif

// MARK: - Operators
public extension String {

    /// Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }

}

#if canImport(Foundation)

// MARK: - NSString extensions
public extension String {

    /// NSString from a string.
    var nsString: NSString {
        return NSString(string: self)
    }

    /// NSString lastPathComponent.
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// NSString pathExtension.
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    /// NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// NSString pathComponents.
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// NSString appendingPathComponent(str: String)
    ///
    /// - Note: This method only works with file paths (not, for example, string representations of URLs.
    ///   See `NSString.appendingPathComponent(_:)`
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver\
    /// an extension separator followed by ext (if applicable).
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }

}

#endif

// Got this one from
// https://www.avanderlee.com/swift/string-interpolation/
public extension String.StringInterpolation {
    /// Prints `Optional` values by only interpolating it if the value is set.
    /// `nil` is used as a fallback value to provide a clear output.
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
        appendInterpolation(value ?? "nil" as CustomStringConvertible)
    }

    /// Pretty print an URLRequest
    /// - Parameter request: url request
    mutating func appendInterpolation(_ request: URLRequest) {
        appendInterpolation("\(request.url) | \(request.httpMethod) | Headers: \(request.allHTTPHeaderFields)")
    }

    /// Pretty print an HTMLLink
    /// - Parameter link: htmllink
    mutating func appendInterpolation(HTMLLink link: String) {
        guard let url = URL(string: link) else {
            assertionFailure("An invalid URL has been passed.")
            return
        }
        appendInterpolation("<a href=\"\(url.absoluteString)\">\(url.absoluteString)</a>")
    }

    /// Pretty print JSONData
    /// - Parameter JSONData: json data
    mutating func appendInterpolation(json JSONData: Data) {
        guard
            let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) else {
            appendInterpolation("Invalid JSON data")
            return
        }
        appendInterpolation("\n\(String(decoding: jsonData, as: UTF8.self))")
    }
}
