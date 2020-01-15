# Hover
[![apm](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/onurhuseyincantay/Hover/blob/develop/License.md)[![CocoaPods compatible](https://img.shields.io/cocoapods/v/HoverKitSDK.svg)](https://cocoapods.org/pods/HoverKitSDK)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)</br>

## Currently Available
| Platform      | Version       |
| ------------- |:------------- | 
| iOS           | 13.0          |
| tvOS          | 13.0          |
| macOS         | 10.15         |
| watchOS       | 6.0           |
| macCatalyst   | 13.0          |

Hover is a Network layer which uses Apple's new framework `Combine` and provides async network calls with different kind of request functions.
#### Cocoapods Installation
```swift
target 'MyApp' do
  pod 'HoverKitSDK', '~> 1.0.2'
end
```

#### Carthage Installation
```swift
github "onurhuseyincantay/Hover" ~> 1.0.2
```

#### Swift Package Manager Installation
Package            |  branch
:-------------------------:|:-------------------------:
<img height="250" src="Screenshots/package.png" />  |   <img height="250" src="Screenshots/branchname.png" />




# Sample Usage
#### Provide Target
```swift
 enum UserTarget {
  case login(email: String, password: String) 
 }
 
 extension UserTarget: NetworkTarget { 
    var path: String {
        switch self {
        ...
    }
    var providerType: AuthProviderType {
        ...
    }
    
    var baseURL: URL {
        ...
    }
    
    var methodType: MethodType {
        switch self {
          ...
        }
    }
    
    var contentType: ContentType? {
        switch self {
         ...
        }
    }
    
    var workType: WorkType {
        switch self {
          ...
        }
    }
    
    var headers: [String : String]? {
        ...
    }
 }
```
#### Request With Publisher
```swift
let provider = Hover()
let publisher = provider.request(
            with: UserTarget.login(email: "ohc3807@gmail.com", password: "123456")
            class: UserModel.self
        )
...
publisher.sink({ ... })
```

#### Request With Subscriber
```swift
let provider = Hover()
let userSubscriber = UserSubscriber()
provider.request(with: UserTarget.login(email: "ohc3807@gmail.com", password: "123456"), class: UserModel.self, subscriber: userSubscriber)
```

Tested with [JsonPlaceholder](https://jsonplaceholder.typicode.com)
Inspired By [Moya](https://github.com/Moya/Moya/blob/master) Developed with 🧡

