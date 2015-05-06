//
//  news-html.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 06.05.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

func contentHtmlMapper(content: String) -> TFHpple {
    let data = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    let document: TFHpple = TFHpple(HTMLData: data)
    return document
}

func htmlImageMapper(document: TFHpple) -> [NSURL] {
    let elements: [TFHppleElement] = document.searchWithXPathQuery("img[@url]") as! [TFHppleElement]
    var result: [NSURL] = []
    for e in elements {
        let dict = e.attributes as! [String:String]
        result.append(NSURL(string: dict["url"]!)!)
    }
    return result
}

func htmlVideoMapper(document: TFHpple) -> [NSURL] {
    let elements: [TFHppleElement] = document.searchWithXPathQuery("source[@src]") as! [TFHppleElement]
    var result: [NSURL] = []
    for e in elements {
        let dict = e.attributes as! [String:String]
        result.append(NSURL(string: dict["src"]!)!)
    }
    return result
}

