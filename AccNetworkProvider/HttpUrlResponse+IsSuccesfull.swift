//
//  HttpUrlResponse+IsSuccesfull.swift
//  AccNetworkProvider
//
//  Created by Onur Hüseyin Çantay on 9.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isSuccessfull: Bool {
        return (200..<300).contains(statusCode)
    }
}
