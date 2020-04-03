// $$HEADER$$
// swiftlint:disable file_length

#if !os(Linux)
#if !os(watchOS)
import CoreImage
#endif

// MARK: - Properties
public extension Color {
    static let Aurora = Color.init(red: 0, green: 212/255, blue: 255/255, alpha: 1.0)

    /// Random color.
    static var random: Color {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return Color(red: red, green: green, blue: blue)!
    }
    
    // swiftlint:disable large_tuple
    /// RGB components for a Color (between 0 and 255).
    ///
    ///     UIColor.red.rgbComponents.red -> 255
    ///     NSColor.green.rgbComponents.green -> 255
    ///     UIColor.blue.rgbComponents.blue -> 255
    ///
    var rgbComponents: (red: Int, green: Int, blue: Int) {
        var components: [CGFloat] {
            let comps = cgColor.components!
            if comps.count == 4 { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
    }
    // swiftlint:enable large_tuple
    // swiftlint:disable large_tuple
    /// RGB components for a Color represented as CGFloat numbers (between 0 and 1)
    ///
    ///     UIColor.red.rgbComponents.red -> 1.0
    ///     NSColor.green.rgbComponents.green -> 1.0
    ///     UIColor.blue.rgbComponents.blue -> 1.0
    ///
    var cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var components: [CGFloat] {
            let comps = cgColor.components!
            if comps.count == 4 { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: red, green: green, blue: blue)
    }
    // swiftlint:enable large_tuple
    // swiftlint:disable large_tuple
    /// Get components of hue, saturation, and brightness, and alpha (read-only).
    var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    // swiftlint:enable large_tuple
    /// Hexadecimal value string (read-only).
    var hexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps: [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
    
    /// Short hexadecimal value string (read-only, if applicable).
    var shortHexString: String? {
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }
    
    /// Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
    var shortHexOrHexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps: [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }
    
    /// Alpha of Color (read-only).
    var alpha: CGFloat {
        return cgColor.alpha
    }
    
    #if !os(watchOS)
    /// CoreImage.CIColor (read-only)
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
    #endif
    
    /// Get UInt representation of a Color (read-only).
    var uInt: UInt {
        let comps: [CGFloat] = {
            let comps = cgColor.components!
            return comps.count == 4 ? comps: [comps[0], comps[0], comps[0], comps[1]]
        }()
        
        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(comps[0] * 255.0) << 16
        colorAsUInt32 += UInt32(comps[1] * 255.0) << 8
        colorAsUInt32 += UInt32(comps[2] * 255.0)
        
        return UInt(colorAsUInt32)
    }
    
    /// Get color complementary (read-only, if applicable).
    var complementary: Color? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { color -> Color? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return self
            }
        }
        
        let color = convertColorToRGBSpace(self)
        guard let componentColors = color?.cgColor.components else { return nil }
        
        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        
        return Color(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}

// MARK: - Methods
public extension Color {
    
    /// Blend two Colors
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and seond colors.
    static func blend(_ color1: Color, intensity1: CGFloat = 0.5, with color2: Color, intensity2: CGFloat = 0.5) -> Color {
        // http://stackoverflow.com/questions/27342715/blend-uicolors-in-swift
        let total = intensity1 + intensity2
        let level1 = intensity1/total
        let level2 = intensity2/total
        
        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }
        
        let components1: [CGFloat] = {
            let comps = color1.cgColor.components!
            return comps.count == 4 ? comps: [comps[0], comps[0], comps[0], comps[1]]
        }()
        
        let components2: [CGFloat] = {
            let comps = color2.cgColor.components!
            return comps.count == 4 ? comps: [comps[0], comps[0], comps[0], comps[1]]
        }()
        
        let red1 = components1[0]
        let red2 = components2[0]
        
        let green1 = components1[1]
        let green2 = components2[1]
        
        let blue1 = components1[2]
        let blue2 = components2[2]
        
        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha
        
        let red = level1*red1 + level2*red2
        let green = level1*green1 + level2*green2
        let blue = level1*blue1 + level2*blue2
        let alpha = level1*alpha1 + level2*alpha2
        
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Lighten a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let lighterColor: Color = color.lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color
    /// - Returns: A lightened color
    func lighten(by percentage: CGFloat = 0.2) -> Color {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: min(red + percentage, 1.0),
                     green: min(green + percentage, 1.0),
                     blue: min(blue + percentage, 1.0),
                     alpha: alpha)
    }
    
    /// Darken a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: Color = color.darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color
    /// - Returns: A darkened color
    func darken(by percentage: CGFloat = 0.2) -> Color {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: max(red - percentage, 0),
                     green: max(green - percentage, 0),
                     blue: max(blue - percentage, 0),
                     alpha: alpha)
    }
    
}

// MARK: - Initializers
public extension Color {
    
    /// Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    /// Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    /// Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    /// Create Color from a complementary of a Color (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(complementaryFor color: Color) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { color -> Color? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }
        
        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil }
        
        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}

// MARK: - Social
public extension Color {
    
    /// Brand identity color of popular social media platform.
    struct Social {
        // https://www.lockedowndesign.com/social-media-colors/
        private init() {}
        
        /// red: 59, green: 89, blue: 152
        public static let facebook = Color(red: 59, green: 89, blue: 152)!
        
        /// red: 0, green: 182, blue: 241
        public static let twitter = Color(red: 0, green: 182, blue: 241)!
        
        /// red: 223, green: 74, blue: 50
        public static let googlePlus = Color(red: 223, green: 74, blue: 50)!
        
        /// red: 0, green: 123, blue: 182
        public static let linkedIn = Color(red: 0, green: 123, blue: 182)!
        
        /// red: 69, green: 187, blue: 255
        public static let vimeo = Color(red: 69, green: 187, blue: 255)!
        
        /// red: 179, green: 18, blue: 23
        public static let youtube = Color(red: 179, green: 18, blue: 23)!
        
        /// red: 195, green: 42, blue: 163
        public static let instagram = Color(red: 195, green: 42, blue: 163)!
        
        /// red: 203, green: 32, blue: 39
        public static let pinterest = Color(red: 203, green: 32, blue: 39)!
        
        /// red: 244, green: 0, blue: 131
        public static let flickr = Color(red: 244, green: 0, blue: 131)!
        
        /// red: 67, green: 2, blue: 151
        public static let yahoo = Color(red: 67, green: 2, blue: 151)!
        
        /// red: 67, green: 2, blue: 151
        public static let soundCloud = Color(red: 67, green: 2, blue: 151)!
        
        /// red: 44, green: 71, blue: 98
        public static let tumblr = Color(red: 44, green: 71, blue: 98)!
        
        /// red: 252, green: 69, blue: 117
        public static let foursquare = Color(red: 252, green: 69, blue: 117)!
        
        /// red: 255, green: 176, blue: 0
        public static let swarm = Color(red: 255, green: 176, blue: 0)!
        
        /// red: 234, green: 76, blue: 137
        public static let dribbble = Color(red: 234, green: 76, blue: 137)!
        
        /// red: 255, green: 87, blue: 0
        public static let reddit = Color(red: 255, green: 87, blue: 0)!
        
        /// red: 74, green: 93, blue: 78
        public static let devianArt = Color(red: 74, green: 93, blue: 78)!
        
        /// red: 238, green: 64, blue: 86
        public static let pocket = Color(red: 238, green: 64, blue: 86)!
        
        /// red: 170, green: 34, blue: 182
        public static let quora = Color(red: 170, green: 34, blue: 182)!
        
        /// red: 247, green: 146, blue: 30
        public static let slideShare = Color(red: 247, green: 146, blue: 30)!
        
        /// red: 0, green: 153, blue: 229
        public static let px500 = Color(red: 0, green: 153, blue: 229)!
        
        /// red: 223, green: 109, blue: 70
        public static let listly = Color(red: 223, green: 109, blue: 70)!
        
        /// red: 0, green: 180, blue: 137
        public static let vine = Color(red: 0, green: 180, blue: 137)!
        
        /// red: 0, green: 175, blue: 240
        public static let skype = Color(red: 0, green: 175, blue: 240)!
        
        /// red: 235, green: 73, blue: 36
        public static let stumbleUpon = Color(red: 235, green: 73, blue: 36)!
        
        /// red: 255, green: 252, blue: 0
        public static let snapchat = Color(red: 255, green: 252, blue: 0)!
        
        /// red: 37, green: 211, blue: 102
        public static let whatsApp = Color(red: 37, green: 211, blue: 102)!
    }
    
}

// MARK: - Material colors
public extension Color {
    
    /// Google Material design colors palette.
    struct Material {
        // https://material.google.com/style/color.html
        private init() {}
        
        /// color red500
        public static let red = red500
        
        /// hex #FFEBEE
        public static let red50 = Color(hex: 0xFFEBEE)!
        
        /// hex #FFCDD2
        public static let red100 = Color(hex: 0xFFCDD2)!
        
        /// hex #EF9A9A
        public static let red200 = Color(hex: 0xEF9A9A)!
        
        /// hex #E57373
        public static let red300 = Color(hex: 0xE57373)!
        
        /// hex #EF5350
        public static let red400 = Color(hex: 0xEF5350)!
        
        /// hex #F44336
        public static let red500 = Color(hex: 0xF44336)!
        
        /// hex #E53935
        public static let red600 = Color(hex: 0xE53935)!
        
        /// hex #D32F2F
        public static let red700 = Color(hex: 0xD32F2F)!
        
        /// hex #C62828
        public static let red800 = Color(hex: 0xC62828)!
        
        /// hex #B71C1C
        public static let red900 = Color(hex: 0xB71C1C)!
        
        /// hex #FF8A80
        public static let redA100 = Color(hex: 0xFF8A80)!
        
        /// hex #FF5252
        public static let redA200 = Color(hex: 0xFF5252)!
        
        /// hex #FF1744
        public static let redA400 = Color(hex: 0xFF1744)!
        
        /// hex #D50000
        public static let redA700 = Color(hex: 0xD50000)!
        
        /// color pink500
        public static let pink = pink500
        
        /// hex #FCE4EC
        public static let pink50 = Color(hex: 0xFCE4EC)!
        
        /// hex #F8BBD0
        public static let pink100 = Color(hex: 0xF8BBD0)!
        
        /// hex #F48FB1
        public static let pink200 = Color(hex: 0xF48FB1)!
        
        /// hex #F06292
        public static let pink300 = Color(hex: 0xF06292)!
        
        /// hex #EC407A
        public static let pink400 = Color(hex: 0xEC407A)!
        
        /// hex #E91E63
        public static let pink500 = Color(hex: 0xE91E63)!
        
        /// hex #D81B60
        public static let pink600 = Color(hex: 0xD81B60)!
        
        /// hex #C2185B
        public static let pink700 = Color(hex: 0xC2185B)!
        
        /// hex #AD1457
        public static let pink800 = Color(hex: 0xAD1457)!
        
        /// hex #880E4F
        public static let pink900 = Color(hex: 0x880E4F)!
        
        /// hex #FF80AB
        public static let pinkA100 = Color(hex: 0xFF80AB)!
        
        /// hex #FF4081
        public static let pinkA200 = Color(hex: 0xFF4081)!
        
        /// hex #F50057
        public static let pinkA400 = Color(hex: 0xF50057)!
        
        /// hex #C51162
        public static let pinkA700 = Color(hex: 0xC51162)!
        
        /// color purple500
        public static let purple = purple500
        
        /// hex #F3E5F5
        public static let purple50 = Color(hex: 0xF3E5F5)!
        
        /// hex #E1BEE7
        public static let purple100 = Color(hex: 0xE1BEE7)!
        
        /// hex #CE93D8
        public static let purple200 = Color(hex: 0xCE93D8)!
        
        /// hex #BA68C8
        public static let purple300 = Color(hex: 0xBA68C8)!
        
        /// hex #AB47BC
        public static let purple400 = Color(hex: 0xAB47BC)!
        
        /// hex #9C27B0
        public static let purple500 = Color(hex: 0x9C27B0)!
        
        /// hex #8E24AA
        public static let purple600 = Color(hex: 0x8E24AA)!
        
        /// hex #7B1FA2
        public static let purple700 = Color(hex: 0x7B1FA2)!
        
        /// hex #6A1B9A
        public static let purple800 = Color(hex: 0x6A1B9A)!
        
        /// hex #4A148C
        public static let purple900 = Color(hex: 0x4A148C)!
        
        /// hex #EA80FC
        public static let purpleA100 = Color(hex: 0xEA80FC)!
        
        /// hex #E040FB
        public static let purpleA200 = Color(hex: 0xE040FB)!
        
        /// hex #D500F9
        public static let purpleA400 = Color(hex: 0xD500F9)!
        
        /// hex #AA00FF
        public static let purpleA700 = Color(hex: 0xAA00FF)!
        
        /// color deepPurple500
        public static let deepPurple = deepPurple500
        
        /// hex #EDE7F6
        public static let deepPurple50 = Color(hex: 0xEDE7F6)!
        
        /// hex #D1C4E9
        public static let deepPurple100 = Color(hex: 0xD1C4E9)!
        
        /// hex #B39DDB
        public static let deepPurple200 = Color(hex: 0xB39DDB)!
        
        /// hex #9575CD
        public static let deepPurple300 = Color(hex: 0x9575CD)!
        
        /// hex #7E57C2
        public static let deepPurple400 = Color(hex: 0x7E57C2)!
        
        /// hex #673AB7
        public static let deepPurple500 = Color(hex: 0x673AB7)!
        
        /// hex #5E35B1
        public static let deepPurple600 = Color(hex: 0x5E35B1)!
        
        /// hex #512DA8
        public static let deepPurple700 = Color(hex: 0x512DA8)!
        
        /// hex #4527A0
        public static let deepPurple800 = Color(hex: 0x4527A0)!
        
        /// hex #311B92
        public static let deepPurple900 = Color(hex: 0x311B92)!
        
        /// hex #B388FF
        public static let deepPurpleA100 = Color(hex: 0xB388FF)!
        
        /// hex #7C4DFF
        public static let deepPurpleA200 = Color(hex: 0x7C4DFF)!
        
        /// hex #651FFF
        public static let deepPurpleA400 = Color(hex: 0x651FFF)!
        
        /// hex #6200EA
        public static let deepPurpleA700 = Color(hex: 0x6200EA)!
        
        /// color indigo500
        public static let indigo = indigo500
        
        /// hex #E8EAF6
        public static let indigo50 = Color(hex: 0xE8EAF6)!
        
        /// hex #C5CAE9
        public static let indigo100 = Color(hex: 0xC5CAE9)!
        
        /// hex #9FA8DA
        public static let indigo200 = Color(hex: 0x9FA8DA)!
        
        /// hex #7986CB
        public static let indigo300 = Color(hex: 0x7986CB)!
        
        /// hex #5C6BC0
        public static let indigo400 = Color(hex: 0x5C6BC0)!
        
        /// hex #3F51B5
        public static let indigo500 = Color(hex: 0x3F51B5)!
        
        /// hex #3949AB
        public static let indigo600 = Color(hex: 0x3949AB)!
        
        /// hex #303F9F
        public static let indigo700 = Color(hex: 0x303F9F)!
        
        /// hex #283593
        public static let indigo800 = Color(hex: 0x283593)!
        
        /// hex #1A237E
        public static let indigo900 = Color(hex: 0x1A237E)!
        
        /// hex #8C9EFF
        public static let indigoA100 = Color(hex: 0x8C9EFF)!
        
        /// hex #536DFE
        public static let indigoA200 = Color(hex: 0x536DFE)!
        
        /// hex #3D5AFE
        public static let indigoA400 = Color(hex: 0x3D5AFE)!
        
        /// hex #304FFE
        public static let indigoA700 = Color(hex: 0x304FFE)!
        
        /// color blue500
        public static let blue = blue500
        
        /// hex #E3F2FD
        public static let blue50 = Color(hex: 0xE3F2FD)!
        
        /// hex #BBDEFB
        public static let blue100 = Color(hex: 0xBBDEFB)!
        
        /// hex #90CAF9
        public static let blue200 = Color(hex: 0x90CAF9)!
        
        /// hex #64B5F6
        public static let blue300 = Color(hex: 0x64B5F6)!
        
        /// hex #42A5F5
        public static let blue400 = Color(hex: 0x42A5F5)!
        
        /// hex #2196F3
        public static let blue500 = Color(hex: 0x2196F3)!
        
        /// hex #1E88E5
        public static let blue600 = Color(hex: 0x1E88E5)!
        
        /// hex #1976D2
        public static let blue700 = Color(hex: 0x1976D2)!
        
        /// hex #1565C0
        public static let blue800 = Color(hex: 0x1565C0)!
        
        /// hex #0D47A1
        public static let blue900 = Color(hex: 0x0D47A1)!
        
        /// hex #82B1FF
        public static let blueA100 = Color(hex: 0x82B1FF)!
        
        /// hex #448AFF
        public static let blueA200 = Color(hex: 0x448AFF)!
        
        /// hex #2979FF
        public static let blueA400 = Color(hex: 0x2979FF)!
        
        /// hex #2962FF
        public static let blueA700 = Color(hex: 0x2962FF)!
        
        /// color lightBlue500
        public static let lightBlue = lightBlue500
        
        /// hex #E1F5FE
        public static let lightBlue50 = Color(hex: 0xE1F5FE)!
        
        /// hex #B3E5FC
        public static let lightBlue100 = Color(hex: 0xB3E5FC)!
        
        /// hex #81D4FA
        public static let lightBlue200 = Color(hex: 0x81D4FA)!
        
        /// hex #4FC3F7
        public static let lightBlue300 = Color(hex: 0x4FC3F7)!
        
        /// hex #29B6F6
        public static let lightBlue400 = Color(hex: 0x29B6F6)!
        
        /// hex #03A9F4
        public static let lightBlue500 = Color(hex: 0x03A9F4)!
        
        /// hex #039BE5
        public static let lightBlue600 = Color(hex: 0x039BE5)!
        
        /// hex #0288D1
        public static let lightBlue700 = Color(hex: 0x0288D1)!
        
        /// hex #0277BD
        public static let lightBlue800 = Color(hex: 0x0277BD)!
        
        /// hex #01579B
        public static let lightBlue900 = Color(hex: 0x01579B)!
        
        /// hex #80D8FF
        public static let lightBlueA100 = Color(hex: 0x80D8FF)!
        
        /// hex #40C4FF
        public static let lightBlueA200 = Color(hex: 0x40C4FF)!
        
        /// hex #00B0FF
        public static let lightBlueA400 = Color(hex: 0x00B0FF)!
        
        /// hex #0091EA
        public static let lightBlueA700 = Color(hex: 0x0091EA)!
        
        /// color cyan500
        public static let cyan = cyan500
        
        /// hex #E0F7FA
        public static let cyan50 = Color(hex: 0xE0F7FA)!
        
        /// hex #B2EBF2
        public static let cyan100 = Color(hex: 0xB2EBF2)!
        
        /// hex #80DEEA
        public static let cyan200 = Color(hex: 0x80DEEA)!
        
        /// hex #4DD0E1
        public static let cyan300 = Color(hex: 0x4DD0E1)!
        
        /// hex #26C6DA
        public static let cyan400 = Color(hex: 0x26C6DA)!
        
        /// hex #00BCD4
        public static let cyan500 = Color(hex: 0x00BCD4)!
        
        /// hex #00ACC1
        public static let cyan600 = Color(hex: 0x00ACC1)!
        
        /// hex #0097A7
        public static let cyan700 = Color(hex: 0x0097A7)!
        
        /// hex #00838F
        public static let cyan800 = Color(hex: 0x00838F)!
        
        /// hex #006064
        public static let cyan900 = Color(hex: 0x006064)!
        
        /// hex #84FFFF
        public static let cyanA100 = Color(hex: 0x84FFFF)!
        
        /// hex #18FFFF
        public static let cyanA200 = Color(hex: 0x18FFFF)!
        
        /// hex #00E5FF
        public static let cyanA400 = Color(hex: 0x00E5FF)!
        
        /// hex #00B8D4
        public static let cyanA700 = Color(hex: 0x00B8D4)!
        
        /// color teal500
        public static let teal = teal500
        
        /// hex #E0F2F1
        public static let teal50 = Color(hex: 0xE0F2F1)!
        
        /// hex #B2DFDB
        public static let teal100 = Color(hex: 0xB2DFDB)!
        
        /// hex #80CBC4
        public static let teal200 = Color(hex: 0x80CBC4)!
        
        /// hex #4DB6AC
        public static let teal300 = Color(hex: 0x4DB6AC)!
        
        /// hex #26A69A
        public static let teal400 = Color(hex: 0x26A69A)!
        
        /// hex #009688
        public static let teal500 = Color(hex: 0x009688)!
        
        /// hex #00897B
        public static let teal600 = Color(hex: 0x00897B)!
        
        /// hex #00796B
        public static let teal700 = Color(hex: 0x00796B)!
        
        /// hex #00695C
        public static let teal800 = Color(hex: 0x00695C)!
        
        /// hex #004D40
        public static let teal900 = Color(hex: 0x004D40)!
        
        /// hex #A7FFEB
        public static let tealA100 = Color(hex: 0xA7FFEB)!
        
        /// hex #64FFDA
        public static let tealA200 = Color(hex: 0x64FFDA)!
        
        /// hex #1DE9B6
        public static let tealA400 = Color(hex: 0x1DE9B6)!
        
        /// hex #00BFA5
        public static let tealA700 = Color(hex: 0x00BFA5)!
        
        /// color green500
        public static let green = green500
        
        /// hex #E8F5E9
        public static let green50 = Color(hex: 0xE8F5E9)!
        
        /// hex #C8E6C9
        public static let green100 = Color(hex: 0xC8E6C9)!
        
        /// hex #A5D6A7
        public static let green200 = Color(hex: 0xA5D6A7)!
        
        /// hex #81C784
        public static let green300 = Color(hex: 0x81C784)!
        
        /// hex #66BB6A
        public static let green400 = Color(hex: 0x66BB6A)!
        
        /// hex #4CAF50
        public static let green500 = Color(hex: 0x4CAF50)!
        
        /// hex #43A047
        public static let green600 = Color(hex: 0x43A047)!
        
        /// hex #388E3C
        public static let green700 = Color(hex: 0x388E3C)!
        
        /// hex #2E7D32
        public static let green800 = Color(hex: 0x2E7D32)!
        
        /// hex #1B5E20
        public static let green900 = Color(hex: 0x1B5E20)!
        
        /// hex #B9F6CA
        public static let greenA100 = Color(hex: 0xB9F6CA)!
        
        /// hex #69F0AE
        public static let greenA200 = Color(hex: 0x69F0AE)!
        
        /// hex #00E676
        public static let greenA400 = Color(hex: 0x00E676)!
        
        /// hex #00C853
        public static let greenA700 = Color(hex: 0x00C853)!
        
        /// color lightGreen500
        public static let lightGreen = lightGreen500
        
        /// hex #F1F8E9
        public static let lightGreen50 = Color(hex: 0xF1F8E9)!
        
        /// hex #DCEDC8
        public static let lightGreen100 = Color(hex: 0xDCEDC8)!
        
        /// hex #C5E1A5
        public static let lightGreen200 = Color(hex: 0xC5E1A5)!
        
        /// hex #AED581
        public static let lightGreen300 = Color(hex: 0xAED581)!
        
        /// hex #9CCC65
        public static let lightGreen400 = Color(hex: 0x9CCC65)!
        
        /// hex #8BC34A
        public static let lightGreen500 = Color(hex: 0x8BC34A)!
        
        /// hex #7CB342
        public static let lightGreen600 = Color(hex: 0x7CB342)!
        
        /// hex #689F38
        public static let lightGreen700 = Color(hex: 0x689F38)!
        
        /// hex #558B2F
        public static let lightGreen800 = Color(hex: 0x558B2F)!
        
        /// hex #33691E
        public static let lightGreen900 = Color(hex: 0x33691E)!
        
        /// hex #CCFF90
        public static let lightGreenA100 = Color(hex: 0xCCFF90)!
        
        /// hex #B2FF59
        public static let lightGreenA200 = Color(hex: 0xB2FF59)!
        
        /// hex #76FF03
        public static let lightGreenA400 = Color(hex: 0x76FF03)!
        
        /// hex #64DD17
        public static let lightGreenA700 = Color(hex: 0x64DD17)!
        
        /// color lime500
        public static let lime = lime500
        
        /// hex #F9FBE7
        public static let lime50 = Color(hex: 0xF9FBE7)!
        
        /// hex #F0F4C3
        public static let lime100 = Color(hex: 0xF0F4C3)!
        
        /// hex #E6EE9C
        public static let lime200 = Color(hex: 0xE6EE9C)!
        
        /// hex #DCE775
        public static let lime300 = Color(hex: 0xDCE775)!
        
        /// hex #D4E157
        public static let lime400 = Color(hex: 0xD4E157)!
        
        /// hex #CDDC39
        public static let lime500 = Color(hex: 0xCDDC39)!
        
        /// hex #C0CA33
        public static let lime600 = Color(hex: 0xC0CA33)!
        
        /// hex #AFB42B
        public static let lime700 = Color(hex: 0xAFB42B)!
        
        /// hex #9E9D24
        public static let lime800 = Color(hex: 0x9E9D24)!
        
        /// hex #827717
        public static let lime900 = Color(hex: 0x827717)!
        
        /// hex #F4FF81
        public static let limeA100 = Color(hex: 0xF4FF81)!
        
        /// hex #EEFF41
        public static let limeA200 = Color(hex: 0xEEFF41)!
        
        /// hex #C6FF00
        public static let limeA400 = Color(hex: 0xC6FF00)!
        
        /// hex #AEEA00
        public static let limeA700 = Color(hex: 0xAEEA00)!
        
        /// color yellow500
        public static let yellow = yellow500
        
        /// hex #FFFDE7
        public static let yellow50 = Color(hex: 0xFFFDE7)!
        
        /// hex #FFF9C4
        public static let yellow100 = Color(hex: 0xFFF9C4)!
        
        /// hex #FFF59D
        public static let yellow200 = Color(hex: 0xFFF59D)!
        
        /// hex #FFF176
        public static let yellow300 = Color(hex: 0xFFF176)!
        
        /// hex #FFEE58
        public static let yellow400 = Color(hex: 0xFFEE58)!
        
        /// hex #FFEB3B
        public static let yellow500 = Color(hex: 0xFFEB3B)!
        
        /// hex #FDD835
        public static let yellow600 = Color(hex: 0xFDD835)!
        
        /// hex #FBC02D
        public static let yellow700 = Color(hex: 0xFBC02D)!
        
        /// hex #F9A825
        public static let yellow800 = Color(hex: 0xF9A825)!
        
        /// hex #F57F17
        public static let yellow900 = Color(hex: 0xF57F17)!
        
        /// hex #FFFF8D
        public static let yellowA100 = Color(hex: 0xFFFF8D)!
        
        /// hex #FFFF00
        public static let yellowA200 = Color(hex: 0xFFFF00)!
        
        /// hex #FFEA00
        public static let yellowA400 = Color(hex: 0xFFEA00)!
        
        /// hex #FFD600
        public static let yellowA700 = Color(hex: 0xFFD600)!
        
        /// color amber500
        public static let amber = amber500
        
        /// hex #FFF8E1
        public static let amber50 = Color(hex: 0xFFF8E1)!
        
        /// hex #FFECB3
        public static let amber100 = Color(hex: 0xFFECB3)!
        
        /// hex #FFE082
        public static let amber200 = Color(hex: 0xFFE082)!
        
        /// hex #FFD54F
        public static let amber300 = Color(hex: 0xFFD54F)!
        
        /// hex #FFCA28
        public static let amber400 = Color(hex: 0xFFCA28)!
        
        /// hex #FFC107
        public static let amber500 = Color(hex: 0xFFC107)!
        
        /// hex #FFB300
        public static let amber600 = Color(hex: 0xFFB300)!
        
        /// hex #FFA000
        public static let amber700 = Color(hex: 0xFFA000)!
        
        /// hex #FF8F00
        public static let amber800 = Color(hex: 0xFF8F00)!
        
        /// hex #FF6F00
        public static let amber900 = Color(hex: 0xFF6F00)!
        
        /// hex #FFE57F
        public static let amberA100 = Color(hex: 0xFFE57F)!
        
        /// hex #FFD740
        public static let amberA200 = Color(hex: 0xFFD740)!
        
        /// hex #FFC400
        public static let amberA400 = Color(hex: 0xFFC400)!
        
        /// hex #FFAB00
        public static let amberA700 = Color(hex: 0xFFAB00)!
        
        /// color orange500
        public static let orange = orange500
        
        /// hex #FFF3E0
        public static let orange50 = Color(hex: 0xFFF3E0)!
        
        /// hex #FFE0B2
        public static let orange100 = Color(hex: 0xFFE0B2)!
        
        /// hex #FFCC80
        public static let orange200 = Color(hex: 0xFFCC80)!
        
        /// hex #FFB74D
        public static let orange300 = Color(hex: 0xFFB74D)!
        
        /// hex #FFA726
        public static let orange400 = Color(hex: 0xFFA726)!
        
        /// hex #FF9800
        public static let orange500 = Color(hex: 0xFF9800)!
        
        /// hex #FB8C00
        public static let orange600 = Color(hex: 0xFB8C00)!
        
        /// hex #F57C00
        public static let orange700 = Color(hex: 0xF57C00)!
        
        /// hex #EF6C00
        public static let orange800 = Color(hex: 0xEF6C00)!
        
        /// hex #E65100
        public static let orange900 = Color(hex: 0xE65100)!
        
        /// hex #FFD180
        public static let orangeA100 = Color(hex: 0xFFD180)!
        
        /// hex #FFAB40
        public static let orangeA200 = Color(hex: 0xFFAB40)!
        
        /// hex #FF9100
        public static let orangeA400 = Color(hex: 0xFF9100)!
        
        /// hex #FF6D00
        public static let orangeA700 = Color(hex: 0xFF6D00)!
        
        /// color deepOrange500
        public static let deepOrange = deepOrange500
        
        /// hex #FBE9E7
        public static let deepOrange50 = Color(hex: 0xFBE9E7)!
        
        /// hex #FFCCBC
        public static let deepOrange100 = Color(hex: 0xFFCCBC)!
        
        /// hex #FFAB91
        public static let deepOrange200 = Color(hex: 0xFFAB91)!
        
        /// hex #FF8A65
        public static let deepOrange300 = Color(hex: 0xFF8A65)!
        
        /// hex #FF7043
        public static let deepOrange400 = Color(hex: 0xFF7043)!
        
        /// hex #FF5722
        public static let deepOrange500 = Color(hex: 0xFF5722)!
        
        /// hex #F4511E
        public static let deepOrange600 = Color(hex: 0xF4511E)!
        
        /// hex #E64A19
        public static let deepOrange700 = Color(hex: 0xE64A19)!
        
        /// hex #D84315
        public static let deepOrange800 = Color(hex: 0xD84315)!
        
        /// hex #BF360C
        public static let deepOrange900 = Color(hex: 0xBF360C)!
        
        /// hex #FF9E80
        public static let deepOrangeA100 = Color(hex: 0xFF9E80)!
        
        /// hex #FF6E40
        public static let deepOrangeA200 = Color(hex: 0xFF6E40)!
        
        /// hex #FF3D00
        public static let deepOrangeA400 = Color(hex: 0xFF3D00)!
        
        /// hex #DD2C00
        public static let deepOrangeA700 = Color(hex: 0xDD2C00)!
        
        /// color brown500
        public static let brown = brown500
        
        /// hex #EFEBE9
        public static let brown50 = Color(hex: 0xEFEBE9)!
        
        /// hex #D7CCC8
        public static let brown100 = Color(hex: 0xD7CCC8)!
        
        /// hex #BCAAA4
        public static let brown200 = Color(hex: 0xBCAAA4)!
        
        /// hex #A1887F
        public static let brown300 = Color(hex: 0xA1887F)!
        
        /// hex #8D6E63
        public static let brown400 = Color(hex: 0x8D6E63)!
        
        /// hex #795548
        public static let brown500 = Color(hex: 0x795548)!
        
        /// hex #6D4C41
        public static let brown600 = Color(hex: 0x6D4C41)!
        
        /// hex #5D4037
        public static let brown700 = Color(hex: 0x5D4037)!
        
        /// hex #4E342E
        public static let brown800 = Color(hex: 0x4E342E)!
        
        /// hex #3E2723
        public static let brown900 = Color(hex: 0x3E2723)!
        
        /// color grey500
        public static let grey = grey500
        
        /// hex #FAFAFA
        public static let grey50 = Color(hex: 0xFAFAFA)!
        
        /// hex #F5F5F5
        public static let grey100 = Color(hex: 0xF5F5F5)!
        
        /// hex #EEEEEE
        public static let grey200 = Color(hex: 0xEEEEEE)!
        
        /// hex #E0E0E0
        public static let grey300 = Color(hex: 0xE0E0E0)!
        
        /// hex #BDBDBD
        public static let grey400 = Color(hex: 0xBDBDBD)!
        
        /// hex #9E9E9E
        public static let grey500 = Color(hex: 0x9E9E9E)!
        
        /// hex #757575
        public static let grey600 = Color(hex: 0x757575)!
        
        /// hex #616161
        public static let grey700 = Color(hex: 0x616161)!
        
        /// hex #424242
        public static let grey800 = Color(hex: 0x424242)!
        
        /// hex #212121
        public static let grey900 = Color(hex: 0x212121)!
        
        /// color blueGrey500
        public static let blueGrey = blueGrey500
        
        /// hex #ECEFF1
        public static let blueGrey50 = Color(hex: 0xECEFF1)!
        
        /// hex #CFD8DC
        public static let blueGrey100 = Color(hex: 0xCFD8DC)!
        
        /// hex #B0BEC5
        public static let blueGrey200 = Color(hex: 0xB0BEC5)!
        
        /// hex #90A4AE
        public static let blueGrey300 = Color(hex: 0x90A4AE)!
        
        /// hex #78909C
        public static let blueGrey400 = Color(hex: 0x78909C)!
        
        /// hex #607D8B
        public static let blueGrey500 = Color(hex: 0x607D8B)!
        
        /// hex #546E7A
        public static let blueGrey600 = Color(hex: 0x546E7A)!
        
        /// hex #455A64
        public static let blueGrey700 = Color(hex: 0x455A64)!
        
        /// hex #37474F
        public static let blueGrey800 = Color(hex: 0x37474F)!
        
        /// hex #263238
        public static let blueGrey900 = Color(hex: 0x263238)!
        
        /// hex #000000
        public static let black = Color(hex: 0x000000)!
        
        /// hex #FFFFFF
        public static let white = Color(hex: 0xFFFFFF)!
    }
    
}

// MARK: - CSS colors
public extension Color {
    
    /// CSS colors.
    struct CSS {
        // http://www.w3schools.com/colors/colors_names.asp
        private init() {}
        
        /// hex #F0F8FF
        public static let aliceBlue = Color(hex: 0xF0F8FF)!
        
        /// hex #FAEBD7
        public static let antiqueWhite = Color(hex: 0xFAEBD7)!
        
        /// hex #00FFFF
        public static let aqua = Color(hex: 0x00FFFF)!
        
        /// hex #7FFFD4
        public static let aquamarine = Color(hex: 0x7FFFD4)!
        
        /// hex #F0FFFF
        public static let azure = Color(hex: 0xF0FFFF)!
        
        /// hex #F5F5DC
        public static let beige = Color(hex: 0xF5F5DC)!
        
        /// hex #FFE4C4
        public static let bisque = Color(hex: 0xFFE4C4)!
        
        /// hex #000000
        public static let black = Color(hex: 0x000000)!
        
        /// hex #FFEBCD
        public static let blanchedAlmond = Color(hex: 0xFFEBCD)!
        
        /// hex #0000FF
        public static let blue = Color(hex: 0x0000FF)!
        
        /// hex #8A2BE2
        public static let blueViolet = Color(hex: 0x8A2BE2)!
        
        /// hex #A52A2A
        public static let brown = Color(hex: 0xA52A2A)!
        
        /// hex #DEB887
        public static let burlyWood = Color(hex: 0xDEB887)!
        
        /// hex #5F9EA0
        public static let cadetBlue = Color(hex: 0x5F9EA0)!
        
        /// hex #7FFF00
        public static let chartreuse = Color(hex: 0x7FFF00)!
        
        /// hex #D2691E
        public static let chocolate = Color(hex: 0xD2691E)!
        
        /// hex #FF7F50
        public static let coral = Color(hex: 0xFF7F50)!
        
        /// hex #6495ED
        public static let cornflowerBlue = Color(hex: 0x6495ED)!
        
        /// hex #FFF8DC
        public static let cornsilk = Color(hex: 0xFFF8DC)!
        
        /// hex #DC143C
        public static let crimson = Color(hex: 0xDC143C)!
        
        /// hex #00FFFF
        public static let cyan = Color(hex: 0x00FFFF)!
        
        /// hex #00008B
        public static let darkBlue = Color(hex: 0x00008B)!
        
        /// hex #008B8B
        public static let darkCyan = Color(hex: 0x008B8B)!
        
        /// hex #B8860B
        public static let darkGoldenRod = Color(hex: 0xB8860B)!
        
        /// hex #A9A9A9
        public static let darkGray = Color(hex: 0xA9A9A9)!
        
        /// hex #A9A9A9
        public static let darkGrey = Color(hex: 0xA9A9A9)!
        
        /// hex #006400
        public static let darkGreen = Color(hex: 0x006400)!
        
        /// hex #BDB76B
        public static let darkKhaki = Color(hex: 0xBDB76B)!
        
        /// hex #8B008B
        public static let darkMagenta = Color(hex: 0x8B008B)!
        
        /// hex #556B2F
        public static let darkOliveGreen = Color(hex: 0x556B2F)!
        
        /// hex #FF8C00
        public static let darkOrange = Color(hex: 0xFF8C00)!
        
        /// hex #9932CC
        public static let darkOrchid = Color(hex: 0x9932CC)!
        
        /// hex #8B0000
        public static let darkRed = Color(hex: 0x8B0000)!
        
        /// hex #E9967A
        public static let darkSalmon = Color(hex: 0xE9967A)!
        
        /// hex #8FBC8F
        public static let darkSeaGreen = Color(hex: 0x8FBC8F)!
        
        /// hex #483D8B
        public static let darkSlateBlue = Color(hex: 0x483D8B)!
        
        /// hex #2F4F4F
        public static let darkSlateGray = Color(hex: 0x2F4F4F)!
        
        /// hex #2F4F4F
        public static let darkSlateGrey = Color(hex: 0x2F4F4F)!
        
        /// hex #00CED1
        public static let darkTurquoise = Color(hex: 0x00CED1)!
        
        /// hex #9400D3
        public static let darkViolet = Color(hex: 0x9400D3)!
        
        /// hex #FF1493
        public static let deepPink = Color(hex: 0xFF1493)!
        
        /// hex #00BFFF
        public static let deepSkyBlue = Color(hex: 0x00BFFF)!
        
        /// hex #696969
        public static let dimGray = Color(hex: 0x696969)!
        
        /// hex #696969
        public static let dimGrey = Color(hex: 0x696969)!
        
        /// hex #1E90FF
        public static let dodgerBlue = Color(hex: 0x1E90FF)!
        
        /// hex #B22222
        public static let fireBrick = Color(hex: 0xB22222)!
        
        /// hex #FFFAF0
        public static let floralWhite = Color(hex: 0xFFFAF0)!
        
        /// hex #228B22
        public static let forestGreen = Color(hex: 0x228B22)!
        
        /// hex #FF00FF
        public static let fuchsia = Color(hex: 0xFF00FF)!
        
        /// hex #DCDCDC
        public static let gainsboro = Color(hex: 0xDCDCDC)!
        
        /// hex #F8F8FF
        public static let ghostWhite = Color(hex: 0xF8F8FF)!
        
        /// hex #FFD700
        public static let gold = Color(hex: 0xFFD700)!
        
        /// hex #DAA520
        public static let goldenRod = Color(hex: 0xDAA520)!
        
        /// hex #808080
        public static let gray = Color(hex: 0x808080)!
        
        /// hex #808080
        public static let grey = Color(hex: 0x808080)!
        
        /// hex #008000
        public static let green = Color(hex: 0x008000)!
        
        /// hex #ADFF2F
        public static let greenYellow = Color(hex: 0xADFF2F)!
        
        /// hex #F0FFF0
        public static let honeyDew = Color(hex: 0xF0FFF0)!
        
        /// hex #FF69B4
        public static let hotPink = Color(hex: 0xFF69B4)!
        
        /// hex #CD5C5C
        public static let indianRed = Color(hex: 0xCD5C5C)!
        
        /// hex #4B0082
        public static let indigo = Color(hex: 0x4B0082)!
        
        /// hex #FFFFF0
        public static let ivory = Color(hex: 0xFFFFF0)!
        
        /// hex #F0E68C
        public static let khaki = Color(hex: 0xF0E68C)!
        
        /// hex #E6E6FA
        public static let lavender = Color(hex: 0xE6E6FA)!
        
        /// hex #FFF0F5
        public static let lavenderBlush = Color(hex: 0xFFF0F5)!
        
        /// hex #7CFC00
        public static let lawnGreen = Color(hex: 0x7CFC00)!
        
        /// hex #FFFACD
        public static let lemonChiffon = Color(hex: 0xFFFACD)!
        
        /// hex #ADD8E6
        public static let lightBlue = Color(hex: 0xADD8E6)!
        
        /// hex #F08080
        public static let lightCoral = Color(hex: 0xF08080)!
        
        /// hex #E0FFFF
        public static let lightCyan = Color(hex: 0xE0FFFF)!
        
        /// hex #FAFAD2
        public static let lightGoldenRodYellow = Color(hex: 0xFAFAD2)!
        
        /// hex #D3D3D3
        public static let lightGray = Color(hex: 0xD3D3D3)!
        
        /// hex #D3D3D3
        public static let lightGrey = Color(hex: 0xD3D3D3)!
        
        /// hex #90EE90
        public static let lightGreen = Color(hex: 0x90EE90)!
        
        /// hex #FFB6C1
        public static let lightPink = Color(hex: 0xFFB6C1)!
        
        /// hex #FFA07A
        public static let lightSalmon = Color(hex: 0xFFA07A)!
        
        /// hex #20B2AA
        public static let lightSeaGreen = Color(hex: 0x20B2AA)!
        
        /// hex #87CEFA
        public static let lightSkyBlue = Color(hex: 0x87CEFA)!
        
        /// hex #778899
        public static let lightSlateGray = Color(hex: 0x778899)!
        
        /// hex #778899
        public static let lightSlateGrey = Color(hex: 0x778899)!
        
        /// hex #B0C4DE
        public static let lightSteelBlue = Color(hex: 0xB0C4DE)!
        
        /// hex #FFFFE0
        public static let lightYellow = Color(hex: 0xFFFFE0)!
        
        /// hex #00FF00
        public static let lime = Color(hex: 0x00FF00)!
        
        /// hex #32CD32
        public static let limeGreen = Color(hex: 0x32CD32)!
        
        /// hex #FAF0E6
        public static let linen = Color(hex: 0xFAF0E6)!
        
        /// hex #FF00FF
        public static let magenta = Color(hex: 0xFF00FF)!
        
        /// hex #800000
        public static let maroon = Color(hex: 0x800000)!
        
        /// hex #66CDAA
        public static let mediumAquaMarine = Color(hex: 0x66CDAA)!
        
        /// hex #0000CD
        public static let mediumBlue = Color(hex: 0x0000CD)!
        
        /// hex #BA55D3
        public static let mediumOrchid = Color(hex: 0xBA55D3)!
        
        /// hex #9370DB
        public static let mediumPurple = Color(hex: 0x9370DB)!
        
        /// hex #3CB371
        public static let mediumSeaGreen = Color(hex: 0x3CB371)!
        
        /// hex #7B68EE
        public static let mediumSlateBlue = Color(hex: 0x7B68EE)!
        
        /// hex #00FA9A
        public static let mediumSpringGreen = Color(hex: 0x00FA9A)!
        
        /// hex #48D1CC
        public static let mediumTurquoise = Color(hex: 0x48D1CC)!
        
        /// hex #C71585
        public static let mediumVioletRed = Color(hex: 0xC71585)!
        
        /// hex #191970
        public static let midnightBlue = Color(hex: 0x191970)!
        
        /// hex #F5FFFA
        public static let mintCream = Color(hex: 0xF5FFFA)!
        
        /// hex #FFE4E1
        public static let mistyRose = Color(hex: 0xFFE4E1)!
        
        /// hex #FFE4B5
        public static let moccasin = Color(hex: 0xFFE4B5)!
        
        /// hex #FFDEAD
        public static let navajoWhite = Color(hex: 0xFFDEAD)!
        
        /// hex #000080
        public static let navy = Color(hex: 0x000080)!
        
        /// hex #FDF5E6
        public static let oldLace = Color(hex: 0xFDF5E6)!
        
        /// hex #808000
        public static let olive = Color(hex: 0x808000)!
        
        /// hex #6B8E23
        public static let oliveDrab = Color(hex: 0x6B8E23)!
        
        /// hex #FFA500
        public static let orange = Color(hex: 0xFFA500)!
        
        /// hex #FF4500
        public static let orangeRed = Color(hex: 0xFF4500)!
        
        /// hex #DA70D6
        public static let orchid = Color(hex: 0xDA70D6)!
        
        /// hex #EEE8AA
        public static let paleGoldenRod = Color(hex: 0xEEE8AA)!
        
        /// hex #98FB98
        public static let paleGreen = Color(hex: 0x98FB98)!
        
        /// hex #AFEEEE
        public static let paleTurquoise = Color(hex: 0xAFEEEE)!
        
        /// hex #DB7093
        public static let paleVioletRed = Color(hex: 0xDB7093)!
        
        /// hex #FFEFD5
        public static let papayaWhip = Color(hex: 0xFFEFD5)!
        
        /// hex #FFDAB9
        public static let peachPuff = Color(hex: 0xFFDAB9)!
        
        /// hex #CD853F
        public static let peru = Color(hex: 0xCD853F)!
        
        /// hex #FFC0CB
        public static let pink = Color(hex: 0xFFC0CB)!
        
        /// hex #DDA0DD
        public static let plum = Color(hex: 0xDDA0DD)!
        
        /// hex #B0E0E6
        public static let powderBlue = Color(hex: 0xB0E0E6)!
        
        /// hex #800080
        public static let purple = Color(hex: 0x800080)!
        
        /// hex #663399
        public static let rebeccaPurple = Color(hex: 0x663399)!
        
        /// hex #FF0000
        public static let red = Color(hex: 0xFF0000)!
        
        /// hex #BC8F8F
        public static let rosyBrown = Color(hex: 0xBC8F8F)!
        
        /// hex #4169E1
        public static let royalBlue = Color(hex: 0x4169E1)!
        
        /// hex #8B4513
        public static let saddleBrown = Color(hex: 0x8B4513)!
        
        /// hex #FA8072
        public static let salmon = Color(hex: 0xFA8072)!
        
        /// hex #F4A460
        public static let sandyBrown = Color(hex: 0xF4A460)!
        
        /// hex #2E8B57
        public static let seaGreen = Color(hex: 0x2E8B57)!
        
        /// hex #FFF5EE
        public static let seaShell = Color(hex: 0xFFF5EE)!
        
        /// hex #A0522D
        public static let sienna = Color(hex: 0xA0522D)!
        
        /// hex #C0C0C0
        public static let silver = Color(hex: 0xC0C0C0)!
        
        /// hex #87CEEB
        public static let skyBlue = Color(hex: 0x87CEEB)!
        
        /// hex #6A5ACD
        public static let slateBlue = Color(hex: 0x6A5ACD)!
        
        /// hex #708090
        public static let slateGray = Color(hex: 0x708090)!
        
        /// hex #708090
        public static let slateGrey = Color(hex: 0x708090)!
        
        /// hex #FFFAFA
        public static let snow = Color(hex: 0xFFFAFA)!
        
        /// hex #00FF7F
        public static let springGreen = Color(hex: 0x00FF7F)!
        
        /// hex #4682B4
        public static let steelBlue = Color(hex: 0x4682B4)!
        
        /// hex #D2B48C
        public static let tan = Color(hex: 0xD2B48C)!
        
        /// hex #008080
        public static let teal = Color(hex: 0x008080)!
        
        /// hex #D8BFD8
        public static let thistle = Color(hex: 0xD8BFD8)!
        
        /// hex #FF6347
        public static let tomato = Color(hex: 0xFF6347)!
        
        /// hex #40E0D0
        public static let turquoise = Color(hex: 0x40E0D0)!
        
        /// hex #EE82EE
        public static let violet = Color(hex: 0xEE82EE)!
        
        /// hex #F5DEB3
        public static let wheat = Color(hex: 0xF5DEB3)!
        
        /// hex #FFFFFF
        public static let white = Color(hex: 0xFFFFFF)!
        
        /// hex #F5F5F5
        public static let whiteSmoke = Color(hex: 0xF5F5F5)!
        
        /// hex #FFFF00
        public static let yellow = Color(hex: 0xFFFF00)!
        
        /// hex #9ACD32
        public static let yellowGreen = Color(hex: 0x9ACD32)!
    }
    
}

// MARK: - Flat UI colors
public extension Color {
    
    /// Flat UI colors
    struct FlatUI {
        // http://flatuicolors.com.
        /// hex #1ABC9C
        public static let turquoise = Color(hex: 0x1abc9c)!
        
        /// hex #16A085
        public static let greenSea = Color(hex: 0x16a085)!
        
        /// hex #2ECC71
        public static let emerald = Color(hex: 0x2ecc71)!
        
        /// hex #27AE60
        public static let nephritis = Color(hex: 0x27ae60)!
        
        /// hex #3498DB
        public static let peterRiver = Color(hex: 0x3498db)!
        
        /// hex #2980B9
        public static let belizeHole = Color(hex: 0x2980b9)!
        
        /// hex #9B59B6
        public static let amethyst = Color(hex: 0x9b59b6)!
        
        /// hex #8E44AD
        public static let wisteria = Color(hex: 0x8e44ad)!
        
        /// hex #34495E
        public static let wetAsphalt = Color(hex: 0x34495e)!
        
        /// hex #2C3E50
        public static let midnightBlue = Color(hex: 0x2c3e50)!
        
        /// hex #F1C40F
        public static let sunFlower = Color(hex: 0xf1c40f)!
        
        /// hex #F39C12
        public static let flatOrange = Color(hex: 0xf39c12)!
        
        /// hex #E67E22
        public static let carrot = Color(hex: 0xe67e22)!
        
        /// hex #D35400
        public static let pumkin = Color(hex: 0xd35400)!
        
        /// hex #E74C3C
        public static let alizarin = Color(hex: 0xe74c3c)!
        
        /// hex #C0392B
        public static let pomegranate = Color(hex: 0xc0392b)!
        
        /// hex #ECF0F1
        public static let clouds = Color(hex: 0xecf0f1)!
        
        /// hex #BDC3C7
        public static let silver = Color(hex: 0xbdc3c7)!
        
        /// hex #7F8C8D
        public static let asbestos = Color(hex: 0x7f8c8d)!
        
        /// hex #95A5A6
        public static let concerte = Color(hex: 0x95a5a6)!
    }
    // swiftlint:enable type_body_length
}
#endif
