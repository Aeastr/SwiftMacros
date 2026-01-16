//
//  PublicInit.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct PublicInit: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Ensure we're attached to a struct
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.message("@PublicInit can only be applied to structs")
        }

        // Collect stored properties
        var properties: [(name: String, type: TypeSyntax, defaultValue: ExprSyntax?)] = []

        for member in structDecl.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else {
                continue
            }

            // Skip computed properties (those with accessors that aren't just init accessor)
            // Skip static properties
            if varDecl.modifiers.contains(where: { $0.name.text == "static" }) {
                continue
            }

            for binding in varDecl.bindings {
                // Skip computed properties
                if let accessor = binding.accessorBlock {
                    // Shorthand computed property: var x: Int { ... } - CodeBlockSyntax
                    if accessor.accessors.is(CodeBlockItemListSyntax.self) {
                        continue
                    }

                    // Explicit accessor: var x: Int { get { ... } } - AccessorDeclListSyntax
                    if let accessorList = accessor.accessors.as(AccessorDeclListSyntax.self) {
                        let hasGetter = accessorList.contains {
                            $0.accessorSpecifier.text == "get"
                        }
                        if hasGetter {
                            continue
                        }
                    }
                }

                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                      let typeAnnotation = binding.typeAnnotation else {
                    continue
                }

                let propertyName = pattern.identifier.text
                let propertyType = typeAnnotation.type
                let defaultValue = binding.initializer?.value

                properties.append((propertyName, propertyType, defaultValue))
            }
        }

        // Generate parameter list
        let parameters = properties.map { prop -> String in
            if let defaultValue = prop.defaultValue {
                return "\(prop.name): \(prop.type) = \(defaultValue)"
            } else {
                return "\(prop.name): \(prop.type)"
            }
        }.joined(separator: ", ")

        // Generate assignments
        let assignments = properties.map { prop in
            "self.\(prop.name) = \(prop.name)"
        }.joined(separator: "\n        ")

        let initDecl: DeclSyntax = """
            public init(\(raw: parameters)) {
                \(raw: assignments)
            }
            """

        return [initDecl]
    }
}

enum MacroError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}
