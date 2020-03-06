import XCTest
@testable import SKVersion

final class SKVersionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let skv = SKVersion.init("a-bundle-id")
        XCTAssertEqual(skv.bundleIdentifier, "a-bundle-id")
        XCTAssertEqual(skv.current, "0.0")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
