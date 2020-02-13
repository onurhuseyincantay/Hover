//
//  OAuth2.swift
//  Hover
//
//  Created by onur.cantay on 13/02/2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public final class OAuth2: OAuth {
  let authorizeUrl: String
  let responseType: String
  
  init(authorizeUrl: String, responseType: String, consumerKey: String, consumerSecret: String) {
    self.authorizeUrl = authorizeUrl
    self.responseType = responseType
    super.init(consumerKey: consumerKey, consumerSecret: consumerSecret)
  }
}
