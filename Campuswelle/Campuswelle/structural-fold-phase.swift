//
//  structural-fold-phase.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 20.05.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation


enum HtmlNode {
    case Node(tag: String, attributes: [String: String], children: [HtmlNode])
    case Text(text: String)
    case Nil
}

enum StructuralNode {
    typealias Children = [StructuralNode]
    typealias Type = [String]
    
    case Nil
    case Group(dfghjkwedfghfjghkj)
    
    case Break
    case Text(String)
    case Image(src: String, type: String)
    
    case Paragraph(type: Type, children: Children)
    case Heading(type: Type, children: Children)
    case Link(url: String, type: Type, children: Children)
}

func toHtmlNode(hpple: TFHppleElement) -> HtmlNode {
    if hpple.isTextNode() {
        return HtmlNode.Text(text: hpple.text())
    }
    return HtmlNode.Node(tag: hpple.tagName,
        attributes: hpple.attributes as! [String: String],
        children: map(hpple.children as! [TFHppleElement], toHtmlNode)
    )
}

func foldHtmlNode<T>(html: HtmlNode, initial: T, textFolder: (left: T, text: String) -> T, nodeFolder: (left: T, tag: String, attributes: [String: String], children: [T]) -> T) -> T {
    switch html {
    case .Nil:
        return initial
    case let .Text(text: t):
        return textFolder(left: initial, text: t)
    case let .Node(tag: t, attributes: a, children: cs):
        let flattenedChildren: [T] = map(cs) { c in
            foldHtmlNode(c, initial, textFolder, nodeFolder)
        }
        return nodeFolder(left: initial, tag: t, attributes: a, children: flattenedChildren)
    }
}

func getType(attributes: [String: String]) -> [String] {
    return split((attributes["class"] ?? ""), maxSplit: 0, allowEmptySlices: false, isSeparator: { c in  c == Character(" ") })
}

func combineStructuralNode(lhs: StructuralNode, rhs: StructuralNode) -> StructuralNode {
    switch lhs {
    case .Nil:
        return rhs
    case .Break, .Image(src: _, type: _), .Text(_):
        return StructuralNode.Paragraph(type: [], children: [lhs, rhs])
        
    case .Paragraph(type: let ts, children: var cs):
        cs.append(rhs)
        return .Paragraph(type: ts, children: cs)
    case .Heading(type: let ts, children: var cs):
        cs.append(rhs)
        return .Heading(type: ts, children: cs)
    case .Link(url: let url, type: let ts, children: var cs):
        cs.append(rhs)
        return .Link(url: url, type: ts, children: cs)
    }
}

func toStructuralNode(html: HtmlNode) -> StructuralNode {
    return foldHtmlNode(html, StructuralNode.Nil, { (left, text) -> StructuralNode in
        let node = StructuralNode.Text(text)
        return combineStructuralNode(left, node)
    }) { (left, tag, attributes, children) -> StructuralNode in
        let node: StructuralNode
        switch tag {
        case "br":
            node = .Break
        case "img":
            if let src = attributes["src"] {
                    node = .Image(src: src, type: attributes["class"] ?? "")
            }
            else {
                node = .Nil
            }
        case "p":
            node = StructuralNode.Paragraph(type: getType(attributes), children: children)
        case "h1":
            node = StructuralNode.Heading(type: getType(attributes), children: children)
        case "a":
            if let href = attributes["href"] {
                node = StructuralNode.Link(url: href, type: getType(attributes), children: children)
            }
            else {
                node = StructuralNode.Nil
            }
        default:
            DO NOT THROW NODES AWAY
            node = StructuralNode.Nil
        }
        return combineStructuralNode(left, node)
    }
}
