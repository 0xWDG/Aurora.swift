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

import Foundation

public extension UserDefaults {
    /// Subscript from UserDefaults (Any)
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
    
    /// Subscript from UserDefaults (Bool)
    subscript(key: String) -> Bool {
        get {
            return bool(forKey: key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
    
    /// Remove all the keys and their values stored in the user's defaults database.
    func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}
