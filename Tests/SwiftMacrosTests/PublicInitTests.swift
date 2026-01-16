//
//  PublicInitTests.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import XCTest
@testable import SwiftMacros

// MARK: - Test Structs

@PublicInit
public struct SimpleStruct {
    let name: String
    let value: Int
}

@PublicInit
public struct StructWithDefaults {
    let required: String
    var optional: Int = 42
    var flag: Bool = true
}

@PublicInit
public struct StructWithOptionals {
    let id: Int
    var name: String?
    var data: [String]?
}

@PublicInit
public struct GenericStruct<T> {
    let value: T
    let label: String
}

// MARK: - Tests

final class PublicInitTests: XCTestCase {

    // MARK: - Basic Initialization

    func testSimpleStruct() {
        let instance = SimpleStruct(name: "Test", value: 123)
        XCTAssertEqual(instance.name, "Test")
        XCTAssertEqual(instance.value, 123)
    }

    // MARK: - Default Values

    func testStructWithAllDefaults() {
        let instance = StructWithDefaults(required: "Required")
        XCTAssertEqual(instance.required, "Required")
        XCTAssertEqual(instance.optional, 42)
        XCTAssertTrue(instance.flag)
    }

    func testStructOverridingDefaults() {
        let instance = StructWithDefaults(required: "Required", optional: 100, flag: false)
        XCTAssertEqual(instance.required, "Required")
        XCTAssertEqual(instance.optional, 100)
        XCTAssertFalse(instance.flag)
    }

    func testStructPartialDefaults() {
        let instance = StructWithDefaults(required: "Required", optional: 99)
        XCTAssertEqual(instance.required, "Required")
        XCTAssertEqual(instance.optional, 99)
        XCTAssertTrue(instance.flag)
    }

    // MARK: - Optional Properties

    func testStructWithNilOptionals() {
        let instance = StructWithOptionals(id: 1, name: nil, data: nil)
        XCTAssertEqual(instance.id, 1)
        XCTAssertNil(instance.name)
        XCTAssertNil(instance.data)
    }

    func testStructWithSetOptionals() {
        let instance = StructWithOptionals(id: 2, name: "Name", data: ["a", "b"])
        XCTAssertEqual(instance.id, 2)
        XCTAssertEqual(instance.name, "Name")
        XCTAssertEqual(instance.data, ["a", "b"])
    }

    // MARK: - Generics

    func testGenericStructWithString() {
        let instance = GenericStruct(value: "Hello", label: "Greeting")
        XCTAssertEqual(instance.value, "Hello")
        XCTAssertEqual(instance.label, "Greeting")
    }

    func testGenericStructWithInt() {
        let instance = GenericStruct(value: 42, label: "Answer")
        XCTAssertEqual(instance.value, 42)
        XCTAssertEqual(instance.label, "Answer")
    }
}
