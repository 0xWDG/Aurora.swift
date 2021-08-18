// $$HEADER$$

#if canImport(UIKit)

import UIKit

/// A property wrapper arround UIColor to support dark mode.
///
/// By default in iOS >= 13 it uses the new system wide user interface style trait and dynamic
/// UIColor constructor to support dark mode without any extra effort.
/// On prior iOS versions it defaults to light.
/// ```
/// @DynamicUIColor(light: .white, dark: .black)
/// var backgroundColor: UIColor
///
/// // The color will automatically update when traits change
/// view.backgroundColor = backgroundColor
/// ```
///
/// To support older iOS versions  and custom logics (e.g. a switch in your app settings) the
/// constructor can take an extra `style` closure that dynamically dictates which
/// color to use. Returning a `nil` value results in the prior default behaviour. This logic
/// allows easier backwards compatiblity by doing:
/// ```
/// let color = DynamicUIColor(light: .white, dark: .black) {
///     if #available(iOS 13.0, *) { return nil }
///     else { return Settings.isDarkMode ? .dark : .light }
/// }
///
/// view.backgroundColor = color.value
///
/// // On iOS <13 you might need to manually observe your custom dark
/// // mode settings & re-bind your colors on changes:
/// if #available(iOS 13.0, *) {} else {
///     Settings.onDarkModeChange { [weak self] in
///         self?.view.backgroundColor = self?.color.value
///     }
/// }
/// ```
///
/// [Courtesy of @bardonadam](https://twitter.com/bardonadam)
/// Editted by Wesley de groot, removed pre-ios 13 stuff.
@propertyWrapper
public struct DynamicUIColor {

    /// Backwards compatible wrapper arround UIUserInterfaceStyle
    public enum Style {
        /// Light color
        case light
        /// Dark color
        case dark
    }

    let light: UIColor
    let dark: UIColor

    /// A property wrapper arround UIColor to support dark mode.
    /// - Parameters:
    ///   - light: color when using an light interface
    ///   - dark: color when using an dark interface
    public init(
        light: UIColor,
        dark: UIColor
    ) {
        self.light = light
        self.dark = dark
    }

    /// wrapped Color
    public var wrappedValue: UIColor {
        #if os(iOS) || os(tvOS)
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return self.dark
                case .light, .unspecified:
                    return self.light
                @unknown default:
                    return self.light
                }
            }
        } else {
            return light
        }
        #else
        return light
        #endif
    }
}

#endif
