//
//  CommentSubscriber.swift
//  HoverTests
//
//  Created by Onur Hüseyin Çantay on 11.07.2019.
//  Copyright © 2019 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import Combine
@testable import Hover

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
class CommentSubscriber: Subscriber {
  typealias Input = CommentsResponse
  typealias Failure = ProviderError
  
  let publisher = PassthroughSubject<Input, Failure>()
  
  func receive(subscription: Subscription) {
    subscription.request(.unlimited)
  }
  
  func receive(_ input: CommentsResponse) -> Subscribers.Demand {
    publisher.send(input)
    return Subscribers.Demand.unlimited
  }
  func receive(completion: Subscribers.Completion<ProviderError>) {
    publisher.send(completion: completion)
  }
}
