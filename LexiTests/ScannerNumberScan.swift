import XCTest
@testable import JSONSyntax

class ScannerNumberTests: XCTestCase {
    func testNumberInString() {
        XCTAssertEqual(Scanner.make("123").scanNumberInString()!, "123")

        XCTAssertNil(Scanner.make("ABCD").scanNumberInString())

        let sc1 = Scanner.make("-123")
        XCTAssertEqual(sc1.scanNumberInString()!, "-123")

        let sc2 = Scanner.make("12.3")
        XCTAssertEqual(sc2.scanNumberInString()!, "12.3")
    }
}
