//
//  Obfuscate.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import Foundation

/// Available obfuscation methods, ranked by obfuscation strength.
///
/// All methods hide strings from basic static analysis (`strings` command, hex editors).
/// The ranking reflects resistance to manual reverse engineering—for most use cases,
/// any method achieves the same practical goal.
///
/// ## Ranking
/// 1. ``xor`` — Best. Random key, no patterns, varies per build. **(default)**
/// 2. ``bitShift`` — Very good. Random rotation, bytes unrecognizable.
/// 3. ``reversed`` — Good. Simple, fast, string unreadable forwards.
/// 4. ``base64`` — Moderate. Recognizable charset if found.
/// 5. ``bytes`` — Minimal. Raw UTF-8, readable with hex editors.
public enum ObfuscationMethod {
    /// **Rank 1** — XOR cipher with random key (default).
    ///
    /// XORs each byte with a random key generated at compile-time.
    /// Best option: no recognizable patterns, output varies per compilation.
    case xor

    /// **Rank 2** — Bit rotation with random shift.
    ///
    /// Rotates bits by a random amount generated at compile-time.
    /// Very good: bytes are transformed beyond recognition, varies per build.
    case bitShift

    /// **Rank 3** — Reversed byte storage.
    ///
    /// Stores bytes in reverse order, flips them back at runtime.
    /// Good: simple and fast, string isn't readable forwards in the binary.
    case reversed

    /// **Rank 4** — Base64 encoding.
    ///
    /// Converts string to Base64, then stores as byte array.
    /// Recognizable Base64 charset/padding if discovered, but hides from basic analysis.
    case base64

    /// **Rank 5** — Raw byte array.
    ///
    /// Stores string as raw UTF-8 bytes. Weakest obfuscation—bytes are readable
    /// with hex editors. Included for completeness.
    case bytes
}

/// Obfuscates a string literal at compile-time using XOR (default).
///
/// The macro transforms your string into executable code that reconstructs it at runtime.
/// The original string never appears in the compiled binary, hiding it from static analysis
/// tools like `strings` or hex editors.
///
/// ```swift
/// let value = #Obfuscate("HelloWorld")
/// // value == "HelloWorld" at runtime
/// ```
///
/// - Parameter string: A static string literal to obfuscate.
/// - Returns: The original string, reconstructed at runtime.
///
/// - Note: To use a different method, see ``Obfuscate(_:_:)`` and ``ObfuscationMethod``.
@freestanding(expression)
public macro Obfuscate(_ string: StaticString) -> String = #externalMacro(module: "SwiftMacrosPlugin", type: "ObfuscatedString")

/// Obfuscates a string literal at compile-time using the specified method.
///
/// The macro transforms your string into executable code that reconstructs it at runtime.
/// The original string never appears in the compiled binary, hiding it from static analysis
/// tools like `strings` or hex editors.
///
/// ```swift
/// let value1 = #Obfuscate("HelloWorld", .xor)
/// let value2 = #Obfuscate("HelloWorld", .bitShift)
/// let value3 = #Obfuscate("HelloWorld", .reversed)
/// let value4 = #Obfuscate("HelloWorld", .base64)
/// let value5 = #Obfuscate("HelloWorld", .bytes)
/// ```
///
/// - Parameters:
///   - string: A static string literal to obfuscate.
///   - method: The obfuscation method to use. See ``ObfuscationMethod`` for rankings.
/// - Returns: The original string, reconstructed at runtime.
///
/// - Tip: Use ``ObfuscationMethod/xor`` or ``ObfuscationMethod/bitShift`` for best results.
@freestanding(expression)
public macro Obfuscate(_ string: StaticString, _ method: ObfuscationMethod) -> String = #externalMacro(module: "SwiftMacrosPlugin", type: "ObfuscatedString")
