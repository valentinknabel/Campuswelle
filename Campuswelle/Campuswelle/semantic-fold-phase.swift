//
//  semantic-fold-phase.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 20.05.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation


enum SemanticalNode {
    typealias Children = [StructuralNode]
    typealias Type = [String]
    
    case Break()
    case Text(String)
    case Smiley(src: NSURL)
    case Image(src: NSURL) //stay in order
    case Picture(src: NSURL)
    case Page(src: NSURL)
    
    case Paragraph(children: Children)
    case Heading(children: Children)
    case Link(url: NSURL, children: Children)
}

