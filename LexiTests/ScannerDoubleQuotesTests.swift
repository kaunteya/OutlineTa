import XCTest
@testable import JSONSyntax

class ScannerDoubleQuotesTests: XCTestCase {
    func testStringInDoubleQuote() {
        let scanner = Scanner.make(#""Raju" is here"#)
        XCTAssertEqual(scanner.scanStringInDoubleQuotes()!, #""Raju""#)
    }

    func testWithWhiteSpace() {
        let scanner = Scanner.make(#""Raju is" here"#)
        XCTAssertEqual(scanner.scanStringInDoubleQuotes()!, #""Raju is""#)
    }

    func testWithWhiteSplChars() {
        let scanner = Scanner.make(#""Raju is @#$$$$here" sdf "#)
        XCTAssertEqual(scanner.scanStringInDoubleQuotes()!, #""Raju is @#$$$$here""#)
    }

    func testStringWithQuote() {
        let scanner = Scanner.make(#""A1\"bw" T"#)
        XCTAssertEqual(scanner.scanStringInDoubleQuotes()!, #""A1\"bw""#)
    }

    func testWithEmptyQuotes() {
        let scanner = Scanner.make("\"\"")
        XCTAssertEqual(scanner.scanStringInDoubleQuotes()!, scanner.string)
    }

    // No string with double quote present
    func testBasicFail() {
        let scanner = Scanner.make(#"Raju is here"#)
        XCTAssertNil(scanner.scanStringInDoubleQuotes())
    }

    func testEmptyFail() {
        let scanner = Scanner.make("")
        XCTAssertNil(scanner.scanStringInDoubleQuotes())
    }

    func testSingleQuoteInString() {
        let scanner = Scanner.make(#""Raju is here"#)
        XCTAssertNil(scanner.scanStringInDoubleQuotes())
    }

    func testStringEndByNewLine() {
        let str = "\"abc\ndef"
        let scanner = Scanner.make(str)
        let expectedCursorIndex = str.index(str.startIndex, offsetBy: 5)
        XCTAssertNil(scanner.scanStringInDoubleQuotes())
        XCTAssertEqual(scanner.currentIndex, expectedCursorIndex)
    }
}
