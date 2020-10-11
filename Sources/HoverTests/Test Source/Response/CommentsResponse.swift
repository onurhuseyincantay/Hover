//
//  CommentsResponse.swift
//  HoverTests
//
//  Created by Onur Hüseyin Çantay on 10.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

struct CommentsResponseElement: Decodable {
  let postID, id: Int
  let name, email, body: String
  
  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case id, name, email, body
  }
}

typealias CommentsResponse = [CommentsResponseElement]
