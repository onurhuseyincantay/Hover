//
//  AnyEncodable.swift
//  Hover
//
//  Created by Onur Cantay on 08/01/2022.
//  Copyright © 2022 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public struct AnyEncodable {
  public let wrappedValue: Encodable
  
  public init<E>(_ value: E) where E: Encodable {
    wrappedValue = value
  }
}
