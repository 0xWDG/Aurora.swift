// $$HEADER$$
// swiftlint:disable file_length

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

/**
 Extensions for Strings
 */
public extension String {
    /// <#Description#>
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    /// <#Description#>
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    /// <#Description#>
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    /// <#Description#>
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    /// <#Description#>
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
    
    /// base64 encoded of string
    var base64: String {
        let plainData = self.data(using: .utf8)
        let base64String = plainData!.base64EncodedString(options: .init(rawValue: 0))
        return base64String
    }
    
    /// MD5 hash of string
    var md5: String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }
        
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Lowercased and no spaces
    var lowerAndNoSpaces: String {
        return self.lowercased.replace(" ", withString: "")
    }
    
    /// Checks if string is empty or consists only of whitespace and newline characters
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// Trims white space and new line characters
    mutating func trim() {
        self = self.trimmed
    }
    
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
    
    /// Checking if String contains input with comparing options
    func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    /// <#Description#>
    var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let firstMatch = dataDetector?.firstMatch(
            in: self,
            options: NSRegularExpression.MatchingOptions.reportCompletion,
            range: NSRange(location: 0, length: length)
        )
        
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /// <#Description#>
    fileprivate struct HTMLEntities {
        static let characterEntities: [String: Character] = [
            
            // XML predefined entities:
            "&amp;": "&",
            "&quot;": "\"",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            
            // HTML character entity references:
            "&nbsp;": "\u{00A0}",
            "&iexcl;": "\u{00A1}",
            "&cent;": "\u{00A2}",
            "&pound;": "\u{00A3}",
            "&curren;": "\u{00A4}",
            "&yen;": "\u{00A5}",
            "&brvbar;": "\u{00A6}",
            "&sect;": "\u{00A7}",
            "&uml;": "\u{00A8}",
            "&copy;": "\u{00A9}",
            "&ordf;": "\u{00AA}",
            "&laquo;": "\u{00AB}",
            "&not;": "\u{00AC}",
            "&shy;": "\u{00AD}",
            "&reg;": "\u{00AE}",
            "&macr;": "\u{00AF}",
            "&deg;": "\u{00B0}",
            "&plusmn;": "\u{00B1}",
            "&sup2;": "\u{00B2}",
            "&sup3;": "\u{00B3}",
            "&acute;": "\u{00B4}",
            "&micro;": "\u{00B5}",
            "&para;": "\u{00B6}",
            "&middot;": "\u{00B7}",
            "&cedil;": "\u{00B8}",
            "&sup1;": "\u{00B9}",
            "&ordm;": "\u{00BA}",
            "&raquo;": "\u{00BB}",
            "&frac14;": "\u{00BC}",
            "&frac12;": "\u{00BD}",
            "&frac34;": "\u{00BE}",
            "&iquest;": "\u{00BF}",
            "&Agrave;": "\u{00C0}",
            "&Aacute;": "\u{00C1}",
            "&Acirc;": "\u{00C2}",
            "&Atilde;": "\u{00C3}",
            "&Auml;": "\u{00C4}",
            "&Aring;": "\u{00C5}",
            "&AElig;": "\u{00C6}",
            "&Ccedil;": "\u{00C7}",
            "&Egrave;": "\u{00C8}",
            "&Eacute;": "\u{00C9}",
            "&Ecirc;": "\u{00CA}",
            "&Euml;": "\u{00CB}",
            "&Igrave;": "\u{00CC}",
            "&Iacute;": "\u{00CD}",
            "&Icirc;": "\u{00CE}",
            "&Iuml;": "\u{00CF}",
            "&ETH;": "\u{00D0}",
            "&Ntilde;": "\u{00D1}",
            "&Ograve;": "\u{00D2}",
            "&Oacute;": "\u{00D3}",
            "&Ocirc;": "\u{00D4}",
            "&Otilde;": "\u{00D5}",
            "&Ouml;": "\u{00D6}",
            "&times;": "\u{00D7}",
            "&Oslash;": "\u{00D8}",
            "&Ugrave;": "\u{00D9}",
            "&Uacute;": "\u{00DA}",
            "&Ucirc;": "\u{00DB}",
            "&Uuml;": "\u{00DC}",
            "&Yacute;": "\u{00DD}",
            "&THORN;": "\u{00DE}",
            "&szlig;": "\u{00DF}",
            "&agrave;": "\u{00E0}",
            "&aacute;": "\u{00E1}",
            "&acirc;": "\u{00E2}",
            "&atilde;": "\u{00E3}",
            "&auml;": "\u{00E4}",
            "&aring;": "\u{00E5}",
            "&aelig;": "\u{00E6}",
            "&ccedil;": "\u{00E7}",
            "&egrave;": "\u{00E8}",
            "&eacute;": "\u{00E9}",
            "&ecirc;": "\u{00EA}",
            "&euml;": "\u{00EB}",
            "&igrave;": "\u{00EC}",
            "&iacute;": "\u{00ED}",
            "&icirc;": "\u{00EE}",
            "&iuml;": "\u{00EF}",
            "&eth;": "\u{00F0}",
            "&ntilde;": "\u{00F1}",
            "&ograve;": "\u{00F2}",
            "&oacute;": "\u{00F3}",
            "&ocirc;": "\u{00F4}",
            "&otilde;": "\u{00F5}",
            "&ouml;": "\u{00F6}",
            "&divide;": "\u{00F7}",
            "&oslash;": "\u{00F8}",
            "&ugrave;": "\u{00F9}",
            "&uacute;": "\u{00FA}",
            "&ucirc;": "\u{00FB}",
            "&uuml;": "\u{00FC}",
            "&yacute;": "\u{00FD}",
            "&thorn;": "\u{00FE}",
            "&yuml;": "\u{00FF}",
            "&OElig;": "\u{0152}",
            "&oelig;": "\u{0153}",
            "&Scaron;": "\u{0160}",
            "&scaron;": "\u{0161}",
            "&Yuml;": "\u{0178}",
            "&fnof;": "\u{0192}",
            "&circ;": "\u{02C6}",
            "&tilde;": "\u{02DC}",
            "&Alpha;": "\u{0391}",
            "&Beta;": "\u{0392}",
            "&Gamma;": "\u{0393}",
            "&Delta;": "\u{0394}",
            "&Epsilon;": "\u{0395}",
            "&Zeta;": "\u{0396}",
            "&Eta;": "\u{0397}",
            "&Theta;": "\u{0398}",
            "&Iota;": "\u{0399}",
            "&Kappa;": "\u{039A}",
            "&Lambda;": "\u{039B}",
            "&Mu;": "\u{039C}",
            "&Nu;": "\u{039D}",
            "&Xi;": "\u{039E}",
            "&Omicron;": "\u{039F}",
            "&Pi;": "\u{03A0}",
            "&Rho;": "\u{03A1}",
            "&Sigma;": "\u{03A3}",
            "&Tau;": "\u{03A4}",
            "&Upsilon;": "\u{03A5}",
            "&Phi;": "\u{03A6}",
            "&Chi;": "\u{03A7}",
            "&Psi;": "\u{03A8}",
            "&Omega;": "\u{03A9}",
            "&alpha;": "\u{03B1}",
            "&beta;": "\u{03B2}",
            "&gamma;": "\u{03B3}",
            "&delta;": "\u{03B4}",
            "&epsilon;": "\u{03B5}",
            "&zeta;": "\u{03B6}",
            "&eta;": "\u{03B7}",
            "&theta;": "\u{03B8}",
            "&iota;": "\u{03B9}",
            "&kappa;": "\u{03BA}",
            "&lambda;": "\u{03BB}",
            "&mu;": "\u{03BC}",
            "&nu;": "\u{03BD}",
            "&xi;": "\u{03BE}",
            "&omicron;": "\u{03BF}",
            "&pi;": "\u{03C0}",
            "&rho;": "\u{03C1}",
            "&sigmaf;": "\u{03C2}",
            "&sigma;": "\u{03C3}",
            "&tau;": "\u{03C4}",
            "&upsilon;": "\u{03C5}",
            "&phi;": "\u{03C6}",
            "&chi;": "\u{03C7}",
            "&psi;": "\u{03C8}",
            "&omega;": "\u{03C9}",
            "&thetasym;": "\u{03D1}",
            "&upsih;": "\u{03D2}",
            "&piv;": "\u{03D6}",
            "&ensp;": "\u{2002}",
            "&emsp;": "\u{2003}",
            "&thinsp;": "\u{2009}",
            "&zwnj;": "\u{200C}",
            "&zwj;": "\u{200D}",
            "&lrm;": "\u{200E}",
            "&rlm;": "\u{200F}",
            "&ndash;": "\u{2013}",
            "&mdash;": "\u{2014}",
            "&lsquo;": "\u{2018}",
            "&rsquo;": "\u{2019}",
            "&sbquo;": "\u{201A}",
            "&ldquo;": "\u{201C}",
            "&rdquo;": "\u{201D}",
            "&bdquo;": "\u{201E}",
            "&dagger;": "\u{2020}",
            "&Dagger;": "\u{2021}",
            "&bull;": "\u{2022}",
            "&hellip;": "\u{2026}",
            "&permil;": "\u{2030}",
            "&prime;": "\u{2032}",
            "&Prime;": "\u{2033}",
            "&lsaquo;": "\u{2039}",
            "&rsaquo;": "\u{203A}",
            "&oline;": "\u{203E}",
            "&frasl;": "\u{2044}",
            "&euro;": "\u{20AC}",
            "&image;": "\u{2111}",
            "&weierp;": "\u{2118}",
            "&real;": "\u{211C}",
            "&trade;": "\u{2122}",
            "&alefsym;": "\u{2135}",
            "&larr;": "\u{2190}",
            "&uarr;": "\u{2191}",
            "&rarr;": "\u{2192}",
            "&darr;": "\u{2193}",
            "&harr;": "\u{2194}",
            "&crarr;": "\u{21B5}",
            "&lArr;": "\u{21D0}",
            "&uArr;": "\u{21D1}",
            "&rArr;": "\u{21D2}",
            "&dArr;": "\u{21D3}",
            "&hArr;": "\u{21D4}",
            "&forall;": "\u{2200}",
            "&part;": "\u{2202}",
            "&exist;": "\u{2203}",
            "&empty;": "\u{2205}",
            "&nabla;": "\u{2207}",
            "&isin;": "\u{2208}",
            "&notin;": "\u{2209}",
            "&ni;": "\u{220B}",
            "&prod;": "\u{220F}",
            "&sum;": "\u{2211}",
            "&minus;": "\u{2212}",
            "&lowast;": "\u{2217}",
            "&radic;": "\u{221A}",
            "&prop;": "\u{221D}",
            "&infin;": "\u{221E}",
            "&ang;": "\u{2220}",
            "&and;": "\u{2227}",
            "&or;": "\u{2228}",
            "&cap;": "\u{2229}",
            "&cup;": "\u{222A}",
            "&int;": "\u{222B}",
            "&there4;": "\u{2234}",
            "&sim;": "\u{223C}",
            "&cong;": "\u{2245}",
            "&asymp;": "\u{2248}",
            "&ne;": "\u{2260}",
            "&equiv;": "\u{2261}",
            "&le;": "\u{2264}",
            "&ge;": "\u{2265}",
            "&sub;": "\u{2282}",
            "&sup;": "\u{2283}",
            "&nsub;": "\u{2284}",
            "&sube;": "\u{2286}",
            "&supe;": "\u{2287}",
            "&oplus;": "\u{2295}",
            "&otimes;": "\u{2297}",
            "&perp;": "\u{22A5}",
            "&sdot;": "\u{22C5}",
            "&lceil;": "\u{2308}",
            "&rceil;": "\u{2309}",
            "&lfloor;": "\u{230A}",
            "&rfloor;": "\u{230B}",
            "&lang;": "\u{2329}",
            "&rang;": "\u{232A}",
            "&loz;": "\u{25CA}",
            "&spades;": "\u{2660}",
            "&clubs;": "\u{2663}",
            "&hearts;": "\u{2665}",
            "&diams;": "\u{2666}"
        ]
    }
    
    /**
     get lowercased string
     */
    var lowercased: String {
        return self.lowercased()
    }
    
    /**
     get string length
     */
    var length: Int {
        return self.count
    }
    
    /**
     contains
     
     - Parameter str: String to check
     
     - Returns: true/false
     */
    func contains(_ str: String) -> Bool {
        return self.range(of: str) != nil ? true: false
    }
    
    /**
     Replace
     
     - Parameter target: String
     - Parameter withString: Replacement
     
     - Returns: Replaced string
     */
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
     Replace (Case Insensitive)
     
     - Parameter target: String
     - Parameter withString: Replacement
     
     - Returns: Replaced string
     */
    func ireplace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.caseInsensitive, range: nil)
    }
    
    /**
     Character At Index
     
     - Parameter index: The index
     
     - Returns Character
     */
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
    
    /**
     Character Code At Index
     
     - Parameter index: The index
     
     - Returns Character
     */
    func charCodeAtindex(_ index: Int) -> Int! {
        return self.charCodeAt(index)
    }
    
    /**
     add subscript
     
     - Parameter idx: The index
     
     - Returns: The ranged string
     */
    subscript(idx: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: idx)
        return self[index]
    }
    
    /**
     Finds the string between two bookend strings if it can be found.
     
     - parameter left:  The left bookend
     - parameter right: The right bookend
     
     - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
     */
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
    
    /// <#Description#>
    /// - Returns: <#description#>
    func capitalize() -> String {
        return self.capitalized
    }
    
    /// <#Description#>
    /// - Parameter prefix: <#prefix description#>
    /// - Returns: <#description#>
    func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return String(self[startIndex..<prefixRange.lowerBound])
            } else {
                return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    /// <#Description#>
    /// - Parameter suffix: <#suffix description#>
    /// - Returns: <#description#>
    func chompRight(_ suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return String(self[startIndex..<suffixRange.lowerBound])
            } else {
                return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter {!$0.isEmpty}
        return components.joined(separator: " ")
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - with: <#with description#>
    ///   - allOf: <#allOf description#>
    /// - Returns: <#description#>
    func clean(_ with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    /// <#Description#>
    /// - Parameter substring: <#substring description#>
    /// - Returns: <#description#>
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// <#Description#>
    /// - Parameter suffix: <#suffix description#>
    /// - Returns: <#description#>
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    /// <#Description#>
    /// - Parameter prefix: <#prefix description#>
    /// - Returns: <#description#>
    func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    /// <#Description#>
    /// - Parameter suffix: <#suffix description#>
    /// - Returns: <#description#>
    func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    /// <#Description#>
    /// - Parameter substring: <#substring description#>
    /// - Returns: <#description#>
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func initials() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce("") {$0 + $1[0...0]}
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func initialsFirstAndLast() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce("") {($0 == "" ? "": $0[0...0]) + $1[0...0]}
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func isAlpha() -> Bool {
        for chr in self {
            if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") {
                return false
            }
        }
        return true
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").length == 0
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func isEmpty() -> Bool {
        let nonWhitespaceSet = CharacterSet.whitespacesAndNewlines
        return components(separatedBy: nonWhitespaceSet).joined(separator: "").length != 0
    }
    
    /// <#Description#>
    /// - Parameter elements: <#elements description#>
    /// - Returns: <#description#>
    func join<S: Sequence>(_ elements: S) -> String {
        return elements.map {String(describing: $0)}.joined(separator: self)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - num: <#num description#>
    ///   - string: <#string description#>
    /// - Returns: <#description#>
    func pad(_ num: Int, _ string: String = " ") -> String {
        return "".join([string.times(num), self, string.times(num)])
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - num: <#num description#>
    ///   - string: <#string description#>
    /// - Returns: <#description#>
    func padLeft(_ num: Int, _ string: String = " ") -> String {
        return "".join([string.times(num), self])
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - num: <#num description#>
    ///   - string: <#string description#>
    /// - Returns: <#description#>
    func padRight(_ num: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(num)])
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    mutating func slugify() -> String {
        let slugCharacterSet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
        return latinize().lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter {$0 != ""}
            .joined(separator: "-")
    }
    
    /// <#Description#>
    /// - Parameter separator: <#separator description#>
    /// - Returns: <#description#>
    func split(_ separator: Character) -> [String] {
        return self.split {$0 == separator}.map(String.init)
    }
    
    /// <#Description#>
    var textLines: [String] {
        return split("\n")
    }
    
    /// <#Description#>
    /// - Parameter prefix: <#prefix description#>
    /// - Returns: <#description#>
    func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func stripPunctuation() -> String {
        return components(separatedBy: .punctuationCharacters)
            .joined(separator: "")
            .components(separatedBy: " ")
            .filter {$0 != ""}
            .joined(separator: " ")
    }
    
    /// <#Description#>
    /// - Parameter num: <#num description#>
    /// - Returns: <#description#>
    func times(_ num: Int) -> String {
        var returnString = ""
        for _ in stride(from: 0, to: num, by: 1) {
            returnString += self
        }
        return returnString
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func toFloat() -> Float? {
        if let number = NumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func toInt() -> Int? {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    /// <#Description#>
    /// - Parameter locale: <#locale description#>
    /// - Returns: <#description#>
    func toDouble(_ locale: Locale = Locale.current) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale as Locale
        if let number = numberFormatter.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
    
    /**
     Convert anything to bool...
     
     - Returns: Bool
     */
    func toBool() -> Bool? {
        let trimmed = self.trimmed.lowercased
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    /// <#Description#>
    /// - Parameter format: <#format description#>
    /// - Returns: <#description#>
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    /// <#Description#>
    /// - Parameter format: <#format description#>
    /// - Returns: <#description#>
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    /**
     Convert the number in the string to the corresponding\
     Unicode character, e.g.\
     <pre>
     decodeNumeric("64", 10)   --> "@"
     decodeNumeric("20ac", 16) --> "€"
     </pre>
     
     - Parameter string
     - Parameter base
     - Returns: Character
     */
    fileprivate func decodeNumeric(_ string: String, base: Int32) -> Character? {
        let code = UInt32(strtoul(string, nil, base))
        return Character(UnicodeScalar(code)!)
    }
    
    /**
     Decode the HTML character entity to the corresponding\
     Unicode character, return `nil` for invalid input.\
     <pre>
     decode("&amp;#64;")    --> "@"
     decode("&amp;#x20ac;") --> "€"
     decode("&amp;lt;")     --> "<"
     decode("&amp;foo;")    --> nil
     </pre>
     
     - Parameter entity: The entities
     - Returns: Character
     */
    fileprivate func decode(_ entity: String) -> Character? {
        if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
            //index(startIndex, offsetBy: from)
            return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 3)...]), base: 16)
        } else if entity.hasPrefix("&#") {
            return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 2)...]), base: 10)
        } else {
            return HTMLEntities.characterEntities[entity]
        }
    }
    
    /**
     Returns a new string made by replacing in the `String` all HTML character entity references with the corresponding character.
     
     - Returns: the decoded HTML
     */
    func decodeHTML() -> String {
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position..<endIndex) {
            result.append(String(self[position..<ampRange.lowerBound]))
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position..<endIndex) {
                let entity = self[position..<semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(String(entity)) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(String(entity))
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(String(self[position..<endIndex]))
        return result
    }
    
    /**
     Encode the HTML
     
     - Returns: the encoded HTML
     */
    func encodeHTML() -> String {
        // Ok, this feels weird.
        var tempString = self
        
        // First do the amperstand, otherwise it will ruin everything.
        tempString = tempString.replace("&", withString: "&amp;")
        
        // Loop trough the HTMLEntities.
        for (index, value) in HTMLEntities.characterEntities {
            // Ignore the "&".
            if String(value) != "&" {
                // Replace val, with index.
                tempString = tempString.replace(String(value), withString: index)
            }
        }
        
        // return and be happy
        return tempString
    }
    
    /**
     getHTMLEntities
     
     - Returns: the HTMLEntities.
     */
    func getHTMLEntities() -> [String: Character] {
        // PHP, Shame on you. but here you'll go.
        return HTMLEntities.characterEntities
    }
    
    /**
     Charcode for the character at index x
     
     - Parameter Char: the character index
     
     - Returns: charcode (int)
     */
    func charCodeAt(_ character: Int) -> Int {
        if self.length > character {
            let character = String(self.characterAtIndex(character))
            return Int(String(character.unicodeScalars.first!.value))!
        } else {
            return 0
        }
    }
    
    /**
     Substring a string.
     
     - Parameter start: the start
     - Parameter length: the length
     
     - Returns: the substring
     */
    func substr(_ start: Int, _ length: Int = 0) -> String {
        let str = self
        if length == 0 {
            // We'll only have a 'start' position
            
            if start < 1 {
                // Count down to end.
                let startPosition: Int = (str.count + start)
                return str[startPosition...str.count]
            } else {
                // Ok we'll start at point...
                return str[start...str.count]
            }
        } else {
            // Ok, this could be fun, but we can also..
            // Nevermind.
            // We'll need to handle the length...
            
            if length > 0 {
                if start < 1 {
                    // We'll know this trick!
                    let startPosition: Int = (str.count + start)
                    
                    // Will be postitive in the end. (hopefully :P)
                    // Ok, this is amazing! let me explain
                    // String Count - (String count - -Start Point) + length
                    // ^^^ -- is + (Since Start Point is a negative number)
                    // String Count - Start point + length
                    var endPosition: Int = ((str.count - (str.count + start)) + length)
                    
                    // If the endposition > the string, just string length.
                    if endPosition > str.count {
                        endPosition = str.count
                    }
                    
                    // i WILL return ;)
                    return str[startPosition...endPosition]
                } else {
                    // We'll know this trick!
                    let startPosition: Int = start
                    
                    // Will be postitive in the end. (hopefully :P)
                    var endPosition: Int = ((str.count - start) + length)
                    
                    // If the endposition > the string, just string length.
                    if endPosition > str.count {
                        endPosition = str.count
                    }
                    
                    // i WILL return ;)
                    return str[startPosition...endPosition]
                }
            } else {
                // End tries to be funny.
                // so fix that.
                // Length (end = negative)
                
                if start < 1 {
                    // But, Wait. Start is also negative?!
                    
                    // Count down to end.
                    let startPosition: Int = (str.count + start)
                    
                    // We'll doing some magic here again, please, i don't explain this one also! (HAHA)
                    var endPosition: Int = (str.count - ((str.count + start) + (length + 1)))
                    
                    // If the endposition > the string, just string length.
                    if endPosition > str.count {
                        endPosition = str.count
                    }
                    
                    // i WILL return ;)
                    return str[startPosition...endPosition]
                } else {
                    // Ok we'll start at point...
                    
                    // Count down to end.
                    let startPosition: Int = (str.count - start)
                    
                    // We'll doing some magic here again, please, i don't explain this one also! (HAHA)
                    var endPosition: Int = (str.count - ((str.count - start) + (length + 1)))
                    
                    // If the endposition > the string, just string length.
                    if endPosition > str.count {
                        endPosition = str.count
                    }
                    
                    // i WILL return ;)
                    return str[startPosition...endPosition]
                }
            }
            // we'll having fun now!
        }
        // And it's done.
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func smile() -> String {
        return self.smilie()
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func smilie() -> String {
        return self.replaceLC(":@", withString: "😡")
            .replaceLC(":)", withString: "😊")
            .replaceLC(":(", withString: "😠")
            .replaceLC("(!)", withString: "⚠️")
            .replaceLC("(block)", withString: "⛔")
            //                   .replaceLC("", withString: "🚧")
            .replaceLC(":(", withString: "🚫")
            .replaceLC("(nl)", withString: "🇳🇱")
            .replaceLC("(bl)", withString: "💙")
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - search: <#search description#>
    ///   - caseSentive: <#caseSentive description#>
    /// - Returns: <#description#>
    func contains(search: String, caseSentive: Bool = false) -> Bool {
        if caseSentive {
            return (self.range(of: search) != nil)
        } else {
            return (self.lowercased.range(of: search.lowercased) != nil)
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - withString: <#withString description#>
    /// - Returns: <#description#>
    func replaceLC(_ target: String, withString: String) -> String {
        return (self.lowercased()).replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func load() -> String {
        DispatchQueue.main.async {
            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            #endif
        }
        
        let returnValue = Aurora().getDataAsText(self) as String
        
        DispatchQueue.main.async {
            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            #endif
        }
        
        return returnValue
    }
    
    /// <#Description#>
    subscript (idx: Int) -> String {
        return String(self[idx] as Character)
    }
    
    //    /**
    //     Make a sha1 Hash for the string.
    //     - Returns: sha1 hashed string
    //     */
    //    public var sha1: String {
    //        get {
    //            return SHA1Hashing().hash(self)
    //        }
    //    }
    
    /// <#Description#>
    /// - Returns: <#description#>
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
    /// String decoded from base64 (if applicable).
    ///
    ///        "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        let remainder = count % 4
        
        var padding = ""
        if remainder > 0 {
        padding = String(repeating: "=", count: 4 - remainder)
        }
        
        guard let data = Data(base64Encoded: self + padding,
        options: .ignoreUnknownCharacters) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    #endif
    
    #if canImport(Foundation)
    /// String encoded in base64 (if applicable).
    ///
    ///        "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    #endif
    
    /// Array of characters of a string.
    var charactersArray: [Character] {
        return Array(self)
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
    
    /// First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
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
    
    /// <#Description#>
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8)
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr {
            return str as String
        }
        return self
    }
    
    /// <#Description#>
    var encodeEmoji: String {
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) {
            return encodeStr as String
        }
        return self
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
    /// Check if string is a valid Swift number. Note: In North America, "." is the decimal separator, while in many parts of Europe "," is used,
    ///
    ///        "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///        "abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux) || targetEnvironment(macCatalyst)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
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
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
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
    ///        "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
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
    ///        "SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
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
        guard count > 0 else { return false }
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
            randomString.append(base.randomElement()!)
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
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
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
    /// Date object from string of date format.
    ///
    ///        "2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    #endif
    
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
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
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
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }
    
}

#if !os(Linux)

// MARK: - NSAttributedString
public extension String {
    
    #if canImport(UIKit)
    private typealias Font = UIFont
    #endif
    
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    private typealias Font = NSFont
    #endif
    
    #if os(iOS) || os(macOS)
    /// Bold string.
    var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: Font.boldSystemFont(ofSize: Font.systemFontSize)])
    }
    #endif
    
    #if canImport(Foundation)
    /// Underlined string
    var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
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
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    #if canImport(AppKit) || canImport(UIKit)
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func colored(with color: Color) -> NSAttributedString {
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
    ///   See NSString [appendingPathComponent(_:)](https://developer.apple.com/documentation/foundation/nsstring/1417069-appendingpathcomponent)
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
extension String.StringInterpolation {
    /// Prints `Optional` values by only interpolating it if the value is set.
    /// `nil` is used as a fallback value to provide a clear output.
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
        appendInterpolation(value ?? "nil" as CustomStringConvertible)
    }
}
