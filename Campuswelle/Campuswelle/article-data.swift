//
//  article-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

private struct __persistentParser {
    static var parsers: Set<BNRSSFeedParser> = Set()
}

let ArticleRSSFeedUrl = NSURL(string: "http://campuswelle.uni-ulm.de/feed/")!

func loadRSSFeed(#success: (BNRSSFeed) -> Void, #failure: (NSError) -> Void) {
    var parser: BNRSSFeedParser?
    parser = BNRSSFeedParser(feedURL: ArticleRSSFeedUrl, withETag: nil, untilPubDate: nil,
        success: { _, f in
            __persistentParser.parsers.remove(parser!)
            success(f)
        },
        failure: { _, f in
            __persistentParser.parsers.remove(parser!)
            failure(f)
    })
    __persistentParser.parsers.insert(parser!)
}

