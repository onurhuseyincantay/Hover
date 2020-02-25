//
//  URLRequest+prepareRequest.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

internal extension URLRequest {
  private var contentTypeHeader: String { "Content-Type" }
  
  mutating func prepareRequest(with target: NetworkTarget) {
    allHTTPHeaderFields = target.headers
    setValue(target.contentType?.rawValue, forHTTPHeaderField: contentTypeHeader)
    httpMethod = target.methodType.methodName
  }
}
