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
    var providerType: AuthProviderType? { get set }
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
    guard case .none = providerType else {
      return true
    }
    return false
  }
  
  mutating func changeProvider(_ provider: AuthProviderType) {
    providerType = provider
  }
}
