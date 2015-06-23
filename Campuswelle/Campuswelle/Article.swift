//
//  Article.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

public protocol News {
    var article: Article { get }
}

public struct Article: News, CustomStringConvertible {
    
    public var article: Article {
        return self
    }
    
    public let title: String
    public let link: NSURL
    public let desc: String
    public let categories: [String]
    public let content: String
    
    public let imageUrls: [NSURL]
    public let videoUrls: [NSURL]
    
    public var description: String {
        return "A: \(title)"
    }
}
