//
//  PreviewOnly.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct PreviewOnly: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let closure = node.trailingClosure ?? node.arguments.first?.expression.as(ClosureExprSyntax.self) else {
            fatalError("#previewOnly requires a closure")
        }

        let statements = closure.statements

        return """
            {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    \(statements)
                }
            }()
            """
    }
}
