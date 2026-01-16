<div align="center">
  <h1><b>SwiftMacros</b></h1>
  <p>
    A collection of useful Swift macros.
  </p>
</div>

<p align="center">
  <a href="https://github.com/Aeastr/SwiftMacros/actions/workflows/tests.yml"><img src="https://github.com/Aeastr/SwiftMacros/actions/workflows/tests.yml/badge.svg" alt="Tests"></a>
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-13+-000000?logo=apple" alt="iOS 13+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/macOS-10.15+-000000?logo=apple" alt="macOS 10.15+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/tvOS-13+-000000?logo=apple" alt="tvOS 13+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/watchOS-6+-000000?logo=apple" alt="watchOS 6+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/visionOS-1+-000000?logo=apple" alt="visionOS 1+"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
</p>


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/SwiftMacros.git", from: "1.0.0")
]
```

```swift
import SwiftMacros
```


## Macros

### #Obfuscate

Compile-time string obfuscation macro. Hides strings from static analysis tools like `strings`, hex editors, and automated scanners.

**Good for:**
- Private API usage (class names, selectors)
- Internal identifiers and feature flags
- Strings you don't want trivially discoverable

**Not for:**
- API keys, tokens, or secrets — these should never be in client code
- Obfuscation ≠ encryption; a determined attacker with a debugger will always win

> [!CAUTION]
> This raises the bar from "trivial" to "annoying" — it's not real security. If a secret is in your binary, assume it can be extracted.

#### Usage

```swift
// Default (XOR)
let secret = #Obfuscate("MySecretString")

// With explicit method
let secret = #Obfuscate("MySecretString", .xor)
let secret = #Obfuscate("MySecretString", .bitShift)
let secret = #Obfuscate("MySecretString", .reversed)
let secret = #Obfuscate("MySecretString", .base64)
let secret = #Obfuscate("MySecretString", .bytes)
```

> [!NOTE]
> Xcode will prompt you to trust macros from this package on first use. This is standard for Swift macro packages—click "Trust & Enable" to proceed.

#### Methods

All methods hide strings from basic static analysis (`strings` command, hex editors). Ranked by obfuscation strength:

| Rank | Method | Description |
|:----:|--------|-------------|
| 1 | `.xor` | XOR with random compile-time key (default) |
| 2 | `.bitShift` | Bit rotation with random shift amount |
| 3 | `.reversed` | Bytes stored reversed, flipped at runtime |
| 4 | `.base64` | String → Base64 → byte array |
| 5 | `.bytes` | String → raw UTF-8 byte array |

**Which to use?**

- **`.xor`** — Best. Random key each build, no recognizable patterns, output varies per compilation.
- **`.bitShift`** — Very good. Random rotation each build, bytes are transformed beyond recognition.
- **`.reversed`** — Good. Simple and fast, string isn't readable forwards in the binary.
- **`.base64`** — Moderate. Recognizable Base64 charset/padding if found, but hides from basic analysis.
- **`.bytes`** — Minimal. Raw UTF-8 bytes are readable with hex editors. Included for completeness.

> [!TIP]
> For most use cases, `.xor` or `.bitShift` are recommended. All methods achieve the same goal—the ranking reflects resistance to manual reverse engineering.

#### How It Works

At compile-time, the macro transforms your string into executable code that reconstructs it at runtime. The original string never appears in the binary.

<details>
<summary><b>.xor</b> — XOR each byte with a random key</summary>

```swift
#Obfuscate("Hello", .xor)
```
Becomes:
```swift
{
    let bytes: [UInt8] = [171, 158, 169, 169, 168]  // XOR'd bytes
    let key: UInt8 = 203                            // Random key (changes each build)
    return String(bytes: bytes.map { $0 ^ key }, encoding: .utf8)!
}()
```
</details>

<details>
<summary><b>.bitShift</b> — Rotate bits by a random amount</summary>

```swift
#Obfuscate("Hello", .bitShift)
```
Becomes:
```swift
{
    let bytes: [UInt8] = [144, 202, 216, 216, 222]  // Rotated bytes
    let shift: UInt8 = 3                            // Random shift (changes each build)
    return String(bytes: bytes.map { ($0 &>> shift) | ($0 &<< (8 - shift)) }, encoding: .utf8)!
}()
```
</details>

<details>
<summary><b>.reversed</b> — Store bytes in reverse order</summary>

```swift
#Obfuscate("Hello", .reversed)
```
Becomes:
```swift
{
    let bytes: [UInt8] = [111, 108, 108, 101, 72]  // "olleH" reversed
    return String(bytes: bytes.reversed(), encoding: .utf8)!
}()
```
</details>

<details>
<summary><b>.base64</b> — Encode as Base64, store as bytes</summary>

```swift
#Obfuscate("Hello", .base64)
```
Becomes:
```swift
{
    let characters: [UInt8] = [83, 71, 86, 115, 98, 71, 56, 61]  // "SGVsbG8=" as bytes
    let base64 = String(bytes: characters, encoding: .utf8)!
    let data = Data(base64Encoded: base64.data(using: .utf8)!)!
    return String(data: data, encoding: .utf8)!
}()
```
</details>

<details>
<summary><b>.bytes</b> — Store as raw UTF-8 bytes</summary>

```swift
#Obfuscate("Hello", .bytes)
```
Becomes:
```swift
{
    let bytes: [UInt8] = [72, 101, 108, 108, 111]  // Raw UTF-8
    return String(bytes: bytes, encoding: .utf8)!
}()
```
</details>


## License

MIT. See [LICENSE](LICENSE) for details.
