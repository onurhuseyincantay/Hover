//
//  AccNetworkProviderTests.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import AccNetworkProvider

class AccNetworkProviderTests: XCTestCase {
    var testClass: TestClass!
    
    override func setUp() {
        testClass = TestClass()
    }
    
    override func tearDown() {
        testClass = nil
    }
    
    func testGetRequest() {
        let exp = expectation(description: "Response")
        XCTAssertNoThrow(try testClass.getWeather()) 
        guard let testSubscriber = testClass.subscriber else { return assertionFailure() }
        testSubscriber.sink { response in
            print(response)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20)
    }
}
