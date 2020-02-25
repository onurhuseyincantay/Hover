//
//  Bearer.swift
//  Hover
//
//  Created by onur.cantay on 13/02/2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public struct Bearer {
  let token: String
  let refreshToken: String
  let expireTime: TimeInterval
  
  /// "Bearer \(token)"
  var authToken: String {  "Bearer \(token)" }
}
