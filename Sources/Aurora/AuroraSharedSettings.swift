//
//  File.swift
//  
//
//  Created by Wesley de Groot on 05/02/2021.
//

import Foundation

open class AuroraStaticSettings {
    static let shared = AuroraStaticSettings()
    
    private var dynamicSettings: [String: Any] = [:]

    public func get(_ forKey: String) -> String? {
        if let unwrapped = dynamicSettings[forKey] as? String {
            return unwrapped
        }
        
        return nil
    }
    
    public func get(_ forKey: String) -> Bool? {
        if let unwrapped = dynamicSettings[forKey] as? Bool {
            return unwrapped
        }
        
        return nil
    }
    
    public func get(_ forKey: String) -> Int? {
        if let unwrapped = dynamicSettings[forKey] as? Int {
            return unwrapped
        }
        
        return nil
    }
    
    public func get(_ forKey: String) -> Double? {
        if let unwrapped = dynamicSettings[forKey] as? Double {
            return unwrapped
        }
        
        return nil
    }
    
    public func get(_ forKey: String) -> Float? {
        if let unwrapped = dynamicSettings[forKey] as? Float {
            return unwrapped
        }
        
        return nil
    }
    
    public func get(_ forKey: String) -> Any? {
        if let unwrapped = dynamicSettings[forKey] {
            return unwrapped
        }
        
        return nil
    }
    
    public func set(_ forKey: String, value: Any) {
        dynamicSettings[forKey] = value
    }
}
