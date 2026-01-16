//
//  BuildConfigMacroTests.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMacrosPlugin)
import SwiftMacrosPlugin
#endif

final class BuildConfigMacroTests: XCTestCase {

    #if canImport(SwiftMacrosPlugin)
    private let testMacros: [String: Macro.Type] = [
        "buildConfig": BuildConfig.self,
    ]
    #endif

    // MARK: - Expansion Tests

    func testExpandsToIfDebug() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = #"#buildConfig(debug: "localhost", release: "prod.com")"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("#if DEBUG"), "Should contain #if DEBUG")
        XCTAssertTrue(expanded.contains("#else"), "Should contain #else")
        XCTAssertTrue(expanded.contains("#endif"), "Should contain #endif")
        XCTAssertTrue(expanded.contains("localhost"), "Should contain debug value")
        XCTAssertTrue(expanded.contains("prod.com"), "Should contain release value")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testExpandsWithIntValues() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = #"#buildConfig(debug: 100, release: 10)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("100"), "Should contain debug value")
        XCTAssertTrue(expanded.contains("10"), "Should contain release value")
        XCTAssertTrue(expanded.contains("#if DEBUG"), "Should contain #if DEBUG")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testExpandsWithBoolValues() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = #"#buildConfig(debug: true, release: false)"#
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("true"), "Should contain debug value")
        XCTAssertTrue(expanded.contains("false"), "Should contain release value")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
