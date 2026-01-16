//
//  BuildConfig.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct BuildConfig: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        // Get debug and release arguments
        guard node.arguments.count >= 2 else {
            fatalError("#buildConfig requires both debug: and release: arguments")
        }

        var debugValue: ExprSyntax?
        var releaseValue: ExprSyntax?

        for argument in node.arguments {
            if argument.label?.text == "debug" {
                debugValue = argument.expression
            } else if argument.label?.text == "release" {
                releaseValue = argument.expression
            }
        }

        guard let debug = debugValue, let release = releaseValue else {
            fatalError("#buildConfig requires both debug: and release: arguments")
        }

        return """
            {
                #if DEBUG
                return \(debug)
                #else
                return \(release)
                #endif
            }()
            """
    }
}
