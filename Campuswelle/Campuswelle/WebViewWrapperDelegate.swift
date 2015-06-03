//
//  WebViewWrapperDelegate.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class WebViewWrapperDelegate: NSObject, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView! {
        willSet {
            newValue.delegate = self
        }
    }
    
    override init() {
        super.init()
    }
    
    func setContent(#news: News) {
        let content = prepareHTML(news)
        webView.loadHTMLString(content, baseURL: news.article.link)
        println(content)
    }
    
    private func embedHTML(news: News) -> String {
        let htmlWrapperPath = NSBundle.mainBundle().pathForResource("wrapper", ofType: "html")
        let htmlWrapper = NSString(contentsOfFile: htmlWrapperPath!, encoding: NSUTF8StringEncoding, error: nil)
        let htmlContent = NSString(format: htmlWrapper!, news.article.title, news.article.title, news.article.content) as String
        return htmlContent
    }
    
    private func prepareHTML(news: News) -> String {
        return embedHTML(news)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        let x = urlString?.rangeOfString("http://campuswelle.uni-ulm.de/") != nil
        println("LOADS?: \(x) \(urlString!)")
        return x
    }
    
}
