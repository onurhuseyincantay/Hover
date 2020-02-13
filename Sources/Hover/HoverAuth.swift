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
  
  func authenticate(with type: AuthProviderType) {
    if case .oauth(let oauthType) = type {
      switch oauthType {
      case .oauth1(let oauth1):
        print(oauth1.authorizeUrl)
      case .oauth2(let oauth2):
        print(oauth2.consumerKey)
      }
    }
  }
}
