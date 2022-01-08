//
//  HoverDebugger.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 11.10.2020.
//  Copyright © 2020 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public enum HoverDebugger {
  
  public static func printDebugDescriptionIfNeeded(from urlRequest: URLRequest, error: Error?) {
    guard Hover.prefference.isDebuggingEnabled else {
      return
    }
    print("\n--------------- OUTGOING ---------------\n")
    
    defer { print("\n--------------- END ---------------\n") }
    let urlAsString = urlRequest.url?.absoluteString ?? ""
    let urlComponents = NSURLComponents(string: urlAsString)
    let method = urlRequest.httpMethod != nil ? "\(urlRequest.httpMethod ?? "")" : ""
    let path = "\(urlComponents?.path ?? "")"
    let query = "\(urlComponents?.query ?? "")"
    let host = "\(urlComponents?.host ?? "")"
    var debugString: String = """
      \(urlAsString) \n\n
      \(method) \(path)?\(query)
      HOST: \(host)\n
    """
    urlRequest.allHTTPHeaderFields?.forEach {
      debugString += "\($0): \($1) \n"
    }
    
    guard let err = error else {
      debugString += "  STATUS: SUCCESS \n"
      print(debugString)
      return
    }
    debugString += "STATUS: FAILED \n"
    debugString += "ERROR: \(err.localizedDescription)\n"
    print(debugString)
  }
}
