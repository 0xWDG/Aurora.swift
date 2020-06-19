//
//  Float.swift
//  Aurora
//
//  Created by Wesley de Groot on 19/06/2020.
//

import Foundation

public extension Float {
    /// Converts float value to a positive one, if not already
    var toPositive: Float {
        return fabsf(self)
    }
}
