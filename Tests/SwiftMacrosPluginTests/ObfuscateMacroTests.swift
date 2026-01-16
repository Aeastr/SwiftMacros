//
//  ObfuscateMacroTests.swift
//  Obfuscate
//
//  Created by Aether on 14/01/2026.
//
//  NOTE: These tests verify strings are actually obfuscated (not just decoded correctly).
//  Due to Xcode limitations with SwiftSyntax macro testing, run via CLI:
//    xcodebuild test -scheme Obfuscate -destination 'platform=macOS'
//

import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(ObfuscateMacro)
import ObfuscateMacro
#endif

final class ObfuscateMacroTests: XCTestCase {

    #if canImport(ObfuscateMacro)
    private let testMacros: [String: Macro.Type] = [
        "Obfuscate": ObfuscatedString.self,
    ]
    #endif

    // MARK: - XOR (Default)

    func testXORObfuscatesString() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("SecretString", .xor)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        // Original string should NOT appear in expanded code
        XCTAssertFalse(expanded.contains("\"SecretString\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("[UInt8]"), "Should contain byte array")
        XCTAssertTrue(expanded.contains("^ key"), "Should contain XOR operation")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testDefaultUsesXOR() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("TestDefault")"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        // Default should use XOR
        XCTAssertFalse(expanded.contains("\"TestDefault\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("^ key"), "Default should use XOR")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    // MARK: - Bit Shift

    func testBitShiftObfuscatesString() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("ShiftTest", .bitShift)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertFalse(expanded.contains("\"ShiftTest\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("[UInt8]"), "Should contain byte array")
        XCTAssertTrue(expanded.contains("shift"), "Should contain shift variable")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    // MARK: - Reversed

    func testReversedObfuscatesString() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("ReverseTest", .reversed)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertFalse(expanded.contains("\"ReverseTest\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("[UInt8]"), "Should contain byte array")
        XCTAssertTrue(expanded.contains(".reversed()"), "Should contain reversed() call")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    // MARK: - Base64

    func testBase64ObfuscatesString() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("Base64Test", .base64)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertFalse(expanded.contains("\"Base64Test\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("[UInt8]"), "Should contain byte array")
        XCTAssertTrue(expanded.contains("base64Encoded"), "Should contain base64 decoding")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    // MARK: - Bytes

    func testBytesObfuscatesString() throws {
        #if canImport(ObfuscateMacro)
        let source = #"#Obfuscate("BytesTest", .bytes)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertFalse(expanded.contains("\"BytesTest\""), "Original string should not appear in expanded code")
        XCTAssertTrue(expanded.contains("[UInt8]"), "Should contain byte array")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
