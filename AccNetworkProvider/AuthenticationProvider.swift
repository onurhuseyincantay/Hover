//
//  AuthenticationProvider.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

enum AuthProviderType {
    case bearer(token: String)
    case basic(token: String)
    case custom(Any? = nil)
    case none
}
