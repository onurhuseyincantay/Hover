//
//  HoverAuth.swift
//  Hover
//
//  Created by onur.cantay on 13/02/2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public final class HoverAuth {
  private let headerField: String = "Authorization"
  func authenticate(with type: AuthProviderType, urlRequest: inout URLRequest ) {
    switch type {
    case .oauth:
      self.authenticateForOAuth(with: type, urlRequest: &urlRequest)
    case .basic(let basic):
      guard let base64Coded = basic.base64Coded else { return }
      urlRequest.addValue(base64Coded, forHTTPHeaderField: headerField)
    case .bearer(let bearer):
      urlRequest.addValue(bearer.authToken, forHTTPHeaderField: headerField)
    }
  }
}

// MARK: - Private
private extension HoverAuth {
  
  func authenticateForOAuth(with type: AuthProviderType, urlRequest: inout URLRequest) {
      if case .oauth(let oauthType) = type {
        switch oauthType {
        case .oAuth1(let oauth1):
          print(oauth1.authorizeUrl)
        case .oAuth2(let oauth2):
          print(oauth2.consumerKey)
        }
      }
  }
}
