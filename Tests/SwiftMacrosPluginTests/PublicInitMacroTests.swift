//
//  PublicInitMacroTests.swift
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

final class PublicInitMacroTests: XCTestCase {

    #if canImport(SwiftMacrosPlugin)
    private let testMacros: [String: Macro.Type] = [
        "PublicInit": PublicInit.self,
    ]
    #endif

    // MARK: - Expansion Tests

    func testGeneratesPublicInit() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = """
            @PublicInit
            struct User {
                let name: String
                let age: Int
            }
            """
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("public init"), "Should generate public init")
        XCTAssertTrue(expanded.contains("name: String"), "Should include name parameter")
        XCTAssertTrue(expanded.contains("age: Int"), "Should include age parameter")
        XCTAssertTrue(expanded.contains("self.name = name"), "Should assign name")
        XCTAssertTrue(expanded.contains("self.age = age"), "Should assign age")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testPreservesDefaultValues() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = """
            @PublicInit
            struct Config {
                var timeout: Int = 30
                var enabled: Bool = true
            }
            """
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("timeout: Int = 30"), "Should preserve timeout default")
        XCTAssertTrue(expanded.contains("enabled: Bool = true"), "Should preserve enabled default")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testHandlesMixedProperties() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = """
            @PublicInit
            struct Mixed {
                let required: String
                var optional: Int = 0
            }
            """
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        XCTAssertTrue(expanded.contains("required: String"), "Should include required without default")
        XCTAssertTrue(expanded.contains("optional: Int = 0"), "Should include optional with default")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testSkipsComputedProperties() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = """
            @PublicInit
            struct WithComputed {
                let value: Int
                var doubled: Int { value * 2 }
            }
            """
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        // Check init signature only has value, not doubled
        XCTAssertTrue(expanded.contains("public init(value: Int)"), "Should generate init with only stored property")
        XCTAssertFalse(expanded.contains("doubled: Int)"), "Should not include computed property in init params")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testSkipsStaticProperties() throws {
        #if canImport(SwiftMacrosPlugin)
        let source = """
            @PublicInit
            struct WithStatic {
                let name: String
                static let defaultName = "Unknown"
            }
            """
        let sf = Parser.parse(source: source)
        let context = BasicMacroExpansionContext()
        let expanded = sf.expand(macros: testMacros, in: context).description

        // Check init signature only has name, not defaultName
        XCTAssertTrue(expanded.contains("public init(name: String)"), "Should generate init with only instance property")
        XCTAssertFalse(expanded.contains("defaultName: String"), "Should not include static property in init params")
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
