//
//  article-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

func toArticles(feed: BNRSSFeed) -> [Article] {
    guard let items = feed.items as? [BNRSSFeedItem]
        else { fatalError("items of BNRSSFeed must be of type BNRSSFeedItem") }
    return items.map(toArticle)
}

func toArticle(item: BNRSSFeedItem) -> Article {
    let content = item["content:encoded"] as? String ?? ""
    let doc = contentHtmlMapper(content)
    let images = htmlImageMapper(doc)
    let videos = htmlVideoMapper(doc)
    
    removeImages(doc)
    removeVideos(doc)
    let data = doc.data
    let fixedContent = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    
    return Article(title: item.title,
        link: item.link,
        desc: htmlInnerStringMapper(contentHtmlMapper("<html><head/><body>\(item.description)</body></html>")),
        categories: item.categories as! [String],
        content: fixedContent,
        imageUrls: images,
        videoUrls: videos
    )
}

func articleFilter(news: News) -> Bool {
    if let _ = news as? Podcast {
        return false
    }
    return true
}
