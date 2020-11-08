//
//  DataTaskPublisherTests.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
final class DataTaskPublisherTests: XCTestCase {
  var testClass: TestClass!
  override func setUp() {
    super.setUp()
    testClass = TestClass()
    testClass.isDebugEnabled = false
  }
  
  override func tearDown() {
    testClass = nil
    super.tearDown()
  }
}

// MARK: - Tests
extension DataTaskPublisherTests {
  
  func testFetchPosts() {
    let exp = expectation(description: "testFetchPosts")
    testClass.fetchPosts()
    guard let testSubscriber = testClass.postsSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchPostById() {
    let exp = expectation(description: "testFetchPostById")
    testClass.fetchPostById()
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testCreatePost() {
    testClass.createPost()
    let exp = expectation(description: "testCreatePost")
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testUpdatePostWithPut() {
    let exp = expectation(description: "testUpdatePostWithPut")
    testClass.updatePostWithPut()
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testUpdatePostWithPatch() {
    let exp = expectation(description: "testUpdatePostWithPatch")
    testClass.updatePostWithPatch()
    guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchPostWithUserId() {
    let exp = expectation(description: "testFetchPostWithUserId")
    testClass.fetchPostsByUserId()
    guard let testSubscriber = testClass.postsSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchCommentsWithPostId() {
    let exp = expectation(description: "testFetchCommentsWithPostId")
    testClass.fetchCommentsWithPostId()
    guard let testSubscriber = testClass.commentSubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testDeletePost() {
    let exp = expectation(description: "testDeletePost")
    testClass.deletePost()
    guard let testSubscriber = testClass.noBodySubscriber else { return assertionFailure() }
    testClass.anyCancellable = testSubscriber.sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        XCTFail(error.errorDescription)
      case .finished:
        break
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 5)
  }
  
  func testFetchCommentsWithPostIdSubscriber() {
    let exp = expectation(description: "testFetchCommentsWithPostIdSubscriber")
    testClass.fetchCommentsWithSubscriber()
    testClass.anyCancellable = testClass.subscriber.publisher.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        XCTFail("Onur: \(error.errorDescription)")
      case .finished:
        print("finished")
      }
    }, receiveValue: { _ in
      exp.fulfill()
    })
    wait(for: [exp], timeout: 10)
  }
}
