//
//  ResponseTests.swift
//  HoverTests
//
//  Created by Onur Hüseyin Çantay on 10.10.2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

final class ResponseTests: XCTestCase { }

// MARK: - Tests
extension ResponseTests {
  
  func testResponse() {
    let testURL = URL(string: "https://github.com/onurhuseyincantay/Hover")!
    let testStatusCode = 200
    let testHeaderFields: [String: String] = ["Test": "Value"]
    let testData = "Some Test Data".data(using: .utf8)!
    let response = Response(urlResponse: HTTPURLResponse(url: testURL,
                                                         statusCode: testStatusCode,
                                                         httpVersion: nil,
                                                         headerFields: testHeaderFields)!,
                            data: testData)
    
    XCTAssertEqual(response.statusCode, testStatusCode)
    XCTAssertEqual(response.data, testData)
    XCTAssertEqual(response.localizedStatusCodeDescription, HTTPURLResponse.localizedString(forStatusCode: testStatusCode))
  }
}
