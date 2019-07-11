//
//  PostsResponse.swift
//  AccNetworkProviderTests
//
//  Created by Onur Hüseyin Çantay on 10.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

typealias PostsResponse = [PostResponseElement]

struct PostResponseElement: Decodable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
