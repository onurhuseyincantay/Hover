//
//  TestClass.swift
//  Acc
//
//  Created by Onur Hüseyin Çantay on 8.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import Combine
@testable import AccNetworkProvider

class TestClass {
    let provider = AccNetworkProvider()
    var subscriber: AnyPublisher<WeatherResponse, ProviderError>?
    
    func getWeather() throws {
        subscriber = try provider.request(
            with: TestData.testEndPoint(),
            class: WeatherResponse.self
        )
    }
}
