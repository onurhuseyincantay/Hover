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
        testClass.getWeather()
        guard let testSubscriber = testClass.subscriber else { return assertionFailure() }
        testSubscriber.sink { response in
            print(response)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testFailingResponse() {
        let exp = expectation(description: "Response")
        testClass.getFailingResponse()
        guard let testSubscriber = testClass.subscriber else { return assertionFailure() }
        testSubscriber.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Error:",error.errorDescription)
                exp.fulfill()
            case .finished:
                XCTFail()
            }
        }) { response in
            XCTFail()
        }
        wait(for: [exp], timeout: 10)
    }
}
