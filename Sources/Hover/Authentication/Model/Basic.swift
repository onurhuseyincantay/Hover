//
//  Basic.swift
//  Hover
//
//  Created by onur.cantay on 13/02/2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public struct Basic {
  let username: String
  let password: String
  let encodingType: String.Encoding = .utf8
  
  var base64Coded: String? {
    let loginString = String(format: "%@:%@", username, password)
    guard let data = loginString.data(using: encodingType) else { return nil }
    return "Basic \(data.base64EncodedString())"
  }
}
