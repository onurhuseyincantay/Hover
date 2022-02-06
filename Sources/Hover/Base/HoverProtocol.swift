//
//  HoverProtocol.swift
//  Hover
//
//  Created by Onur Cantay on 08/01/2022.
//  Copyright © 2022 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public typealias VoidResultCompletion = (Result<Response, ProviderError>) -> Void

public protocol HoverProtocol {
  
  /// Requests for a spesific call with `DataTaskPublisher` for with body response
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - type: Decodable Object Type
  ///   - urlSession: `URLSession`
  ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
  func request<D, T>(
    with target: NetworkTarget,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder,
    scheduler: T,
    class type: D.Type
  ) -> AnyPublisher<D, ProviderError> where D: Decodable, T: Scheduler
  
  /// Requests for a spesific call with `DataTaskPublisher` for non body requests
  /// - Parameters
  ///   - target: `NetworkTarget`
  ///   - urlSession: `URLSession
  ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
  func request<T: Scheduler>(
    with target: NetworkTarget,
    scheduler: T,
    urlSession: URLSession
  ) -> AnyPublisher<Response, ProviderError>
  
  /// Requests for a spesific call with `DataTaskPublisher` for with body response
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - type: Decodable Object Type
  ///   - urlSession: `URLSession`
  ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
  ///   - subscriber: `Subscriber`
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
  @discardableResult
  func request<D, S, T>(
    with target: NetworkTarget,
    class type: D.Type,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder,
    scheduler: T,
    subscriber: S
  ) -> AnyPublisher<D, ProviderError> where S: Subscriber, T: Scheduler, D: Decodable, S.Input == D, S.Failure == ProviderError
  
  /// Requests for a spesific call with `DataTaskPublisher` for non body response
  /// - Parameters
  ///   - target: `NetworkTarget`
  ///   - urlSession: `URLSession`
  ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
  ///   - subscriber: `Subscriber`
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
  func request<S, T>(
    with target: NetworkTarget,
    urlSession: URLSession,
    scheduler: T,
    subscriber: S
  ) -> AnyPublisher<Response, ProviderError> where T: Scheduler, S: Subscriber, S.Input == Response, S.Failure == ProviderError
  
  // MARK: - Completion Block Requests
  
  /// Requests for a sepecific call with completionBlock
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - type: Decodable Object Type
  ///   - urlSession: `URLSession`
  ///   - result: `Completion Block as (Result<D,ProviderError>) -> ()`
  @discardableResult
  func request<D: Decodable>(
    with target: NetworkTarget,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder,
    class type: D.Type,
    result: @escaping (Result<D, ProviderError>) -> Void
  ) -> URLSessionTask
  
  /// Requests for a sepecific call with completionBlock for non body request
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - urlSession: `URLSession`
  ///   - result: `VoidResultCompletion`
  @discardableResult
  func request(
    with target: NetworkTarget,
    urlSession: URLSession,
    result: @escaping VoidResultCompletion
  ) -> URLSessionTask
  
  /// Uploads a file to a given target
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - urlSession: `URLSession`
  ///   - data: file that needs to be uploaded
  ///   - result: `Result<(HTTPURLResponse,Data?),ProviderError>`
  @discardableResult
  func uploadRequest(
    with target: NetworkTarget,
    urlSession: URLSession,
    data: Data,
    result: @escaping (Result<(HTTPURLResponse, Data?), ProviderError>) -> Void
  ) -> URLSessionUploadTask
  
  /// Downloads a spesific file
  /// - Parameters:
  ///   - target: `NetworkTarget`
  ///   - urlSession: `URLSession`
  ///   - result: Result<Void,ProviderError>
  @discardableResult
  func downloadRequest(
    with target: NetworkTarget,
    urlSession: URLSession,
    result: @escaping (Result<HTTPURLResponse, ProviderError>) -> Void
  ) -> URLSessionDownloadTask
  
  // MARK: Async Await
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
  func request<D: Decodable>(
    with target: NetworkTarget,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder,
    class type: D.Type,
    delegate: URLSessionTaskDelegate?
  ) async throws -> D
  
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
  func request(
    with target: NetworkTarget,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder,
    delegate: URLSessionTaskDelegate?
  ) async throws -> HTTPURLResponse
  
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
  func downloadRequest(
    with target: NetworkTarget,
    urlSession: URLSession,
    delegate: URLSessionTaskDelegate?
  ) async throws -> URL
}
