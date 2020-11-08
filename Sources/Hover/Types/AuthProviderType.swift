//
//  AuthProviderType.swift
//  Hover
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

public enum AuthProviderType {
    case bearer(token: String)
    case basic(username: String, password: String)
    case none
}
