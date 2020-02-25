//
//  NetworkTarget.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public protocol NetworkTarget {
  var baseURL: URL { get }
  var path: String { get }
  var methodType: MethodType { get }
  var workType: WorkType { get }
  var providerType: AuthProviderType? { get }
  var contentType: ContentType? { get }
  var headers: [String: String]? { get }
}

public extension NetworkTarget {
  var pathAppendedURL: URL {
    var url = baseURL
    url.appendPathComponent(path)
    return url
  }
  
  var hasProvider: Bool {
    guard case .none = providerType else {  return true }
    return false
  }
  
  func constructURL() -> URLRequest {
    switch methodType {
    case .get:
      return prepareGetRequest()
    case .put,
         .patch,
         .post:
      return prepareGeneralRequest()
    case .delete:
      return prepareDeleteRequest()
    }
  }
  
}

private extension NetworkTarget {
  func prepareGetRequest() -> URLRequest {
    switch workType {
    case .requestParameters(let parameters):
      let url = pathAppendedURL.generateUrlWithQuery(with: parameters)
      var request = URLRequest(url: url)
      request.prepareRequest(with: self)
      return request
    default:
      var request = URLRequest(url: pathAppendedURL)
      request.prepareRequest(with: self)
      return request
    }
  }
  func prepareGeneralRequest() -> URLRequest {
    var request = URLRequest(url: pathAppendedURL)
    request.prepareRequest(with: self)
    switch workType {
    case .requestParameters(let parameters):
      request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
      return request
    case .requestData(let data):
      request.httpBody = data
      return request
    case .requestWithEncodable(let encodable):
      request.httpBody = try? JSONSerialization.data(withJSONObject: encodable)
      return request
    default:
      return request
    }
  }
  func prepareDeleteRequest() -> URLRequest {
    switch workType {
    case .requestParameters(let parameters):
      var request = URLRequest(url: pathAppendedURL)
      request.prepareRequest(with: self)
      request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
      return request
    case .requestData(let data):
      var request = URLRequest(url: pathAppendedURL)
      request.prepareRequest(with: self)
      request.httpBody = data
      return request
    case .requestWithEncodable(let encodable):
      var request = URLRequest(url: pathAppendedURL)
      request.prepareRequest(with: self)
      request.httpBody = try? JSONSerialization.data(withJSONObject: encodable)
      return request
    default:
      var request = URLRequest(url: pathAppendedURL)
      request.httpMethod = methodType.methodName
      return request
    }
  }

}
