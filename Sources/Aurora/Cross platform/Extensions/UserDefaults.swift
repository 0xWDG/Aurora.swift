//
//  File.swift
//  
//
//  Created by Wesley de Groot on 01/04/2020.
//

import Foundation

public extension UserDefaults {
    @nonobjc subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
    
    @nonobjc subscript(key: String) -> Bool {
        get {
            return bool(forKey: key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
}
