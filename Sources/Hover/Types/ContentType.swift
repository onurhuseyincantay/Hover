//
//  ContentType.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public enum ContentType: String {
    case applicationJson = "application/json"
    case urlFormEncoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
}


// MARK: - Public
public extension ContentType {
  
  func prepareContentBody(
		parameters: [String: Any],
		jsonSerializationData: @escaping (Any, JSONSerialization.WritingOptions) throws -> Data
	) -> Data? {
    switch self {
    //TODO:  Multipart needs to be seperated
    case .applicationJson,
         .multipartFormData:
      return try? jsonSerializationData(parameters, [])
    
    case .urlFormEncoded:
      var urlComponents = URLComponents()
      urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
      return urlComponents.query?.data(using: .utf8)
    }
  }
}
