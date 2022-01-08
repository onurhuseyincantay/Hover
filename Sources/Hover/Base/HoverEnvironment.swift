//
//  HoverEnvironment.swift
//  Hover
//
//  Created by Onur Cantay on 08/01/2022.
//  Copyright © 2022 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public struct HoverEnvironment {
  public init(
    jsonSerializationData: @escaping (Any, JSONSerialization.WritingOptions) throws -> Data = JSONSerialization.data(withJSONObject:options:),
    printDebugDescriptionIfNeeded: @escaping (URLRequest, Error?) -> Void = HoverDebugger.printDebugDescriptionIfNeeded(from:error:))
  {
    self.jsonSerializationData = jsonSerializationData
    self.printDebugDescriptionIfNeeded = printDebugDescriptionIfNeeded
  }
  
  public var jsonSerializationData: (Any, JSONSerialization.WritingOptions) throws -> Data
  public var printDebugDescriptionIfNeeded: (URLRequest, Error?) -> Void
}
