//
//  ObfuscatedString.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct ObfuscatedString: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) -> ExprSyntax {
        // Get the string argument
        guard let stringArgument = node.arguments.first?.expression,
              let stringLiteralSyntax = stringArgument.as(StringLiteralExprSyntax.self),
              let string = stringLiteralSyntax.representedLiteralValue else {
            fatalError("Obfuscate requires a string literal")
        }

        // Get the method argument (default to xor)
        let method: String
        if node.arguments.count > 1,
           let methodArg = node.arguments.dropFirst().first?.expression,
           let memberAccess = methodArg.as(MemberAccessExprSyntax.self) {
            method = memberAccess.declName.baseName.text
        } else {
            method = "xor"
        }

        // Generate code based on method
        switch method {
        case "bytes":
            return generateBytes(string)
        case "xor":
            return generateXOR(string)
        case "bitShift":
            return generateBitShift(string)
        case "reversed":
            return generateReversed(string)
        default:
            return generateBase64(string)
        }
    }

    // MARK: - Base64 (default)

    private static func generateBase64(_ string: String) -> ExprSyntax {
        let base64String = string.data(using: .utf8)!.base64EncodedString()
        let characters = base64String.utf8.map { UInt8($0) }

        return """
            {
                let characters: [UInt8] = \(raw: characters)
                let base64 = String(bytes: characters, encoding: .utf8)!
                let data = Data(base64Encoded: base64.data(using: .utf8)!)!
                return String(data: data, encoding: .utf8)!
            }()
        """
    }

    // MARK: - Raw Bytes

    private static func generateBytes(_ string: String) -> ExprSyntax {
        let bytes = Array(string.utf8)

        return """
            {
                let bytes: [UInt8] = \(raw: bytes)
                return String(bytes: bytes, encoding: .utf8)!
            }()
        """
    }

    // MARK: - XOR

    private static func generateXOR(_ string: String) -> ExprSyntax {
        let key = UInt8.random(in: 1...255)
        let bytes = string.utf8.map { $0 ^ key }

        return """
            {
                let bytes: [UInt8] = \(raw: bytes)
                let key: UInt8 = \(raw: key)
                return String(bytes: bytes.map { $0 ^ key }, encoding: .utf8)!
            }()
        """
    }

    // MARK: - Bit Shift

    private static func generateBitShift(_ string: String) -> ExprSyntax {
        let shift = UInt8.random(in: 1...7)
        let bytes = string.utf8.map { byte -> UInt8 in
            return (byte &<< shift) | (byte &>> (8 - shift))
        }

        return """
            {
                let bytes: [UInt8] = \(raw: bytes)
                let shift: UInt8 = \(raw: shift)
                return String(bytes: bytes.map { ($0 &>> shift) | ($0 &<< (8 - shift)) }, encoding: .utf8)!
            }()
        """
    }

    // MARK: - Reversed

    private static func generateReversed(_ string: String) -> ExprSyntax {
        let bytes = Array(string.utf8).reversed().map { $0 }

        return """
            {
                let bytes: [UInt8] = \(raw: bytes)
                return String(bytes: bytes.reversed(), encoding: .utf8)!
            }()
        """
    }
}
