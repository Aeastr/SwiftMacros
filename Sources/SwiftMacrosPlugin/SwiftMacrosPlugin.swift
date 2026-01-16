//
//  SwiftMacrosPlugin.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct SwiftMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ObfuscatedString.self,
        PreviewOnly.self
    ]
}
