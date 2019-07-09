//
//  TestData.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
@testable import AccNetworkProvider

enum TestData {
    case testEndPoint(
        APPID: String = "d48b1d332e3a447a490dd1e620f38a4b",
        units: String = "metric",
        query: String = "Amsterdam"
    )
    
}


extension TestData: NetworkTarget {
    var path: String {
        switch self {
        case .testEndPoint:
            return "weather"
        }
    }
    
    var providerType: AuthProviderType {
        return .none
    }
    
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var methodType: MethodType {
        switch self {
        case .testEndPoint:
            return .get
        }
    }
    
    var workType: WorkType {
        switch self {
        case .testEndPoint(let appID,let unit, let query):
            let params = [
                "APPID": appID,
                "units": unit,
                "q": query
            ]
            return .requestParameters(parameters: params, encoding: .init())
        }
    }
}
