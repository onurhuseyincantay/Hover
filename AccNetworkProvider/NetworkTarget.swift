//
//  NetworkTarget.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation


protocol NetworkTarget {
    var baseURL: URL { get }
    var path: String { get }
    var methodType: MethodType { get }
    var workType: WorkType { get }
    var providerType: AuthProviderType { get }
}

extension NetworkTarget {
    var pathAppendedURL: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
}
