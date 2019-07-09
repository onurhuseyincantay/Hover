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
    case decodingError(Error)
    case connectionError(Error)
    case underlying(Error)
}

extension ProviderError {
    var errorDescription: String {
        switch self {
        case .invalidServerResponse:
            return "The server response didn't fall in the given range"
        case .connectionError(let error):
            return "Network connection seems to be offline:  \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding problem: \(error.localizedDescription)"
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
