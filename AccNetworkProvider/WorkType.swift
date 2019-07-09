//
//  WorkType.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 5.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation


enum WorkType {
    case requestPlain
    case requestData
    case requestParameters(parameters: [String: Any], encoding: JSONEncoder)
}
