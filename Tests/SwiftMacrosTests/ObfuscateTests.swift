//
//  ObfuscateTests.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import XCTest
@testable import SwiftMacros

final class ObfuscateTests: XCTestCase {

    // MARK: - XOR (Default)

    func testDefault() {
        let result = #Obfuscate("HelloWorld")
        XCTAssertEqual(result, "HelloWorld")
    }

    func testXOR() {
        let result = #Obfuscate("XORTest", .xor)
        XCTAssertEqual(result, "XORTest")
    }

    // MARK: - Bit Shift

    func testBitShift() {
        let result = #Obfuscate("ShiftMe", .bitShift)
        XCTAssertEqual(result, "ShiftMe")
    }

    // MARK: - Reversed

    func testReversed() {
        let result = #Obfuscate("ReverseMe", .reversed)
        XCTAssertEqual(result, "ReverseMe")
    }

    // MARK: - Base64

    func testBase64() {
        let result = #Obfuscate("Base64Test", .base64)
        XCTAssertEqual(result, "Base64Test")
    }

    // MARK: - Bytes

    func testBytes() {
        let result = #Obfuscate("BytesTest", .bytes)
        XCTAssertEqual(result, "BytesTest")
    }

    // MARK: - Edge Cases

    func testEmptyString() {
        let result = #Obfuscate("")
        XCTAssertEqual(result, "")
    }

    func testStringWithSpaces() {
        let result = #Obfuscate("Hello World Test", .xor)
        XCTAssertEqual(result, "Hello World Test")
    }

    func testSpecialCharacters() {
        let result = #Obfuscate("Test!@#$%^&*()", .base64)
        XCTAssertEqual(result, "Test!@#$%^&*()")
    }

    func testUnicode() {
        let result = #Obfuscate("Hello 世界 🌍", .bytes)
        XCTAssertEqual(result, "Hello 世界 🌍")
    }

    func testLongString() {
        let original = "This is a longer string that tests the obfuscation of more substantial content to ensure it works correctly."
        let result = #Obfuscate("This is a longer string that tests the obfuscation of more substantial content to ensure it works correctly.", .xor)
        XCTAssertEqual(result, original)
    }
}
