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
    struct User {
        let userID: Int
        let name: String
    }

    func fetchIds() -> Promise<[Int]> {
        return Promise { xxx in
            print("Return 0, 1, 2")
            xxx([0, 1, 2])
        }
    }

    func fetchUser(userID: Int) -> Promise<User> {
        return Promise { resolve in
            resolve(User.init(userID: 0, name: "Fake User"))
        }
    }

    func testBasicPromise() {
        fetchIds().then { ids in // flatMap
                return self.fetchUser(userID: ids[0])
        }.then { user in // map
            return user.name
        }.then { name in // observe
            Aurora.shared.log("name=\(name)")
            XCTAssertNotNil(name)
        }
    }
}
#endif
