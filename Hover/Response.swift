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
    let urlResponse: URLResponse
    let data: Data
    
    func decodeToImage() throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ProviderError.failedToDecodeImage
        }
        return image
    }
}
