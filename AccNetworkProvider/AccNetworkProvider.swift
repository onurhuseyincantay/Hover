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
class AccNetworkProvider {
    private lazy var jsonDecoder = JSONDecoder()
    
    /// Requests for a spesific call with `DataTaskPublisher`
    /// - Parameter target: `NetworkTarget`
    /// - Parameter type: Decodable Object Type
    /// - Parameter subscriber: Subscriber of the publisher
    func request<D: Decodable>(with target: NetworkTarget, class type: D.Type) throws -> AnyPublisher<D,ProviderError> {
        guard var urlRequest = constructURL(with: target) else {
            throw ProviderError.badConstructedUrl
        }
        urlRequest.allowsCellularAccess = false
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    throw ProviderError.connectionError(error)
                }
                return URLSession.shared.dataTaskPublisher(for: urlRequest)
        }
        .tryMap { data, response -> D in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300  else {
                throw ProviderError.invalidServerResponse
            }
            return try self.jsonDecoder.decode(type.self, from: data)
        }
        .mapError{ ProviderError.decodingError($0) }
        .eraseToAnyPublisher()
    }
    
    /// Generates an `URLRequest` based on methodType
    /// - Parameter target: NetworkTarget
    private func constructURL(with target: NetworkTarget) -> URLRequest? {
        var url = target.baseURL
        url.appendPathComponent(target.path)
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
}

// MARK: - Private Extension
private extension AccNetworkProvider {
    // TODO: - Need to add headers like application\json ...
    func prepareGetRequest(with target: NetworkTarget) -> URLRequest? {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var quearyItems: [URLQueryItem] = []
            for parameter in parameters {
                quearyItems.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
            }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = quearyItems
            guard let url = urlComponents?.url else { return nil }
            var request = URLRequest(url: url)
            if let contentType = target.contentType?.rawValue {
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            request.httpMethod = target.methodType.methodName
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
    
    func preparePostRequest(with target: NetworkTarget) -> URLRequest? {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            if let contentType = target.contentType?.rawValue {
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
    
    func preparePutRequest(with target: NetworkTarget) -> URLRequest? {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
    
    func prepareDeleteRequest(with target: NetworkTarget) -> URLRequest? {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            if let contentType = target.contentType?.rawValue {
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        @unknown default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
}
