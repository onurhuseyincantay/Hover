//
//  CompletionBlockTests.swift
//  HoverTests
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

class CompletionBlockTests: XCTestCase {
  var testClass: TestClass!
  
  override func setUp() {
    super.setUp()
    testClass = TestClass()
  }
  
  override func tearDown() {
    testClass = nil
    super.tearDown()
  }
}


// MARK: Tests
extension CompletionBlockTests {
  
  func testFetchPosts() {
    let exp = expectation(description: "testFetchPosts")
    testClass.fetchPosts { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchPostById() {
    let exp = expectation(description: "testFetchPostById")
    testClass.fetchPostById { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testCreatePost() {
    let exp = expectation(description: "testCreatePost")
    testClass.createPost { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testUpdatePostWithPut() {
    let exp = expectation(description: "testUpdatePostWithPut")
    testClass.updatePostWithPut { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testUpdatePostWithPatch() {
    let exp = expectation(description: "testUpdatePostWithPatch")
    testClass.updatePostWithPatch { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchPostWithUserId() {
    let exp = expectation(description: "testFetchPostWithUserId")
    testClass.fetchPostsByUserId { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchCommentsWithPostId() {
    let exp = expectation(description: "testFetchPostWithUserId")
    testClass.fetchCommentsWithPostId { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
        
      }
    }
    wait(for: [exp], timeout: 5)
  }
  func testDeletePost() {
    let exp = expectation(description: "testFetchPostWithUserId")
    testClass.deletePost { result in
      switch result {
      case .success(let response):
        print(response)
        exp.fulfill()
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      }
    }
    wait(for: [exp], timeout: 5)
  }
}
