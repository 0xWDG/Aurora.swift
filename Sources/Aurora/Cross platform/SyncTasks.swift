// $$HEADER$$

import Foundation

extension Aurora {
 public func run(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }

    public func execute(main: @escaping () -> Void) {
        DispatchQueue.main.async {
            main()
        }
    }
    
    public func execute(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }

    public func delay(_ after: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    public func execute(_ after: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
