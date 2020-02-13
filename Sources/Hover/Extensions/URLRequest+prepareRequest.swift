//
//  URLRequest+prepareRequest.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

internal extension URLRequest {
  private var headerField: String { "Authorization" }
  private var contentTypeHeader: String { "Content-Type" }
  mutating func prepareRequest(with target: NetworkTarget) {
    let contentTypeHeaderName = contentTypeHeader
    allHTTPHeaderFields = target.headers
    allowsCellularAccess = false
    setValue(target.contentType?.rawValue, forHTTPHeaderField: contentTypeHeaderName)
    prepareAuthorization(with: target.providerType)
    httpMethod = target.methodType.methodName
  }
  
  private mutating func prepareAuthorization(with authType: AuthProviderType?) {
    switch authType {
    case .basic(let basic):
      guard let coded = basic.base64Coded else { return }
      setValue(coded, forHTTPHeaderField: headerField)
      
    case .bearer(let bearer):
      setValue("Bearer \(bearer.token)", forHTTPHeaderField: headerField)
      
    default:
      break
    }
  }
}
