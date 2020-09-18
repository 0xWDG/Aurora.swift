//
//  File 2.swift
//  
//
//  Created by Wesley de Groot on 08/05/2020.
//

import Foundation

import XCTest

@testable import Aurora

extension AuroraTest {
    /// <#Description#>
    /// - Parameters:
    ///   - timeInterval: <#timeInterval description#>
    ///   - work: <#work description#>
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
