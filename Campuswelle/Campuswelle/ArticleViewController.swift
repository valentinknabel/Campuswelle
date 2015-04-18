//
//  ArticleViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-18.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var article: Article!
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = article.title
        webView.loadHTMLString(article.content, baseURL: article.link)
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
