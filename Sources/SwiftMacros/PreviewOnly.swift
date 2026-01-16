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
/// ## Usage
///
/// ```swift
/// #previewOnly {
///     print("This only runs in previews")
/// }
/// ```
///
/// ## Expansion
///
/// The macro expands to:
///
/// ```swift
/// {
///     if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
///         print("This only runs in previews")
///     }
/// }()
/// ```
///
/// ## Use Cases
///
/// ### Injecting Mock Data
///
/// ```swift
/// struct ContentView: View {
///     @StateObject var viewModel = ViewModel()
///
///     var body: some View {
///         List(viewModel.items) { item in
///             Text(item.name)
///         }
///         .onAppear {
///             #previewOnly {
///                 viewModel.items = MockData.sampleItems
///             }
///         }
///     }
/// }
/// ```
///
/// ### Debug UI in Previews
///
/// ```swift
/// var body: some View {
///     VStack {
///         MainContent()
///
///         #previewOnly {
///             DebugOverlay()
///         }
///     }
/// }
/// ```
///
/// ### Skipping Expensive Operations
///
/// ```swift
/// func loadData() async {
///     #previewOnly {
///         self.data = MockData.sample
///         return
///     }
///
///     // Real network call only runs in non-preview builds
///     self.data = try await api.fetchData()
/// }
/// ```
///
/// - Parameter body: The code to execute only during Xcode Previews.
@freestanding(expression)
public macro previewOnly(_ body: () -> Void) = #externalMacro(module: "SwiftMacrosPlugin", type: "PreviewOnly")
