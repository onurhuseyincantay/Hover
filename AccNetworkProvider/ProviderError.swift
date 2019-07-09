//
//  ProviderError.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

enum ProviderError: Error {
    case invalidServerResponse
    case badConstructedUrl
    case decodingError(Error)
    case connectionError(Error)
    case underlying(Error)
}
