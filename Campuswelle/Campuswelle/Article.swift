//
//  Article.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

public protocol News {
    var article: Article { get }
}

public struct Article: News, CustomStringConvertible {
    
    private static let imageCache: NSCache = NSCache()
    
    public var article: Article {
        return self
    }
    
    public let title: String
    public let link: NSURL
    public let desc: String
    public let categories: [String]
    public let content: String
    
    public let imageUrls: [NSURL]
    public let videoUrls: [NSURL]
    
    public var description: String {
        return "A: \(title)"
    }
}

import UIKit

public extension Article {
    
    public func image(index: Int, callback: (UIImage?) -> Void) {
        guard self.imageUrls.count > 0 else {
            callback(nil)
            return
        }
        
        let url = self.imageUrls[index]
        let key = url.absoluteString
        if let img = Article.imageCache.objectForKey(key) as? UIImage {
            callback(img)
        }
        else {
            async {
                guard let data = NSData(contentsOfURL: url),
                    let img = UIImage(data: data)
                    else { callback(nil);return }
                Article.imageCache.setObject(img, forKey: key)
                callback(img)
            }
            
        }
    }
}
