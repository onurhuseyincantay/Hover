//
//  OAuth1.swift
//  Hover
//
//  Created by onur.cantay on 13/02/2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public final class OAuth1: OAuth {
  let requestTokenUrl: String
  let authorizeUrl: String
  let accessTokenUrl: String
  
  init(requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String, consumerKey: String, consumerSecret: String) {
    self.requestTokenUrl = requestTokenUrl
    self.authorizeUrl = authorizeUrl
    self.accessTokenUrl = accessTokenUrl
    super.init(consumerKey: consumerKey, consumerSecret: consumerSecret)
  }
  
}
