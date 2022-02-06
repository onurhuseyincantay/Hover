//
//  AsyncAwaitTests.swift
//  HoverTests
//
//  Created by Onur Cantay on 06/02/2022.
//  Copyright © 2022 Onur Hüseyin Çantay. All rights reserved.
//

import XCTest
@testable import Hover

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
final class AsyncAwaitTests: XCTestCase {
  private let hover: Hover = .init()
}

// MARK: - Tests

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension AsyncAwaitTests {
  
  func testGetRequest() async throws {
    // Given
    _ = try await hover.request(
      with: TestTarget.fetchAllPosts,
      class: PostsResponse.self)
  }
  
  func testFetchPostById() async throws {
    // Given
    let id = 1
    
    // When //Then
    _ = try await hover.request(
      with: TestTarget.fetchPostById(id: id),
      class: PostResponseElement.self
    )
  }
  
  func testFetchPostsByUserId() async throws {
    // Given
    let id = 1
    
    // When // Then
    _ = try await hover.request(
      with: TestTarget.fetchPostsByUserId(userId: id),
      class: PostsResponse.self
    )
  }
  
  func testCreatePost() async throws {
    // Given
    let title: String = "Foo"
    let body: String = "Bar"
    let userId: Int = 1
    // When // Then
    
    _ = try await hover
      .request(
        with: TestTarget.createPost(
          title: title,
          body: body,
          userId: userId
        ),
        class: PostResponseElement.self
      )
  }
  
  func testUpdatePostWithPut() async throws {
    // Given
    let postId = 1
    let title: String = "Foo"
    let body: String = "Bar"
    let userId: Int = 1
    // When // Then
    
    _ = try await hover
      .request(
        with: TestTarget.updatePostById(
          postId: postId,
          title: title,
          body: body,
          userId: userId
        ),
        class: PostResponseElement.self
      )
  }
  
  func testUpdatePostWithPatch() async throws {
    // Given
    let postId = 1
    let title: String = "Foo"
    // When // Then
    
    _ = try await hover
      .request(
        with: TestTarget.updatePostPartly(
          postId: postId,
          title: title
        ),
        class: PostResponseElement.self
      )
  }
  
  func testDeletePost() async throws {
    // Given
    let id = 1
    
    // When // Then
    _ = try await hover.request(
      with: TestTarget.deletePostById(postId: id)
    )
  }

}
