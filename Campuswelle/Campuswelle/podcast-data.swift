//
//  podcast-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

func podcastFilter(news: News) -> Bool {
    if let _ = news as? Podcast {
        return true
    }
    return false
}

func fetchPodcast(#success: ([Podcast]) -> (), #failure: (NSError) -> ()) {
    fetchNews(success: { (news: [News]) -> () in
        success(filter(news, podcastFilter) as! [Podcast])
    }, failure: failure)
}
