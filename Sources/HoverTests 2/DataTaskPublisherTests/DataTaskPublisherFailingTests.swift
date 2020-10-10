//
//  DataTaskPublisherFailingTests.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
class DataTaskPublisherFailingTests: XCTestCase {
  #warning("Failing tests are because of the api placeholder the api doesn't return 404")
  var testClass: TestClass!
  
  override func setUp() {
    testClass = TestClass()
  }
  override func tearDown() {
    testClass = nil
  }
  func testFetchPostById() {
    let exp = expectation(description: "testFetchPostById")
    testClass.fetchPostById(1231234123)
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
      }
    }, receiveValue: { response in
      XCTFail("Onur: \(response)")
    })
    wait(for: [exp], timeout: 5)
  }
  func testCreatePost() {
    testClass.createPost(title: "", body: "", userId: -1232741298371293)
    let exp = expectation(description: "Response")
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
      }
    }, receiveValue: { response in
      XCTFail("Onur: \(response)")
    })
    wait(for: [exp], timeout: 5)
  }
  func testUpdatePostWithPut() {
    let exp = expectation(description: "testUpdatePostWithPut")
    testClass.updatePostWithPut(postId: -52491293012, userId: -1293419230123, title: "", body: "")
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
        }
      }, receiveValue: { response in
          XCTFail("Onur: \(response)")
    })
    wait(for: [exp], timeout: 5)
  }
  func testUpdatePostWithPatch() {
    let exp = expectation(description: "testUpdatePostWithPatch")
    testClass.updatePostWithPatch(postId: 1293419230123, title: "")
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
      }
      }, receiveValue: { response in
          XCTFail("Onur: \(response)")
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchPostWithUserId() {
    let exp = expectation(description: "testFetchPostWithUserId")
    testClass.fetchPostsByUserId(userId: -1231231231234123)
    guard let testSubscriber = testClass.postsSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
      }
    }, receiveValue: { response in
          XCTFail("Onur: \(response)")
        })
    wait(for: [exp], timeout: 5)
  }
  func testFetchCommentsWithPostId() {
    let exp = expectation(description: "testFetchCommentsWithPostId")
    testClass.fetchCommentsWithPostId(-1231234123)
    guard let testSubscriber = testClass.commentSubscriber else { return assertionFailure() }
    _ = testSubscriber.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print("Error:", error.errorDescription)
        exp.fulfill()
      case .finished:
        exp.fulfill()
      }
    }, receiveValue: { response in
      XCTFail("Onur: \(response)")
  })
  wait(for: [exp], timeout: 5)
}
func testDeletePost() {
  let exp = expectation(description: "testDeletePost")
  testClass.deletePost(with: -125123123123123)
  guard let testSubscriber = testClass.noBodySubscriber else { return assertionFailure() }
  _ = testSubscriber.sink(receiveCompletion: { completion in
    switch completion {
    case .failure(let error):
      print("Error:", error.errorDescription)
      exp.fulfill()
    case .finished:
      exp.fulfill()
    }
  }, receiveValue: { response in
    XCTFail("Onur: \(response)")
  })
  wait(for: [exp], timeout: 5)
}
}
