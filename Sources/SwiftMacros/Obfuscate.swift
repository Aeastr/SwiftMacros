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
///
/// | Rank | Method | Description |
/// |:----:|--------|-------------|
/// | 1 | ``xor`` | XOR with random compile-time key **(default)** |
/// | 2 | ``bitShift`` | Bit rotation with random shift amount |
/// | 3 | ``reversed`` | Bytes stored reversed, flipped at runtime |
/// | 4 | ``base64`` | String → Base64 → byte array |
/// | 5 | ``bytes`` | String → raw UTF-8 byte array |
///
/// ## Choosing a Method
///
/// - **`.xor`** — Best. Random key each build, no recognizable patterns, output varies per compilation.
/// - **`.bitShift`** — Very good. Random rotation each build, bytes transformed beyond recognition.
/// - **`.reversed`** — Good. Simple and fast, string isn't readable forwards in the binary.
/// - **`.base64`** — Moderate. Recognizable Base64 charset/padding if found, but hides from basic analysis.
/// - **`.bytes`** — Minimal. Raw UTF-8 bytes are readable with hex editors. Included for completeness.
///
/// - Tip: For most use cases, `.xor` or `.bitShift` are recommended.
public enum ObfuscationMethod {
    /// **Rank 1** — XOR cipher with random key (default).
    ///
    /// XORs each byte with a random key generated at compile-time.
    /// Best option: no recognizable patterns, output varies per compilation.
    ///
    /// ## Expansion
    /// ```swift
    /// #Obfuscate("Hello", .xor)
    /// ```
    /// Becomes:
    /// ```swift
    /// {
    ///     let bytes: [UInt8] = [171, 158, 169, 169, 168]  // XOR'd bytes
    ///     let key: UInt8 = 203                            // Random key (changes each build)
    ///     return String(bytes: bytes.map { $0 ^ key }, encoding: .utf8)!
    /// }()
    /// ```
    case xor

    /// **Rank 2** — Bit rotation with random shift.
    ///
    /// Rotates bits by a random amount generated at compile-time.
    /// Very good: bytes are transformed beyond recognition, varies per build.
    ///
    /// ## Expansion
    /// ```swift
    /// #Obfuscate("Hello", .bitShift)
    /// ```
    /// Becomes:
    /// ```swift
    /// {
    ///     let bytes: [UInt8] = [144, 202, 216, 216, 222]  // Rotated bytes
    ///     let shift: UInt8 = 3                            // Random shift (changes each build)
    ///     return String(bytes: bytes.map { ($0 &>> shift) | ($0 &<< (8 - shift)) }, encoding: .utf8)!
    /// }()
    /// ```
    case bitShift

    /// **Rank 3** — Reversed byte storage.
    ///
    /// Stores bytes in reverse order, flips them back at runtime.
    /// Good: simple and fast, string isn't readable forwards in the binary.
    ///
    /// ## Expansion
    /// ```swift
    /// #Obfuscate("Hello", .reversed)
    /// ```
    /// Becomes:
    /// ```swift
    /// {
    ///     let bytes: [UInt8] = [111, 108, 108, 101, 72]  // "olleH" reversed
    ///     return String(bytes: bytes.reversed(), encoding: .utf8)!
    /// }()
    /// ```
    case reversed

    /// **Rank 4** — Base64 encoding.
    ///
    /// Converts string to Base64, then stores as byte array.
    /// Recognizable Base64 charset/padding if discovered, but hides from basic analysis.
    ///
    /// ## Expansion
    /// ```swift
    /// #Obfuscate("Hello", .base64)
    /// ```
    /// Becomes:
    /// ```swift
    /// {
    ///     let characters: [UInt8] = [83, 71, 86, 115, 98, 71, 56, 61]  // "SGVsbG8=" as bytes
    ///     let base64 = String(bytes: characters, encoding: .utf8)!
    ///     let data = Data(base64Encoded: base64.data(using: .utf8)!)!
    ///     return String(data: data, encoding: .utf8)!
    /// }()
    /// ```
    case base64

    /// **Rank 5** — Raw byte array.
    ///
    /// Stores string as raw UTF-8 bytes. Weakest obfuscation—bytes are readable
    /// with hex editors. Included for completeness.
    ///
    /// ## Expansion
    /// ```swift
    /// #Obfuscate("Hello", .bytes)
    /// ```
    /// Becomes:
    /// ```swift
    /// {
    ///     let bytes: [UInt8] = [72, 101, 108, 108, 111]  // Raw UTF-8
    ///     return String(bytes: bytes, encoding: .utf8)!
    /// }()
    /// ```
    case bytes
}

/// Obfuscates a string literal at compile-time using XOR (default).
///
/// The macro transforms your string into executable code that reconstructs it at runtime.
/// The original string never appears in the compiled binary, hiding it from static analysis
/// tools like `strings` or hex editors.
///
/// ## Usage
///
/// ```swift
/// let value = #Obfuscate("HelloWorld")
/// // value == "HelloWorld" at runtime
/// ```
///
/// ## Good For
///
/// - Private API usage (class names, selectors)
/// - Internal identifiers and feature flags
/// - Strings you don't want trivially discoverable
///
/// ## Not For
///
/// - API keys, tokens, or secrets — these should never be in client code
/// - Obfuscation ≠ encryption; a determined attacker with a debugger will always win
///
/// - Warning: This raises the bar from "trivial" to "annoying" — it's not real security.
///   If a secret is in your binary, assume it can be extracted.
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
/// ## Usage
///
/// ```swift
/// let value1 = #Obfuscate("HelloWorld", .xor)
/// let value2 = #Obfuscate("HelloWorld", .bitShift)
/// let value3 = #Obfuscate("HelloWorld", .reversed)
/// let value4 = #Obfuscate("HelloWorld", .base64)
/// let value5 = #Obfuscate("HelloWorld", .bytes)
/// ```
///
/// ## Good For
///
/// - Private API usage (class names, selectors)
/// - Internal identifiers and feature flags
/// - Strings you don't want trivially discoverable
///
/// ## Not For
///
/// - API keys, tokens, or secrets — these should never be in client code
/// - Obfuscation ≠ encryption; a determined attacker with a debugger will always win
///
/// - Warning: This raises the bar from "trivial" to "annoying" — it's not real security.
///   If a secret is in your binary, assume it can be extracted.
///
/// - Parameters:
///   - string: A static string literal to obfuscate.
///   - method: The obfuscation method to use. See ``ObfuscationMethod`` for rankings.
/// - Returns: The original string, reconstructed at runtime.
///
/// - Tip: Use ``ObfuscationMethod/xor`` or ``ObfuscationMethod/bitShift`` for best results.
@freestanding(expression)
public macro Obfuscate(_ string: StaticString, _ method: ObfuscationMethod) -> String = #externalMacro(module: "SwiftMacrosPlugin", type: "ObfuscatedString")
