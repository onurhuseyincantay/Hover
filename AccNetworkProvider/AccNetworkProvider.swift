//
//  AccNetworkProvider.swift
//  AccNetworkProvider
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import Combine

// MARK: - AccNetworkProvider
public final class AccNetworkProvider {
    public init() {}
    
    private lazy var jsonDecoder = JSONDecoder()
    
    /// Requests for a spesific call with `DataTaskPublisher`
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter urlSession: `URLSession`
    public func request<D: Decodable>(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, class type: D.Type) -> AnyPublisher<D,ProviderError> {
        var urlRequest = constructURL(with: target)
        urlRequest.allowsCellularAccess = false
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    throw ProviderError.connectionError(error)
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
        }.tryMap { data, response -> D in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessfull {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return try self.jsonDecoder.decode(type.self, from: data)
        }.mapError{ error in
            if let error = error as? ProviderError {
                return error
            } else {
                return ProviderError.decodingError(error)
            }
        }.eraseToAnyPublisher()
    }
    
    /// Requests for a sepecific call with completionBlock
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter urlSession: `URLSession`
    /// - Parameter result: `Completion Block as (Result<D,ProviderError>) -> ()`
    public func request<D: Decodable>(with target: NetworkTarget, urlSession: URLSession = URLSession.shared, class type: D.Type, result: @escaping (Result<D,ProviderError>) -> ()) {
        var urlRequest = constructURL(with: target)
        urlRequest.allowsCellularAccess = false
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                result(.failure(.connectionError(error!)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(.invalidServerResponse))
                return
            }
            if !httpResponse.isSuccessfull {
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
}

// MARK: - Private Extension
private extension AccNetworkProvider {
    
    /// Generates an `URLRequest` based on `MethodType`
    /// - Parameter target: NetworkTarget
    func constructURL(with target: NetworkTarget) -> URLRequest {
        switch target.methodType {
        case .get:
            return prepareGetRequest(with: target)
        case .post:
            return preparePostRequest(with: target)
        case .put:
            return preparePutRequest(with: target)
        case .delete:
            return prepareDeleteRequest(with: target)
        }
    }
    
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
            #warning("not tested yet can explode!")
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
            #warning("not tested yet can explode!")
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
            #warning("not tested yet can explode!")
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
