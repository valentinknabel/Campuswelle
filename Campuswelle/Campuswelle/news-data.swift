//
//  news-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

private struct __persistentParser {
    static var parsers: Set<BNRSSFeedParser> = Set()
}

let NewsFeed = NSURL(string: "http://campuswelle.uni-ulm.de/feed/")!

private func loadNewsFeed(success success: (BNPodcastFeed) -> Void, failure: (NSError) -> Void) {
    var parser: BNPodcastFeedParser?
    parser = BNPodcastFeedParser(feedURL: NewsFeed, withETag: nil, untilPubDate: nil,
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

func toNews(feed: BNPodcastFeed) -> [News] {
    guard let items = feed.items as? [BNPodcastFeedItem]
        else { fatalError("items of BNRSSFeed must be of type BNRSSFeedItem") }
    return items.map { i in
        let article = toArticle(i)
        if let enc = i.enclosure?["url"] as? String {
            return Podcast(article: article,
                subtitle: i["itunes:subtitle"] as? String ?? "",
                summary: i["itunes:summary"] as? String ?? "",
                enclosure: NSURL(string: enc)!,
                duration: i.duration
            )
        }
        return article
    }
    .filter { (n: News?) in
        n != nil
    }
    .map { (n: News?) in
        return n!
    }
}

func fetchNews(success success: ([News]) -> (), failure: (NSError) -> ()) {
    loadNewsFeed(success: { (feed) -> Void in
        success(toNews(feed))
    }, failure: failure)
}
