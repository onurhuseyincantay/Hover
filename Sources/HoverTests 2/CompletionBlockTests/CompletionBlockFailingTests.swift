//
//  CompletionBlockFailingTests.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

class CompletionBlockFailingTests: XCTestCase {
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
        testClass.fetchPostById(with: 1231234123) { result in
            switch result {
            case .success:
               XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testCreatePost() {
        let exp = expectation(description: "testCreatePost")
        testClass.createPost(title: "", body: "", userId: 0) { result in
            switch result {
            case .success:
                XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testUpdatePostWithPut() {
       let exp = expectation(description: "testUpdatePostWithPut")
        testClass.updatePostWithPut(postId: 52491293012, userId: 1293419230123, title: "", body: "") { result in
            switch result {
            case .success:
               XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testUpdatePostWithPatch() {
        let exp = expectation(description: "testUpdatePostWithPatch")
        testClass.updatePostWithPatch(postId: 741298371293, title: "") { result in
            switch result {
            case .success:
                XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testFetchPostWithUserId() {
       let exp = expectation(description: "testFetchPostWithUserId")
        testClass.fetchPostsByUserId(741298371293) { result in
            switch result {
            case .success:
                XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testFetchCommentsWithPostId() {
        let exp = expectation(description: "testFetchPostWithUserId")
        testClass.fetchCommentsWithPostId(12314123123123) { result in
            switch result {
            case .success:
                XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testDeletePost() {
       let exp = expectation(description: "testFetchPostWithUserId")
        testClass.deletePost(with: 125123123123123) { result in
            switch result {
            case .success:
                XCTFail("shouldn't success the request is not valid")
            case .failure(let error):
                print(error.errorDescription)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
}
