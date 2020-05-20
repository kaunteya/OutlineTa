//
//  ToTextTests.swift
//  LexiTests
//
//  Created by Kaunteya Suryawanshi on 26/07/19.
//  Copyright © 2019 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest
@testable import Lexi

/// Checks if the Text formatting is working fine
class ToTextTests: XCTestCase {
    /// A KNode element is created from string. Then KNode converts it to pretty string
    /// and checked if it matches original string
    func baseTester(jsonString: String, isWrapped: Bool) -> String {
        let element = try! KNode(string: jsonString)!

        //NOTE: Uncomment to debug
        let f = element.toText(formatting: JSONTextFormatter.spaceCount(2))
                print("------------------------")
                print(jsonString)
                print("------------------------")
                print(f)
                print("------------------------")
        return f
    }

    func test1() {
        let testString = """
{
  "person": {
    "age": 33,
    "first": "Steve",
    "last": "Jobs"
  }
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test2() {
        let testString = """
{
  "age": 33,
  "first": "Steve",
  "last": "Jobs"
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test3() {
        let testString = """
{
  "age": 33,
  "first": "Steve",
  "last": "Jobs",
  "numbers": [
    1,
    2,
    3
  ]
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test4() {
        let testString = """
{
  "age": 33,
  "first": "Steve",
  "last": "Jobs",
  "numbers": [
    1,
    2,
    3
  ]
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test5() {
        let testString = """
[
  {
    "date": "2019-02-13T18:30:00Z",
    "name": "Rob"
  },
  {
    "date": "2019-02-13T18:30:00Z",
    "name": "Tony"
  },
  {
    "date": "2019-02-13T18:30:00Z",
    "name": "Dan"
  }
]
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test6() {
        let testString = """
{
  "age": 33,
  "last": "Jobs",
  "numbers": []
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test7() {
        let testString = """
{
  "age": 33,
  "numbers": {},
  "zlast": "Jobs"
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test8() {
        let testString = """
{
  "age": 33,
  "numbers": {},
  "zlast": null
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test9() {
        let testString = """
{
  "age": 33.33,
  "numbers": {},
  "zlast": null
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test10() {
        let testString = """
{
  "age": 33.33
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func test11() {
        let testString = """
{
  "lucky_numbers": [
    3,
    13,
    32,
    33
  ]
}
"""
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }

    func testEscapedStrings() {
        let testString = #"""
{
  "a\\b": "pCr`Xel\\Jdm\\}",
  "b\nh": "sdfsd\nwdf'f"
}
"""#
        let converted = baseTester(jsonString: testString, isWrapped: false)
        XCTAssertEqual(testString, converted)
    }
}
