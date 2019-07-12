//
//  HoverProvider.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public typealias VoidResultCompletion = (Result<URLResponse,ProviderError>) -> Void
// MARK: - HoverProvider Data Task Publisher
public final class HoverProvider {
    public init() {}

    private lazy var jsonDecoder = JSONDecoder()
    
    /// Requests for a spesific call with `DataTaskPublisher` for with body response
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter urlSession: `URLSession`
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, UIKitForMac 13.0, *)
    public func request<D: Decodable>(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, class type: D.Type) -> AnyPublisher<D, ProviderError> {
        let urlRequest = constructURL(with: target)
        return urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return data
        }.decode(type: type.self, decoder: jsonDecoder).mapError { error in
            if let error = error as? ProviderError {
                return error
            } else {
                return ProviderError.decodingError(error)
            }
        }.eraseToAnyPublisher()
    }
    
   
    /// Requests for a spesific call with `DataTaskPublisher` for non body requests
    /// - Parameter target: `NetworkTarget`
    /// - Parameter urlSession: `URLSession`
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, UIKitForMac 13.0, *)
    public func request(with target: NetworkTarget, urlSession: URLSession = URLSession.shared) -> AnyPublisher<URLResponse,ProviderError> {
        let urlRequest = constructURL(with: target)
        return urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.tryMap { (data, response) -> URLResponse in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return response
        }.mapError { $0 as! ProviderError }.eraseToAnyPublisher()
    }
    
    
    /// Requests for a spesific call with `DataTaskPublisher` for with body response
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter urlSession: `URLSession`
    /// - Parameter subscriber: Subscriber
    @available(iOS 13.0, macOS 10.15,tvOS 13.0, watchOS 6.0, UIKitForMac 13.0, *)
    func request<D,S>(with target: NetworkTarget, class type: D.Type, urlSession: URLSession = URLSession.shared, subscriber: S) where S: Subscriber, D: Decodable, S.Input == D, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        urlSession.dataTaskPublisher(for: urlRequest)
        .tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return data
        }.decode(type: type.self, decoder: jsonDecoder).mapError{ error -> ProviderError in
            if let error = error as? ProviderError {
                return error
            } else {
                return ProviderError.decodingError(error)
            }
        }.eraseToAnyPublisher().subscribe(subscriber)
    }
    
    /// Requests for a spesific call with `DataTaskPublisher` for non body response
    /// - Parameter target: `NetworkTarget`
    /// - Parameter urlSession: `URLSession`
    /// - Parameter subscriber: `Subscriber`
    @available(iOS 13.0, macOS 10.15,tvOS 13.0, watchOS 6.0, UIKitForMac 13.0, *)
    func request<S>(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, subscriber: S) where S: Subscriber, S.Input == URLResponse, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.tryMap { data, response -> URLResponse in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return response
        }.mapError { $0 as! ProviderError }.eraseToAnyPublisher().subscribe(subscriber)
    }
}

// MARK: - Completion Block Requests
public extension HoverProvider {
    
    /// Requests for a sepecific call with completionBlock
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter urlSession: `URLSession`
    /// - Parameter result: `Completion Block as (Result<D,ProviderError>) -> ()`
    func request<D: Decodable>(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, class type: D.Type, result: @escaping (Result<D,ProviderError>) -> ()) {
        let urlRequest = constructURL(with: target)
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                result(.failure(.connectionError(error!)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(.invalidServerResponse))
                return
            }
            if !httpResponse.isSuccessful {
                result(.failure(.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            do {
                guard let data = data else {
                    result(.failure(.missingBodyData))
                    return
                }
                let decoded = try self.jsonDecoder.decode(type.self, from: data)
                result(.success(decoded))
            } catch {
                result(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    /// Requests for a sepecific call with completionBlock for non body request
    /// - Parameter target: `NetworkTarget`
    /// - Parameter urlSession: `URLSession`
    /// - Parameter result: `VoidResultCompletion`
    func request(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, result: @escaping VoidResultCompletion) {
        let urlRequest = constructURL(with: target)
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                result(.failure(.connectionError(error!)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(.invalidServerResponse))
                return
            }
            if !httpResponse.isSuccessful {
                result(.failure(.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            guard let response = response else {
                result(.failure(.missingBodyData))
                return
            }
            result(.success(response))
        }.resume()
    }
}

// MARK: - Private Extension
private extension HoverProvider {
    
    /// Generates an `URLRequest` based on `MethodType`
    /// - Parameter target: NetworkTarget
    func constructURL(with target: NetworkTarget) -> URLRequest {
        switch target.methodType {
        case .get:
            return prepareGetRequest(with: target)
        case .post:
            return preparePostRequest(with: target)
        case .put,
             .patch:
            return preparePutRequest(with: target)
        case .delete:
            return prepareDeleteRequest(with: target)
        }
    }
    
    // TODO: - Similar Functions reduce to one function
    func prepareGetRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            let url = url.generateUrlWithQuery(with: parameters)
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        }
    }
    
    func preparePostRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        case .requestData(let data):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: encodable, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        }
    }
    
    func preparePutRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        case .requestData(let data):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: encodable, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        }
    }
    
    func prepareDeleteRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        case .requestData(let data):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? JSONSerialization.data(withJSONObject: encodable, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
}
