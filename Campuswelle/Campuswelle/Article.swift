//
//  Article.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

protocol News {
    var article: Article { get }
}

struct Article: News, Printable {
    
    var article: Article {
        return self
    }
    
    let title: String
    let link: NSURL
    let desc: String
    let categories: [String]
    let content: String
    
    let imageUrls: [NSURL]
    let videoUrls: [NSURL]
    
    var description: String {
        return "A: \(title)"
    }
}
