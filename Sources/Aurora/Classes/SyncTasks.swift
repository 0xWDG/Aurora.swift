// $$HEADER$$

import Foundation

extension Aurora {
    /// <#Description#>
    /// - Parameter background: <#background description#>
    public func run(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }
    
    /// <#Description#>
    /// - Parameter main: <#main description#>
    public func execute(main: @escaping () -> Void) {
        DispatchQueue.main.async {
            main()
        }
    }
    
    /// <#Description#>
    /// - Parameter background: <#background description#>
    public func execute(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - after: <#after description#>
    ///   - closure: <#closure description#>
    public func delay(_ after: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - after: <#after description#>
    ///   - closure: <#closure description#>
    public func execute(_ after: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
