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
    func after(_ timeInterval: TimeInterval = 0.1, work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: work)
    }
    
    struct User {
        let id: Int
        let name: String
    }
    
    func fetchIds() -> Promise<[Int]> {
        return Promise { xx in
            xx([0, 1, 2])
        }
    }
    
    func fetchUser(id: Int) -> Promise<User> {
        return Promise { resolve in
        after(0.1) {
            resolve(User.init(id: 0, name: "Aurora Framework"))
            }
        }
    }
    
    func testBasicPromise() {
        fetchIds().then { ids in // flatMap
                return self.fetchUser(id: ids[0])
        }.then { user in // map
            return user.name
        }.then { name in // observe
                print(name)
                XCTAssertNotNil(name)
        }
    }
}
