//
//  BuildConfigTests.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import XCTest
@testable import SwiftMacros

final class BuildConfigTests: XCTestCase {

    // MARK: - Basic Types

    func testStringValues() {
        let result = #buildConfig(debug: "debug-value", release: "release-value")
        #if DEBUG
        XCTAssertEqual(result, "debug-value")
        #else
        XCTAssertEqual(result, "release-value")
        #endif
    }

    func testIntValues() {
        let result = #buildConfig(debug: 100, release: 10)
        #if DEBUG
        XCTAssertEqual(result, 100)
        #else
        XCTAssertEqual(result, 10)
        #endif
    }

    func testBoolValues() {
        let result = #buildConfig(debug: true, release: false)
        #if DEBUG
        XCTAssertTrue(result)
        #else
        XCTAssertFalse(result)
        #endif
    }

    func testDoubleValues() {
        let result = #buildConfig(debug: 60.0, release: 30.0)
        #if DEBUG
        XCTAssertEqual(result, 60.0)
        #else
        XCTAssertEqual(result, 30.0)
        #endif
    }

    // MARK: - Complex Types

    func testArrayValues() {
        let result = #buildConfig(debug: [1, 2, 3], release: [4, 5, 6])
        #if DEBUG
        XCTAssertEqual(result, [1, 2, 3])
        #else
        XCTAssertEqual(result, [4, 5, 6])
        #endif
    }

    func testOptionalValues() {
        let result: String? = #buildConfig(debug: "debug", release: nil)
        #if DEBUG
        XCTAssertEqual(result, "debug")
        #else
        XCTAssertNil(result)
        #endif
    }
}
