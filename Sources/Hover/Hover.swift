//
//  Hover.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public typealias VoidResultCompletion = (Result<Response, ProviderError>) -> Void

public final class Hover {
    public init() { }
    /// Requests for a spesific call with `DataTaskPublisher` for with body response
    /// - Parameters:
    ///   - target: `NetworkTarget`
    ///   - type: Decodable Object Type
    ///   - urlSession: `URLSession`
    ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
    public func request<D, T>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: T,
        class type: D.Type) -> AnyPublisher<D, ProviderError> where D: Decodable, T: Scheduler {
        let urlRequest = constructURL(with: target)
        return urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }
        .receive(on: scheduler)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return data
        }
        .decode(type: type.self, decoder: jsonDecoder).mapError { error in
            if let error = error as? ProviderError {
                return error
            } else {
                return ProviderError.decodingError(error)
            }
        }.eraseToAnyPublisher()
    }
    /// Requests for a spesific call with `DataTaskPublisher` for non body requests
    /// - Parameters
    ///   - target: `NetworkTarget`
    ///   - urlSession: `URLSession
    ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
    public func request<T: Scheduler>(
        with target: NetworkTarget,
        scheduler: T,
        urlSession: URLSession = URLSession.shared) -> AnyPublisher<Response, ProviderError> {
        let urlRequest = constructURL(with: target)
        return urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw ProviderError.connectionError(error)
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.receive(on: scheduler)
            .tryMap { (data, response) -> Response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ProviderError.invalidServerResponse
                }
                if !httpResponse.isSuccessful {
                    throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                }
                return Response(urlResponse: httpResponse, data: data)
        }
        .mapError {
            guard let error = $0 as? ProviderError else { return ProviderError.underlying($0) }
            return error
        }.eraseToAnyPublisher()
    }
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
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: T,
        subscriber: S) -> AnyPublisher<D, ProviderError> where S: Subscriber, T: Scheduler, D: Decodable, S.Input == D, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        let publisher = urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    throw ProviderError.connectionError(error)
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
        }.receive(on: scheduler)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ProviderError.invalidServerResponse
                }
                if !httpResponse.isSuccessful {
                    throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                }
                return data
        }.decode(
            type: type.self,
            decoder: jsonDecoder
        ).mapError { error -> ProviderError in
            if let error = error as? ProviderError {
                return error
            } else {
                return ProviderError.decodingError(error)
            }
        }.eraseToAnyPublisher()
        publisher.subscribe(subscriber)
        return publisher
    }
    /// Requests for a spesific call with `DataTaskPublisher` for non body response
    /// - Parameters
    ///   - target: `NetworkTarget`
    ///   - urlSession: `URLSession`
    ///   - scheduler:  Threading and execution time helper if you want to run it on main thread just use `Runloop.main` or `DispatchQueue.main`
    ///   - subscriber: `Subscriber`
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
    func request<S, T>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        scheduler: T,
        subscriber: S) -> AnyPublisher<Response, ProviderError> where T: Scheduler, S: Subscriber, S.Input == Response, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        let publisher = urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    throw ProviderError.connectionError(error)
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
        }
        .receive(on: scheduler)
        .tryMap { data, response -> Response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidServerResponse
            }
            if !httpResponse.isSuccessful {
                throw ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
            }
            return Response(urlResponse: httpResponse, data: data)
        }
        .mapError { err -> ProviderError in
            guard let error = err as? ProviderError else { return ProviderError.underlying(err) }
            return error
        }.eraseToAnyPublisher()
        publisher.subscribe(subscriber)
        return publisher
    }
}

// MARK: - Completion Block Requests
public extension Hover {
    /// Requests for a sepecific call with completionBlock
    /// - Parameters:
    ///   - target: `NetworkTarget`
    ///   - type: Decodable Object Type
    ///   - urlSession: `URLSession`
    ///   - result: `Completion Block as (Result<D,ProviderError>) -> ()`
    @discardableResult
    func request<D: Decodable>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        class type: D.Type,
        result: @escaping (Result<D, ProviderError>) -> Void) -> URLSessionTask {
        let urlRequest = constructURL(with: target)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
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
                let decoded = try jsonDecoder.decode(type.self, from: data)
                result(.success(decoded))
            } catch {
                result(.failure(.decodingError(error)))
            }
        }
        task.resume()
        return task
    }
    /// Requests for a sepecific call with completionBlock for non body request
    /// - Parameters:
    ///   - target: `NetworkTarget`
    ///   - urlSession: `URLSession`
    ///   - result: `VoidResultCompletion`
    @discardableResult
    func request(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        result: @escaping VoidResultCompletion) -> URLSessionTask {
        let urlRequest = constructURL(with: target)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
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
            guard let data = data else {
                result(.failure(.missingBodyData))
                return
            }
            result(.success(Response(urlResponse: httpResponse, data: data)))
        }
        task.resume()
        return task
    }
    /// Uploads a file to a given target
    /// - Parameters:
    ///   - target: `NetworkTarget`
    ///   - urlSession: `URLSession`
    ///   - data: file that needs to be uploaded
    ///   - result: `Result<(HTTPURLResponse,Data?),ProviderError>`
    @discardableResult
    func uploadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        data: Data,
        result: @escaping (Result<(HTTPURLResponse, Data?), ProviderError>) -> Void) -> URLSessionUploadTask {
        let urlRequest = constructURL(with: target)
        let task = urlSession.uploadTask(with: urlRequest, from: data) { data, response, error in
            guard error == nil else {
                result(.failure(.underlying(error!)))
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
            result(.success((httpResponse, data)))
        }
        task.resume()
        return task
    }
    /// Downloads a spesific file
    /// - Parameters:
    ///   - target: `NetworkTarget`
    ///   - urlSession: `URLSession`
    ///   - data: optional data response
    ///   - result: Result<Void,ProviderError>
    @discardableResult
    func downloadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        data: Data,
        result: @escaping (Result<Void, ProviderError>) -> Void) -> URLSessionDownloadTask {
        let urlRequest = constructURL(with: target)
        let task = urlSession.downloadTask(with: urlRequest) { _, response, error in
            guard error == nil else {
                result(.failure(.underlying(error!)))
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
            result(.success(()))
        }
        task.resume()
        return task
    }
}

// MARK: - Private Extension
private extension Hover {
    
    func constructURL(with target: NetworkTarget) -> URLRequest {
        switch target.methodType {
        case .get:
            return prepareGetRequest(with: target)
        case .put,
             .patch,
             .post:
            return prepareGeneralRequest(with: target)
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
        default:
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        }
    }
    
    func prepareGeneralRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        var request = URLRequest(url: url)
        request.prepareRequest(with: target)
        switch target.workType {
        case .requestParameters(let parameters, _):
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return request
        case .requestData(let data):
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            request.httpBody = try? JSONSerialization.data(withJSONObject: encodable, options: .prettyPrinted)
            return request
        default:
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
        default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
}
