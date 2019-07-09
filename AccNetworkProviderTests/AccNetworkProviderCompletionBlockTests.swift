//
//  AccNetworkProviderCompletionBlockTests.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest

class AccNetworkProviderCompletionBlockTests: XCTestCase {
    var testClass: TestClass!
    
    override func setUp() {
        testClass = TestClass()
    }
    
    override func tearDown() {
        testClass = nil
    }

    func testGetWeather() {
        let exp = expectation(description: "Response")
        testClass.getWeatherWithCompletion { result in
            switch result {
            case .success(let response):
                print(response)
                exp.fulfill()
            case .failure(let error):
                print("Onur:",error.errorDescription)
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testFailResponse() {
        let exp = expectation(description: "Response")
        testClass.getFailingResponseWithCompletion { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                print(error.localizedDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10)
    }
}
