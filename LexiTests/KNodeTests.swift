//
//  KNodeTests.swift
//  KNodeTests
//
//  Created by Kaunteya Suryawanshi on 21/07/19.
//  Copyright © 2019 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest
@testable import Lexi

class KNodeTests: XCTestCase {
    func testBasic() {
        let testString = """
{
  "person": {
    "age": 33,
    "first": "Steve",
    "last": "Jobs"
  }
}
"""
        do {
            let gr = try KNode(string: testString)!
            XCTAssertNil(gr.key)
            XCTAssertEqual(gr.children!.count, 1)

            let innerObj = gr.children!.firstObject as! KNode
            XCTAssertEqual(innerObj.children!.count, 3)

            let age = innerObj.children!.firstObject as! KNode
            XCTAssertEqual(age.key!, "age")
            XCTAssertEqual(age.stringValue, "33")

            let first = innerObj.children![1] as! KNode
            XCTAssertEqual(first.key!, "first")
            XCTAssertEqual(first.stringValue!, "Steve")

            XCTAssertEqual(first.parent!.key!, "person")
        } catch {
            XCTFail("Failed")
        }
    }
}
