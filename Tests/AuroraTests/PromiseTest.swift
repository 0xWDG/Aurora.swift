// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

#if !os(watchOS)
import Foundation

import XCTest

@testable import Aurora

extension AuroraTest {
    /// Run after
    /// - Parameters:
    ///   - timeInterval: interfal
    ///   - work: workish
    func after(_ timeInterval: TimeInterval = 0.1, work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: work)
    }
    
    struct User {
        let userID: Int
        let name: String
    }
    
    func fetchIds() -> Promise<[Int]> {
        return Promise { xxx in
            xxx([0, 1, 2])
        }
    }
    
    func fetchUser(userID: Int) -> Promise<User> {
        return Promise { resolve in
        after(0.1) {
            resolve(User.init(userID: 0, name: "Aurora Framework"))
            }
        }
    }
    
    func testBasicPromise() {
        fetchIds().then { ids in // flatMap
                return self.fetchUser(userID: ids[0])
        }.then { user in // map
            return user.name
        }.then { name in // observe
            print(name)
            XCTAssertNotNil(name)
        }
    }
}
#endif
