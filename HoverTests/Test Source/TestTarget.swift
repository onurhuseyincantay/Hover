//
//  TestData.swift
//  HoverTests
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
@testable import Hover

enum TestTarget {
    case fetchAllPosts
    case fetchPostById(id: Int)
    case createPost(title: String, body: String, userId: Int)
    case updatePostById(postId: Int, title: String, body: String, userId: Int)
    case updatePostPartly(postId: Int, title: String)
    case deletePostById(postId: Int)
    case fetchPostsByUserId(userId: Int)
    case fetchCommentsByPostId(postId: Int)
}

extension TestTarget: NetworkTarget {

    var path: String {
        switch self {
        case .fetchAllPosts,
             .createPost,
             .fetchPostsByUserId:
            return "posts"
        case .fetchPostById(let id),
             .deletePostById(let id):
            return "posts/\(id)"
        case .updatePostById(let id, _, _, _):
            return "posts/\(id)"
        case .updatePostPartly(let id, _):
            return "posts/\(id)"
        case .fetchCommentsByPostId(let postId):
            return "posts/\(postId)/comments"
        }
    }
    
    var providerType: AuthProviderType {
        return .none
    }
    
    
    var baseURL: URL {
        // TODO: - https://jsonplaceholder.typicode.com/guide.html
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var methodType: MethodType {
        switch self {
        case .fetchAllPosts,
             .fetchPostById,
             .fetchPostsByUserId,
             .fetchCommentsByPostId:
            return .get
            
        case .createPost:
            return .post
            
        case .updatePostById:
            return .put
        case .updatePostPartly:
            return .patch
        case .deletePostById:
            return .delete
        }
    }
    
    var contentType: ContentType? {
        switch self {
        case .fetchAllPosts,
             .deletePostById,
             .fetchPostsByUserId,
             .fetchCommentsByPostId:
            return nil
        case .fetchPostById,
             .createPost,
             .updatePostById,
             .updatePostPartly:
            return .applicationJson
        }
    }
    
    var workType: WorkType {
        switch self {
        case .fetchAllPosts,
             .fetchPostById,
             .deletePostById,
             .fetchCommentsByPostId:
            return .requestPlain
            
        case .fetchPostsByUserId(let userId):
            return .requestParameters(parameters: ["userId": userId])
            
        case .createPost(let title,let body,let userId):
            let params: [String: Any] = [
                "title": title,
                "body": body,
                "userId": userId
            ]
            return .requestParameters(parameters: params)
            
        case .updatePostById(let postId, let title, let body, let userId):
            let params: [String: Any] = [
                "title": title,
                "id": postId,
                "body": body,
                "userId": userId
            ]
            return .requestParameters(parameters: params)
            
        case .updatePostPartly(_, let title):
            let params: [String: Any] = [
                "title": title
            ]
            return .requestParameters(parameters: params)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
