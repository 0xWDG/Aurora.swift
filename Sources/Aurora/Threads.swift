// $$HEADER$$

import Foundation

infix operator ~>   // serial queue operator
/**
 Executes the lefthand closure on a background thread and,
 upon completion, the righthand closure on the main thread.
 Passes the background closure's output to the main closure.
 */
func ~> (
    backgroundClosure: @escaping () -> (),
    mainClosure:       @escaping () -> ())
{
    serial_queue.async {
        backgroundClosure()
        DispatchQueue.main.async {
            mainClosure()
        }
    }
}
func ~> <R> (
    backgroundClosure:   @escaping () -> R,
    mainClosure:         @escaping (_ result: R) -> ())
{
    serial_queue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}
func ~> (
    backgroundClosure:   @escaping () -> String,
    mainClosure:         @escaping (_ result: String) -> ())
{
    serial_queue.async {
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
private let serial_queue = DispatchQueue(label: "serial-worker")

public extension Aurora {
    func runInBackground(block: @escaping () -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            block()
        }
    }
    
    func runInForeground(block: @escaping () -> Void) -> Void {
        DispatchQueue.main.async(execute: {
            block()
        })
    }
    
    func run(background: @escaping () -> String, foreground: @escaping (_ returning: String) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let _result = background()
        
            DispatchQueue.main.async(execute: {
                foreground(_result)
                
            })
        }
    }
    
     func run(background: @escaping () -> Bool, foreground: @escaping (_ returning: Bool) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let _result = background()
            
            DispatchQueue.main.async(execute: {
                foreground(_result)
                
            })
        }
    }
    
    func run(background: @escaping () -> Any, foreground: @escaping (_ returning: Any) -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            let _result = background()
            
            DispatchQueue.main.async(execute: {
                foreground(_result)
                
            })
        }
    }

}
