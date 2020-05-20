import XCTest
@testable import JSONSyntax

class StringExtensionTests: XCTestCase {
    func testIndentation() {
        func testA(_ str: String, location: Int, outcome: Int) {
            let locIndex = str.index(str.startIndex, offsetBy: location)
            XCTAssertEqual(str.indentationAt(loc: locIndex), outcome)
        }

        testA("    far", location: 5, outcome: 4)
        testA("", location: 0, outcome: 0)
        testA("far", location: 1, outcome: 0)

        let long = "{\n    \"far\": \"cry\",\n    \"new\": {\n        \"Shark\": \"Tank\"\n    }\n}"
        testA(long, location: 31, outcome: 4)
        testA(long, location: 56, outcome: 8)
    }

    func testIsInsideBraces() {
        do {
            let str = ""
            let locIndex = str.index(str.startIndex, offsetBy: 0)
            XCTAssertFalse("".isInsideBracesOrBrackets(at: locIndex))
        }

        do {
            let str = "{}"
            let locIndex = str.index(str.startIndex, offsetBy: 0)
            XCTAssertFalse("{}".isInsideBracesOrBrackets(at: locIndex))
        }
        do {
            let str = "{}"
            let locIndex = str.index(str.startIndex, offsetBy: 1)
            XCTAssertTrue("{}".isInsideBracesOrBrackets(at: locIndex))
        }
        do {
            let str = "{}"
            let locIndex = str.index(str.startIndex, offsetBy: 2)
            XCTAssertFalse("{}".isInsideBracesOrBrackets(at: locIndex))
        }

        do {
            let str = "[]"
            let locIndex = str.index(str.startIndex, offsetBy: 0)
            XCTAssertFalse("[]".isInsideBracesOrBrackets(at: locIndex))
        }
        do {
            let str = "[]"
            let locIndex = str.index(str.startIndex, offsetBy: 1)
            XCTAssertTrue("[]".isInsideBracesOrBrackets(at: locIndex))
        }
        do {
            let str = "[]"
            let locIndex = str.index(str.startIndex, offsetBy: 2)
            XCTAssertFalse("[]".isInsideBracesOrBrackets(at: locIndex))
        }

        do {
            let str = "asd"
            let locIndex = str.index(str.startIndex, offsetBy: 1)
            XCTAssertFalse("asd".isInsideBracesOrBrackets(at: locIndex))
        }
    }
}
