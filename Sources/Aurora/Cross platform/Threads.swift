// $$HEADER$$

import Foundation

infix operator ~>   // serial queue operator
/**
 Executes the lefthand closure on a background thread and,
 upon completion, the righthand closure on the main thread.
 Passes the background closure's output to the main closure.
 */
public func ~> (
    backgroundClosure: @escaping () -> Void,
    mainClosure:       @escaping () -> Void)
{
    serialQueue.async {
        backgroundClosure()
        DispatchQueue.main.async {
            mainClosure()
        }
    }
}
public func ~> <R> (
    backgroundClosure:   @escaping () -> R,
    mainClosure:         @escaping (_ result: R) -> ())
{
    serialQueue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}
public func ~> (
    backgroundClosure:   @escaping () -> String,
    mainClosure:         @escaping (_ result: String) -> ())
{
    serialQueue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}
//func ~> <R, T> (
//    backgroundClosure: @escaping () -> (R, T),
//    mainClosure:       @escaping ((R, T)) -> ())
//{
//    serial_queue.async {
//        let (a, b) = backgroundClosure()
//        DispatchQueue.main.async {
//            mainClosure(a, b)
//        }
//    }
//}

/** Serial dispatch queue used by the ~> operator. */
private let serialQueue = DispatchQueue(label: "serial-worker")

extension Aurora {
    public func runInBackground(block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            block()
        }
    }
    
    public func runInForeground(block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    public func run(background: @escaping () -> String, foreground: @escaping (_ returning: String) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let result = background()
        
            DispatchQueue.main.async(execute: {
                foreground(result)
            })
        }
    }
    
     public func run(background: @escaping () -> Bool, foreground: @escaping (_ returning: Bool) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let result = background()
            
            DispatchQueue.main.async {
                foreground(result)
                
            }
        }
    }
    
    public func run(background: @escaping () -> Any, foreground: @escaping (_ returning: Any) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let result = background()
            
            DispatchQueue.main.async {
                foreground(result)
            }
        }
    }
}
