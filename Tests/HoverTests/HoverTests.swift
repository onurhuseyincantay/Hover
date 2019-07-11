import XCTest
@testable import Hover

final class HoverTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Hover().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
