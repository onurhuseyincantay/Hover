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

typealias ResultCompletion = (Result<WeatherResponse, ProviderError>) -> ()

class TestClass {
    let provider = AccNetworkProvider()
    var subscriber: AnyPublisher<WeatherResponse, ProviderError>?
}

// MARK: - Publisher Test Functions
extension TestClass {
    func getWeather() {
        subscriber = provider.request(
            with: TestData.testEndPoint(),
            class: WeatherResponse.self
        )
    }
    
    func getFailingResponse() {
        subscriber = provider.request(
            with: TestData.testFailingResponse(),
            class: WeatherResponse.self
        )
    }
}

// MARK: - Completion Test Functions
extension TestClass {
    func getWeatherWithCompletion(result: @escaping ResultCompletion) {
        provider.request(with: TestData.testEndPoint(),
                         class: WeatherResponse.self, result: result)
    }
    
    func getFailingResponseWithCompletion(result: @escaping ResultCompletion) {
        provider.request(with: TestData.testFailingResponse(),
                         class: WeatherResponse.self, result: result)
    }
}
