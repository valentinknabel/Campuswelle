//
//  NewsViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 20.05.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, SegueHandlerType {

    var toolBarController: AnyObject?
    var news: News!
    @IBOutlet var webView: UIWebView!
    var contentWrapper = WebViewWrapperDelegate()
    
    func shareAction() {
        let controller = UIActivityViewController(activityItems: [news.article.link],
            applicationActivities: nil)
        self.presentViewController(controller,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBarController = preparePlaybackBar(self)
        
        // Do any additional setup after loading the view.
        //self.navigationItem.title = article.title
        
        contentWrapper.webView = webView
        contentWrapper.setContent(news: news)
        
        var items: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action,
                target: self,
                action: Selector("shareAction"))
        ]
        if let _ = news as? Podcast {
            items.append(
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play,
                    target: self,
                    action: Selector("performPlayPodcastSegue"))
            )
        }
        
        self.navigationItem.setRightBarButtonItems(items, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    func performPlayPodcastSegue() {
        self.performSegueWithIdentifier(SegueIdentifier.PlayPodcastSegue.rawValue, sender: self)
    }
    
    enum SegueIdentifier: String {
        case PlayPodcastSegue = "PlayPodcastSegue"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segueIdentifierForSegue(segue) {
        case .PlayPodcastSegue:
            guard let playbackController = segue.destinationViewController as? PlaybackViewController,
                podcast = news as? Podcast
                else { fatalError("segue not possible") }
            playbackController.podcast = podcast
        }
    }

}
