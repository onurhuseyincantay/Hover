//
//  Response.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 17.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import UIKit

public struct Response {
    let urlResponse: HTTPURLResponse
    let data: Data
    
    var statusCode: Int {
        return urlResponse.statusCode
    }
    
    var localizedStatusCodeDescription: String {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    
    func decodeToImage() throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ProviderError.failedToDecodeImage
        }
        return image
    }
}
