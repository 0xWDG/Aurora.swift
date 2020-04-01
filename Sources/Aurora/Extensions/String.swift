// $$HEADER$$

import Foundation
import UIKit
import CommonCrypto

/**
 Extensions for Strings
 */
public extension String {
    var md5: String {
        get {
            let data = Data(utf8)
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

            data.withUnsafeBytes { buffer in
                _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &hash)
            }

            return hash.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
    var lowerAndNoSpaces: String {
        get {
            return self.lowercased.replace(" ", withString: "")
        }
    }
    
    fileprivate struct HTMLEntities {
        static let characterEntities : [String: Character] = [
            
            // XML predefined entities:
            "&amp;" : "&",
            "&quot;" : "\"",
            "&apos;" : "'",
            "&lt;" : "<",
            "&gt;" : ">",
            
            // HTML character entity references:
            "&nbsp;" : "\u{00A0}",
            "&iexcl;" : "\u{00A1}",
            "&cent;" : "\u{00A2}",
            "&pound;" : "\u{00A3}",
            "&curren;" : "\u{00A4}",
            "&yen;" : "\u{00A5}",
            "&brvbar;" : "\u{00A6}",
            "&sect;" : "\u{00A7}",
            "&uml;" : "\u{00A8}",
            "&copy;" : "\u{00A9}",
            "&ordf;" : "\u{00AA}",
            "&laquo;" : "\u{00AB}",
            "&not;" : "\u{00AC}",
            "&shy;" : "\u{00AD}",
            "&reg;" : "\u{00AE}",
            "&macr;" : "\u{00AF}",
            "&deg;" : "\u{00B0}",
            "&plusmn;" : "\u{00B1}",
            "&sup2;" : "\u{00B2}",
            "&sup3;" : "\u{00B3}",
            "&acute;" : "\u{00B4}",
            "&micro;" : "\u{00B5}",
            "&para;" : "\u{00B6}",
            "&middot;" : "\u{00B7}",
            "&cedil;" : "\u{00B8}",
            "&sup1;" : "\u{00B9}",
            "&ordm;" : "\u{00BA}",
            "&raquo;" : "\u{00BB}",
            "&frac14;" : "\u{00BC}",
            "&frac12;" : "\u{00BD}",
            "&frac34;" : "\u{00BE}",
            "&iquest;" : "\u{00BF}",
            "&Agrave;" : "\u{00C0}",
            "&Aacute;" : "\u{00C1}",
            "&Acirc;" : "\u{00C2}",
            "&Atilde;" : "\u{00C3}",
            "&Auml;" : "\u{00C4}",
            "&Aring;" : "\u{00C5}",
            "&AElig;" : "\u{00C6}",
            "&Ccedil;" : "\u{00C7}",
            "&Egrave;" : "\u{00C8}",
            "&Eacute;" : "\u{00C9}",
            "&Ecirc;" : "\u{00CA}",
            "&Euml;" : "\u{00CB}",
            "&Igrave;" : "\u{00CC}",
            "&Iacute;" : "\u{00CD}",
            "&Icirc;" : "\u{00CE}",
            "&Iuml;" : "\u{00CF}",
            "&ETH;" : "\u{00D0}",
            "&Ntilde;" : "\u{00D1}",
            "&Ograve;" : "\u{00D2}",
            "&Oacute;" : "\u{00D3}",
            "&Ocirc;" : "\u{00D4}",
            "&Otilde;" : "\u{00D5}",
            "&Ouml;" : "\u{00D6}",
            "&times;" : "\u{00D7}",
            "&Oslash;" : "\u{00D8}",
            "&Ugrave;" : "\u{00D9}",
            "&Uacute;" : "\u{00DA}",
            "&Ucirc;" : "\u{00DB}",
            "&Uuml;" : "\u{00DC}",
            "&Yacute;" : "\u{00DD}",
            "&THORN;" : "\u{00DE}",
            "&szlig;" : "\u{00DF}",
            "&agrave;" : "\u{00E0}",
            "&aacute;" : "\u{00E1}",
            "&acirc;" : "\u{00E2}",
            "&atilde;" : "\u{00E3}",
            "&auml;" : "\u{00E4}",
            "&aring;" : "\u{00E5}",
            "&aelig;" : "\u{00E6}",
            "&ccedil;" : "\u{00E7}",
            "&egrave;" : "\u{00E8}",
            "&eacute;" : "\u{00E9}",
            "&ecirc;" : "\u{00EA}",
            "&euml;" : "\u{00EB}",
            "&igrave;" : "\u{00EC}",
            "&iacute;" : "\u{00ED}",
            "&icirc;" : "\u{00EE}",
            "&iuml;" : "\u{00EF}",
            "&eth;" : "\u{00F0}",
            "&ntilde;" : "\u{00F1}",
            "&ograve;" : "\u{00F2}",
            "&oacute;" : "\u{00F3}",
            "&ocirc;" : "\u{00F4}",
            "&otilde;" : "\u{00F5}",
            "&ouml;" : "\u{00F6}",
            "&divide;" : "\u{00F7}",
            "&oslash;" : "\u{00F8}",
            "&ugrave;" : "\u{00F9}",
            "&uacute;" : "\u{00FA}",
            "&ucirc;" : "\u{00FB}",
            "&uuml;" : "\u{00FC}",
            "&yacute;" : "\u{00FD}",
            "&thorn;" : "\u{00FE}",
            "&yuml;" : "\u{00FF}",
            "&OElig;" : "\u{0152}",
            "&oelig;" : "\u{0153}",
            "&Scaron;" : "\u{0160}",
            "&scaron;" : "\u{0161}",
            "&Yuml;" : "\u{0178}",
            "&fnof;" : "\u{0192}",
            "&circ;" : "\u{02C6}",
            "&tilde;" : "\u{02DC}",
            "&Alpha;" : "\u{0391}",
            "&Beta;" : "\u{0392}",
            "&Gamma;" : "\u{0393}",
            "&Delta;" : "\u{0394}",
            "&Epsilon;" : "\u{0395}",
            "&Zeta;" : "\u{0396}",
            "&Eta;" : "\u{0397}",
            "&Theta;" : "\u{0398}",
            "&Iota;" : "\u{0399}",
            "&Kappa;" : "\u{039A}",
            "&Lambda;" : "\u{039B}",
            "&Mu;" : "\u{039C}",
            "&Nu;" : "\u{039D}",
            "&Xi;" : "\u{039E}",
            "&Omicron;" : "\u{039F}",
            "&Pi;" : "\u{03A0}",
            "&Rho;" : "\u{03A1}",
            "&Sigma;" : "\u{03A3}",
            "&Tau;" : "\u{03A4}",
            "&Upsilon;" : "\u{03A5}",
            "&Phi;" : "\u{03A6}",
            "&Chi;" : "\u{03A7}",
            "&Psi;" : "\u{03A8}",
            "&Omega;" : "\u{03A9}",
            "&alpha;" : "\u{03B1}",
            "&beta;" : "\u{03B2}",
            "&gamma;" : "\u{03B3}",
            "&delta;" : "\u{03B4}",
            "&epsilon;" : "\u{03B5}",
            "&zeta;" : "\u{03B6}",
            "&eta;" : "\u{03B7}",
            "&theta;" : "\u{03B8}",
            "&iota;" : "\u{03B9}",
            "&kappa;" : "\u{03BA}",
            "&lambda;" : "\u{03BB}",
            "&mu;" : "\u{03BC}",
            "&nu;" : "\u{03BD}",
            "&xi;" : "\u{03BE}",
            "&omicron;" : "\u{03BF}",
            "&pi;" : "\u{03C0}",
            "&rho;" : "\u{03C1}",
            "&sigmaf;" : "\u{03C2}",
            "&sigma;" : "\u{03C3}",
            "&tau;" : "\u{03C4}",
            "&upsilon;" : "\u{03C5}",
            "&phi;" : "\u{03C6}",
            "&chi;" : "\u{03C7}",
            "&psi;" : "\u{03C8}",
            "&omega;" : "\u{03C9}",
            "&thetasym;" : "\u{03D1}",
            "&upsih;" : "\u{03D2}",
            "&piv;" : "\u{03D6}",
            "&ensp;" : "\u{2002}",
            "&emsp;" : "\u{2003}",
            "&thinsp;" : "\u{2009}",
            "&zwnj;" : "\u{200C}",
            "&zwj;" : "\u{200D}",
            "&lrm;" : "\u{200E}",
            "&rlm;" : "\u{200F}",
            "&ndash;" : "\u{2013}",
            "&mdash;" : "\u{2014}",
            "&lsquo;" : "\u{2018}",
            "&rsquo;" : "\u{2019}",
            "&sbquo;" : "\u{201A}",
            "&ldquo;" : "\u{201C}",
            "&rdquo;" : "\u{201D}",
            "&bdquo;" : "\u{201E}",
            "&dagger;" : "\u{2020}",
            "&Dagger;" : "\u{2021}",
            "&bull;" : "\u{2022}",
            "&hellip;" : "\u{2026}",
            "&permil;" : "\u{2030}",
            "&prime;" : "\u{2032}",
            "&Prime;" : "\u{2033}",
            "&lsaquo;" : "\u{2039}",
            "&rsaquo;" : "\u{203A}",
            "&oline;" : "\u{203E}",
            "&frasl;" : "\u{2044}",
            "&euro;" : "\u{20AC}",
            "&image;" : "\u{2111}",
            "&weierp;" : "\u{2118}",
            "&real;" : "\u{211C}",
            "&trade;" : "\u{2122}",
            "&alefsym;" : "\u{2135}",
            "&larr;" : "\u{2190}",
            "&uarr;" : "\u{2191}",
            "&rarr;" : "\u{2192}",
            "&darr;" : "\u{2193}",
            "&harr;" : "\u{2194}",
            "&crarr;" : "\u{21B5}",
            "&lArr;" : "\u{21D0}",
            "&uArr;" : "\u{21D1}",
            "&rArr;" : "\u{21D2}",
            "&dArr;" : "\u{21D3}",
            "&hArr;" : "\u{21D4}",
            "&forall;" : "\u{2200}",
            "&part;" : "\u{2202}",
            "&exist;" : "\u{2203}",
            "&empty;" : "\u{2205}",
            "&nabla;" : "\u{2207}",
            "&isin;" : "\u{2208}",
            "&notin;" : "\u{2209}",
            "&ni;" : "\u{220B}",
            "&prod;" : "\u{220F}",
            "&sum;" : "\u{2211}",
            "&minus;" : "\u{2212}",
            "&lowast;" : "\u{2217}",
            "&radic;" : "\u{221A}",
            "&prop;" : "\u{221D}",
            "&infin;" : "\u{221E}",
            "&ang;" : "\u{2220}",
            "&and;" : "\u{2227}",
            "&or;" : "\u{2228}",
            "&cap;" : "\u{2229}",
            "&cup;" : "\u{222A}",
            "&int;" : "\u{222B}",
            "&there4;" : "\u{2234}",
            "&sim;" : "\u{223C}",
            "&cong;" : "\u{2245}",
            "&asymp;" : "\u{2248}",
            "&ne;" : "\u{2260}",
            "&equiv;" : "\u{2261}",
            "&le;" : "\u{2264}",
            "&ge;" : "\u{2265}",
            "&sub;" : "\u{2282}",
            "&sup;" : "\u{2283}",
            "&nsub;" : "\u{2284}",
            "&sube;" : "\u{2286}",
            "&supe;" : "\u{2287}",
            "&oplus;" : "\u{2295}",
            "&otimes;" : "\u{2297}",
            "&perp;" : "\u{22A5}",
            "&sdot;" : "\u{22C5}",
            "&lceil;" : "\u{2308}",
            "&rceil;" : "\u{2309}",
            "&lfloor;" : "\u{230A}",
            "&rfloor;" : "\u{230B}",
            "&lang;" : "\u{2329}",
            "&rang;" : "\u{232A}",
            "&loz;" : "\u{25CA}",
            "&spades;" : "\u{2660}",
            "&clubs;" : "\u{2663}",
            "&hearts;" : "\u{2665}",
            "&diams;" : "\u{2666}",
            ]
    }
        
    /**
     get lowercased string
     */
    var lowercased: String {
        get {
            return self.lowercased()
        }
    }
    
    /**
     get string length
     */
    var length: Int {
        get {
            return self.count
        }
    }
    
    /**
     contains
     
     - Parameter s: String to check
     
     - Returns: true/false
     */
    func contains(_ s: String) -> Bool {
        return self.range(of: s) != nil ? true : false
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
     
     - Parameter i: The index
     
     - Returns: The ranged string
     */
    subscript(i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    /**
     add subscript
     
     - Parameter r: Range [1..2]
     
     - Returns: The ranged string.
     */
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - 1)
            
            return String(self[startIndex..<endIndex])
        }
    }
    
    /**
     add subscript
     
     - Parameter r: Range [1..2]
     
     - Returns: The ranged string.
     */
    subscript(r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - 1)
            
            return String(self[startIndex..<endIndex])
        }
    }
    
    /**
     Finds the string between two bookend strings if it can be found.
     
     - parameter left:  The left bookend
     - parameter right: The right bookend
     
     - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
     */
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards), left != right && leftRange.upperBound != rightRange.lowerBound
            else {
                return nil
        }
        
        
        //        return self[leftRange.upperBound...(before: rightRange.lowerBound)]
        return self
        
    }
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
    func camelize() -> String {
        let source = clean(" ", allOf: "-", "_")
        if source.contains(" ") {
            let first = source[...source.startIndex]
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: "", options: [], range: nil)) as String
            let rest = String(cammel.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased[...source.startIndex]
            let rest = String(source.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return self.capitalized
    }
    
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
    
    func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter {!$0.isEmpty}
        return components.joined(separator: " ")
    }
    
    func clean(_ with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    func initials() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce("") {$0 + $1[0...0]}
    }
    
    func initialsFirstAndLast() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce("") {($0 == "" ? "" : $0[0...0]) + $1[0...0]}
    }
    
    func isAlpha() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").length == 0
    }
    
    func isEmpty() -> Bool {
        let nonWhitespaceSet = CharacterSet.whitespacesAndNewlines
        return components(separatedBy: nonWhitespaceSet).joined(separator: "").length != 0
    }
    
    func isNumeric() -> Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    func join<S : Sequence>(_ elements: S) -> String {
        return elements.map {String(describing: $0)}.joined(separator: self)
    }
    
    func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: NSLocale.current)
    }
    
    func lines() -> [String] {
        return self.split {$0 == "\n"}.map(String.init)
    }
    
    func pad(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    func padLeft(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    func padRight(_ n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    func slugify() -> String {
        let slugCharacterSet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
        return latinize().lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter {$0 != ""}
            .joined(separator: "-")
    }
    
    func split(_ separator: Character) -> [String] {
        return self.split {$0 == separator}.map(String.init)
    }
    
    var textLines: [String] {
        return split("\n")
    }
    
    var words: [String] {
        return split(" ")
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    func stripPunctuation() -> String {
        return components(separatedBy: .punctuationCharacters)
            .joined(separator: "")
            .components(separatedBy: " ")
            .filter {$0 != ""}
            .joined(separator: " ")
    }
    
    func times(_ n: Int) -> String {
//        return (0..<n).reduce("") {$0 + self}
        var returnString = ""
        for _ in stride(from: 0, to: n, by: 1) {
            returnString += self
        }
        return returnString
    }
    
    func toFloat() -> Float? {
        if let number = NumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    func toDouble(_ locale: Locale = Locale.current) -> Double? {
        let nf = NumberFormatter()
        nf.locale = locale as Locale
        if let number = nf.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
    
    /**
     Convert anything to bool...
     
     - Returns: Bool
     */
    func toBool() -> Bool? {
        let trimmed = self.trimmed().lowercased
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func toDateTime(_ format : String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    /**
     trimmedLeft
     
     - Returns: Left trimmed string
     */
    func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        
        return self
    }
    
    /**
     trimmedRight
     
     - Returns: Right trimmed string
     */
    func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        
        return self
    }
    
    /**
     trimmed
     
     - Returns: Left & Right trimmed.
     */
    func trimmed() -> String {
        return trimmedLeft().trimmedRight()
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
    fileprivate func decodeNumeric(_ string : String, base : Int32) -> Character? {
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
    fileprivate func decode(_ entity : String) -> Character? {
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
        var _tempString = self
        
        // First do the amperstand, otherwise it will ruin everything.
        _tempString = _tempString.replace("&", withString: "&amp;")
        
        // Loop trough the HTMLEntities.
        for (index, value) in HTMLEntities.characterEntities {
            // Ignore the "&".
            if (String(value) != "&") {
                // Replace val, with index.
                _tempString = _tempString.replace(String(value), withString: index)
            }
        }
        
        // return and be happy
        return _tempString
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
    func charCodeAt(_ Char: Int) -> Int {
        // ok search for the character...
        
        if (self.length > Char) {
            let character = String(self.characterAtIndex(Char))
            return Int(String(character.unicodeScalars.first!.value))!
        } else {
            return 0
        }
    }
    func UcharCodeAt(_ Char: Int) -> UInt {
        // ok search for the character...
        
        if (self.length > Int(Char)) {
            let character = String(self.characterAtIndex(Int(Char)))
            return UInt(String(character.unicodeScalars.first!.value))!
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
        if (length == 0) {
            // We'll only have a 'start' position
            
            if (start < 1) {
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
            
            if (length > 0) {
                if (start < 1) {
                    // We'll know this trick!
                    let startPosition: Int = (str.count + start)
                    
                    // Will be postitive in the end. (hopefully :P)
                    // Ok, this is amazing! let me explain
                    // String Count - (String count - -Start Point) + length
                    // ^^^ -- is + (Since Start Point is a negative number)
                    // String Count - Start point + length
                    var endPosition: Int = ((str.count - (str.count + start)) + length)
                    
                    // If the endposition > the string, just string length.
                    if (endPosition > str.count) {
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
                    if (endPosition > str.count) {
                        endPosition = str.count
                    }
                    
                    // i WILL return ;)
                    return str[startPosition...endPosition]
                }
            } else {
                // End tries to be funny.
                // so fix that.
                // Length (end = negative)
                
                if (start < 1) {
                    // But, Wait. Start is also negative?!
                    
                    // Count down to end.
                    let startPosition: Int = (str.count + start)
                    
                    // We'll doing some magic here again, please, i don't explain this one also! (HAHA)
                    var endPosition: Int = (str.count - ((str.count + start) + (length + 1)))
                    
                    // If the endposition > the string, just string length.
                    if (endPosition > str.count) {
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
                    if (endPosition > str.count) {
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
    
    func smile() -> String {
        return String(self).smilie()
    }
    
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
    
    func contains(search: String, caseSentive: Bool = false) -> Bool {
        if (caseSentive) {
            return (self.range(of: search) != nil)
        } else {
            return (self.lowercased.range(of: search.lowercased) != nil)
        }
    }
    
    func replaceLC(_ target: String, withString: String) -> String {
        return (self.lowercased()).replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func load() -> String {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        let returnValue = Aurora().getDataAsText(self) as String

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        return returnValue
    }
    
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
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

        }catch{
            return NSAttributedString()
        }
    }
}
