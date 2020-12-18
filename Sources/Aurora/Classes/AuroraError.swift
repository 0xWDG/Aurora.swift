//
//  AuroraError.swift
//  Aurora
//
//  Created by Wesley de Groot on 18/12/2020.
//

import Foundation

/// <#Description#>
struct AuroraError {
    /// <#Description#>
    let message: String
    
    /// <#Description#>
    /// - Parameter message: <#message description#>
    init(message: String) {
        self.message = message
    }
}

extension AuroraError: LocalizedError {
    /// the Error description
    var errorDescription: String? { return message }
    
    /// <#Description#>
    var failureReason: String? { return message }
    
    /// <#Description#>
    var recoverySuggestion: String? { return message }
    
    /// <#Description#>
    var helpAnchor: String? { return message }
}
