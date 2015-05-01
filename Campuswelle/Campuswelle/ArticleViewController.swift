//
//  ArticleViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-18.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIWebViewDelegate {
    
    var article: Article!
    @IBOutlet var webView: UIWebView!
    var contentWrapper = WebViewWrapperDelegate()
    
    func shareAction() {
        let controller = UIActivityViewController(activityItems: [article.link],
            applicationActivities: nil)
        self.presentViewController(controller,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationItem.title = article.title
        
        contentWrapper.webView = webView
        contentWrapper.setContent(article: article)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action,
            target: self,
            action: Selector("shareAction"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
