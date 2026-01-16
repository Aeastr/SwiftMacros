//
//  PreviewOnly.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import Foundation

/// Executes code only when running in Xcode Previews.
///
/// This macro wraps your code in a check for the `XCODE_RUNNING_FOR_PREVIEWS` environment variable,
/// so it only runs during SwiftUI preview rendering.
///
/// ```swift
/// #previewOnly {
///     print("This only runs in previews")
/// }
/// ```
///
/// Expands to:
/// ```swift
/// if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
///     print("This only runs in previews")
/// }
/// ```
///
/// **Use cases:**
/// - Injecting mock data for previews
/// - Enabling debug UI only in previews
/// - Skipping expensive operations during preview rendering
///
/// - Parameter body: The code to execute only during Xcode Previews.
@freestanding(expression)
public macro previewOnly(_ body: () -> Void) = #externalMacro(module: "SwiftMacrosPlugin", type: "PreviewOnly")
