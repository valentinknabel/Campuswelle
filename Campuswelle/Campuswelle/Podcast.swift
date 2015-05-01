//
//  Podcast.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

struct Podcast: News {
    let article: Article
    
    let subtitle: String
    let summary: String
    let enclosure: NSURL
    let duration: NSTimeInterval
}