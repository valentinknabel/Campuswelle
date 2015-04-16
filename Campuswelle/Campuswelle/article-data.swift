//
//  article-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

func toArticles(feed: BNRSSFeed) -> [Article] {
    return map(feed.items as! [BNRSSFeedItem], toArticle)
}

func toArticle(item: BNRSSFeedItem) -> Article {
    return Article(title: item.title,
        link: item.link,
        desc: item.description,
        categories: item.categories as! [String],
        content: item["content:encoded"] as? String ?? ""
    )
}

func articleFilter(news: News) -> Bool {
    if let _ = news as? Podcast {
        return false
    }
    return true
}
