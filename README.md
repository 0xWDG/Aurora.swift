# Aurora.swift
Aurora Framework for Swift

[![Swift](https://github.com/AuroraFramework/Aurora.swift/workflows/Swift/badge.svg)](https://github.com/AuroraFramework/Aurora.swift/actions)

[Documentation](https://auroraframework.github.io/Aurora.swift/) | [DEV Branch](https://github.com/wdg/Aurora.swift)

---

Last update: 07-SEP-2021

---

[Built-in functions](https://auroraframework.github.io/Aurora.swift)
 
 ---
 
 @IBDesignable views.
 
 To use them create a proxy, since SwiftPM does not support @IBDesignables in Frameworks.
 
 ```swift
 @IBDesignable class UIGradientViewProxy: UIGradientView {}
 @IBDesignable class UIViewRoundedProxy: UIViewRounded {}
 @IBDesignable class UIGradientViewProxy: UIGradientView {}
 ```
