//
//  PodcastViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {

    var podcast: Podcast!
    @IBOutlet var webView: UIWebView!
    var contentWrapper = WebViewWrapperDelegate()
    
    func addPodcast() {
        PodcastPlayer.sharedInstance.append(podcast, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contentWrapper.webView = webView
        contentWrapper.setContent(news: podcast.article)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: Selector("addPodcast"))
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
