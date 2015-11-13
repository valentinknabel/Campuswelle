//
//  WebViewWrapperDelegate.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class WebViewWrapperDelegate: NSObject, UIWebViewDelegate {
    
    private var newsLink: NSURL?
    
    @IBOutlet var webView: UIWebView! {
        willSet {
            newValue.delegate = self
        }
    }
    var webViewActivityIndicator: UIActivityIndicatorView!
    
    override init() {
        super.init()
    }
    
    func setContent(news news: News) {
        newsLink = news.article.link
        let content = prepareHTML(news)
        webView.loadHTMLString(content, baseURL: news.article.link)
    }
    
    private func embedHTML(news: News) -> String {
        print(news.article.content)
        let htmlWrapperPath = NSBundle.mainBundle().pathForResource("wrapper", ofType: "html")
        // the file is inside the bundle => implicit unwrap is okay
        let htmlWrapper = try! NSString(contentsOfFile: htmlWrapperPath!, encoding: NSUTF8StringEncoding)
        let htmlContent = NSString(format: htmlWrapper, news.article.title, news.article.title, news.article.content) as String
        return htmlContent
    }
    
    private func prepareHTML(news: News) -> String {
        return embedHTML(news)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        webViewActivityIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webViewActivityIndicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        /*let urlString = request.URL?.absoluteString
        let x = urlString?.rangeOfString("http://campuswelle.uni-ulm.de/") != nil
        print("WebViewWrapperDelegate.webView(_:,shouldStartLoadWithRequest:,navigationType:): \(x) \(urlString!)")
        return x*/
        
        switch navigationType {
        case .Reload:
            break
        case .Other:
            break
        case .LinkClicked:
            break
        default:
            break
        }
        
        guard navigationType == UIWebViewNavigationType.Other && newsLink == request.URL else {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
}
