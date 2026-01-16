<div align="center">
  <h1><b>SwiftMacros</b></h1>
  <p>
    A collection of useful Swift macros.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-13+-000000?logo=apple" alt="iOS 13+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/macOS-10.15+-000000?logo=apple" alt="macOS 10.15+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/tvOS-13+-000000?logo=apple" alt="tvOS 13+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/watchOS-6+-000000?logo=apple" alt="watchOS 6+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/visionOS-1+-000000?logo=apple" alt="visionOS 1+"></a>
  <a href="https://github.com/Aeastr/SwiftMacros/actions/workflows/tests.yml"><img src="https://github.com/Aeastr/SwiftMacros/actions/workflows/tests.yml/badge.svg" alt="Tests"></a>
</p>


## Overview

- **`#Obfuscate`** — Compile-time string obfuscation to hide strings from static analysis
- **`#previewOnly`** — Execute code only when running in Xcode Previews
- **`#buildConfig`** — Different values for DEBUG vs RELEASE builds
- **`@PublicInit`** — Generate public memberwise initializer for structs


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/SwiftMacros.git", from: "1.0.0")
]
```

```swift
import SwiftMacros
```

> [!NOTE]
> Xcode will prompt you to trust macros from this package on first use. Click "Trust & Enable" to proceed.


## Usage

### #Obfuscate

Hide strings from static analysis tools (`strings`, hex editors, etc).

```swift
let secret = #Obfuscate("MySecretString")
```

With explicit method:

```swift
let secret = #Obfuscate("MySecretString", .xor)       // default, best
let secret = #Obfuscate("MySecretString", .bitShift)  // very good
let secret = #Obfuscate("MySecretString", .reversed)  // good
let secret = #Obfuscate("MySecretString", .base64)    // moderate
let secret = #Obfuscate("MySecretString", .bytes)     // minimal
```

> [!CAUTION]
> This is obfuscation, not encryption. It raises the bar from "trivial" to "annoying" — a determined attacker with a debugger will always win. Never use for API keys or secrets.

### #previewOnly

Execute code only when running in Xcode Previews.

```swift
#previewOnly {
    viewModel.loadMockData()
}
```

Expands to the `ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"` check.

### #buildConfig

Different values based on build configuration.

```swift
let apiURL = #buildConfig(debug: "http://localhost:3000", release: "https://api.prod.com")
let timeout = #buildConfig(debug: 60, release: 10)
```

Expands to `#if DEBUG` / `#else` / `#endif`.

### @PublicInit

Generate a public memberwise initializer for structs.

```swift
@PublicInit
public struct User {
    let id: UUID
    let name: String
    var isActive: Bool = true
}

// Generates:
// public init(id: UUID, name: String, isActive: Bool = true) { ... }
```


## Contributing

Contributions welcome. Please feel free to submit a Pull Request.


## License

MIT. See [LICENSE](LICENSE) for details.
