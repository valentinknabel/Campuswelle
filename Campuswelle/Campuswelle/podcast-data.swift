//
//  podcast-data.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

func podcastFilter(news: News) -> Bool {
    if let n = news as? Podcast {
        return true
    }
    return false
}

func fetchPodcasts(#success: ([Podcast]) -> (), #failure: (NSError) -> ()) {
    fetchNews(success: { (news: [News]) -> () in
        let filtered = filter(news, podcastFilter)
        let converted = filtered.map {
            return $0 as! Podcast
        }
        success(converted)
    }, failure: failure)
}
