//
//  Double.swift
//  Aurora
//
//  Created by Wesley de Groot on 19/06/2020.
//

import Foundation

public extension Double {
    var toPositive: Double {
        return fabs(self)
    }
}
