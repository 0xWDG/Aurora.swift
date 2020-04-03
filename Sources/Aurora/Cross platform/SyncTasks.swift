// $$HEADER$$

import Foundation

extension Aurora {
 public func run(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }

    public func runOn(main: @escaping ()->()) {
        DispatchQueue.main.async {
            main()
        }
    }
    
    public func runOn(background: @escaping ()->()) {
        DispatchQueue.global().async {
            background()
        }
    }
    public func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
