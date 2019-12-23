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
  
  private mutating func prepareAuthorization(with authType: AuthProviderType) {
    switch authType {
    case .basic(let username, let password):
      let loginString = String(format: "%@:%@", username, password)
      guard let data = loginString.data(using: .utf8) else { return }
      setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: headerField)
    case .bearer(let token):
      setValue("Bearer \(token)", forHTTPHeaderField: headerField)
    case .none: break
    }
  }
  
}
