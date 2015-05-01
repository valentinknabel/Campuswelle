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
    
    func setContent(#article: Article) {
        webView.loadHTMLString(prepareHTML(article), baseURL: article.link)
    }
    
    private func embedHTML(article: Article) -> String {
        let htmlWrapperPath = NSBundle.mainBundle().pathForResource("wrapper", ofType: "html")
        let htmlWrapper = NSString(contentsOfFile: htmlWrapperPath!, encoding: NSUTF8StringEncoding, error: nil)
        let htmlContent = NSString(format: htmlWrapper!, article.title, article.title, article.content) as String
        return htmlContent
    }
    
    private func prepareHTML(article: Article) -> String {
        return embedHTML(article)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        let x = urlString?.rangeOfString("http://campuswelle.uni-ulm.de/") != nil
        println("LOADS?: \(x) \(urlString!)")
        return x
    }
    
}
