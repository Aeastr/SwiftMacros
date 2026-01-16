//
//  PublicInit.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

/// Generates a public memberwise initializer for a struct.
///
/// Swift's auto-generated memberwise initializer is `internal` by default.
/// This macro generates a `public` initializer with all stored properties as parameters.
///
/// ## Usage
///
/// ```swift
/// @PublicInit
/// public struct User {
///     let id: UUID
///     let name: String
///     let email: String
/// }
/// ```
///
/// ## Expansion
///
/// The macro generates:
///
/// ```swift
/// public struct User {
///     let id: UUID
///     let name: String
///     let email: String
///
///     public init(id: UUID, name: String, email: String) {
///         self.id = id
///         self.name = name
///         self.email = email
///     }
/// }
/// ```
///
/// ## Default Values
///
/// Properties with default values include them in the generated initializer:
///
/// ```swift
/// @PublicInit
/// public struct Settings {
///     var theme: String = "light"
///     var fontSize: Int = 14
/// }
///
/// // Generates:
/// // public init(theme: String = "light", fontSize: Int = 14) { ... }
/// ```
///
/// ## Use Cases
///
/// ### Public API Types
///
/// ```swift
/// @PublicInit
/// public struct APIResponse<T: Codable> {
///     let data: T
///     let statusCode: Int
///     let headers: [String: String]
/// }
/// ```
///
/// ### Configuration Structs
///
/// ```swift
/// @PublicInit
/// public struct NetworkConfig {
///     var baseURL: URL
///     var timeout: TimeInterval = 30
///     var retryCount: Int = 3
/// }
/// ```
///
/// - Note: This macro only works on structs. Applying it to classes or other types will result in an error.
@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "SwiftMacrosPlugin", type: "PublicInit")
