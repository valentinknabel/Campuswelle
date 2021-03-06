//
//  Podcast.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

public struct Podcast: News {
    public let article: Article
    
    public let subtitle: String
    public let summary: String
    public let enclosure: NSURL
    public let duration: NSTimeInterval
}

 extension Podcast: Equatable { }

public func ==(lhs: Podcast, rhs: Podcast) -> Bool {
    return lhs.article == rhs.article
        && lhs.subtitle == rhs.subtitle
        && lhs.summary == rhs.summary
        && lhs.enclosure == rhs.enclosure
        && lhs.duration == rhs.duration
}
