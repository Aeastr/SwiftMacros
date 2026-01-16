//
//  BuildConfig.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

/// Returns different values based on build configuration (DEBUG vs RELEASE).
///
/// Use this macro to provide environment-specific values without cluttering your code
/// with `#if DEBUG` checks everywhere.
///
/// ## Usage
///
/// ```swift
/// let apiURL = #buildConfig(debug: "http://localhost:3000", release: "https://api.prod.com")
/// let timeout = #buildConfig(debug: 60, release: 10)
/// let logging = #buildConfig(debug: true, release: false)
/// ```
///
/// ## Expansion
///
/// The macro expands to a compile-time conditional:
///
/// ```swift
/// let apiURL = #buildConfig(debug: "http://localhost:3000", release: "https://api.prod.com")
/// ```
/// Becomes:
/// ```swift
/// let apiURL = {
///     #if DEBUG
///     return "http://localhost:3000"
///     #else
///     return "https://api.prod.com"
///     #endif
/// }()
/// ```
///
/// ## Use Cases
///
/// ### API Endpoints
///
/// ```swift
/// let baseURL = #buildConfig(
///     debug: "https://staging.api.example.com",
///     release: "https://api.example.com"
/// )
/// ```
///
/// ### Feature Flags
///
/// ```swift
/// let enableExperimentalFeatures = #buildConfig(debug: true, release: false)
/// ```
///
/// ### Timeouts & Limits
///
/// ```swift
/// let requestTimeout: TimeInterval = #buildConfig(debug: 120, release: 30)
/// let maxRetries = #buildConfig(debug: 1, release: 3)
/// ```
///
/// - Parameters:
///   - debug: The value to use in DEBUG builds.
///   - release: The value to use in RELEASE builds.
/// - Returns: The appropriate value for the current build configuration.
@freestanding(expression)
public macro buildConfig<T>(debug: T, release: T) -> T = #externalMacro(module: "SwiftMacrosPlugin", type: "BuildConfig")
