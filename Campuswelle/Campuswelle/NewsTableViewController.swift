//
//  NewsTableViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 20.05.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, SegueHandlerType {

    var news: [News] = []
    var toolBarController: AnyObject?
    var selectedPodcast: Podcast?
    
    func tryReload() {
        tryReload(true)
    }
    
    func tryReload(long: Bool) {
        refreshControl?.beginRefreshing()
        if !long {
            refreshControl?.attributedTitle = NSAttributedString(string: "Lädt")
        }
            
        fetchNews(success: { (n) -> () in
            self.news = n
            self.tableView.reloadData()
            print("NewsTableViewController.tryReload: news reloaded")
            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Erneut laden")
            
            }) { (error) -> () in
                print("NewsTableViewController.tryReload: \(error)")
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Laden dauert lange")
                delay(1) {
                    self.tryReload(true)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        toolBarController = preparePlaybackBar(self)
        refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Erneut laden")
        self.refreshControl?.addTarget(self, action: "tryReload", forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let button = UIButton(type: UIButtonType.System)
        button.setImage(UIImage(assetIdentifier: .Play), forState: UIControlState.Normal)
        button.setTitle("Live-Stream", forState: .Normal)
        button.addTarget(self.navigationItem.rightBarButtonItem?.target, action: self.navigationItem.rightBarButtonItem!.action, forControlEvents: UIControlEvents.TouchUpInside)
        button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.titleLabel?.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.imageView?.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.tintColor = self.navigationItem.rightBarButtonItem?.tintColor
        button.sizeToFit()
        let it = UIBarButtonItem(customView: button)

        self.navigationItem.rightBarButtonItem? = it
        //title = "Live-Stream"
        
        self.tryReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return news.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        func height(string: NSString, fontSize: CGFloat) -> CGFloat {
            let bounds = CGSize(width: self.tableView.frame.width - 73 - 55, height: CGFloat.max)
            
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)]
            let size = string.boundingRectWithSize(bounds,
                options: NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.TruncatesLastVisibleLine),
                attributes: attributes,
                context: nil)
            return ceil(size.height)
        }
        
        let some = news[indexPath.row]
        let titleHeight = height(some.article.title, fontSize: 16.0 + 4.0)
        let descHeight = height(some.article.description, fontSize: 11.0 + 2.5)
        
        let result = 5 + min(ceil(titleHeight), 40) + 5 + min(ceil(descHeight), 28)
        return result
    }
    
    func playAccessoryButtonTapped(button: UIButton, withEvent event: UIEvent) {
        let indexPath = tableView.indexPathForRowAtPoint(event.touchesForView(button)!.first!.locationInView(tableView))!
        
        if let pod = news[indexPath.row] as? Podcast {
            selectedPodcast = pod
            performSegueWithIdentifier(SegueIdentifier.DirectPlayPodcastSegue.rawValue, sender: button)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = news[indexPath.row].article.title
        cell.detailTextLabel?.text = news[indexPath.row].article.desc
        
        if let pod = news[indexPath.row] as? Podcast {
            let button = UIButton(type: UIButtonType.System)
            button.setImage(UIImage(assetIdentifier: UIImage.AssetIdentifier.Play), forState: .Normal)
            cell.accessoryView = button
            button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            button.addTarget(self, action: "playAccessoryButtonTapped:withEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        else {
            cell.accessoryView = nil
        }
        
        func setCellImage(image: UIImage) {
            func CGSizeAspectFill(aspectRatio: CGSize, var minimumSize: CGSize) -> CGSize
            {
                let mW = minimumSize.width / aspectRatio.width
                let mH = minimumSize.height / aspectRatio.height
                if( mH > mW ) {
                    minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width
                }
                else if( mW > mH ) {
                    minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height
                }
                return minimumSize
            }
            
            main { () -> () in
                let imageSize = CGSizeMake(43, 43)
                UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
                let aspectSize = CGSizeAspectFill(image.size, minimumSize: imageSize)
                let imageRect = CGRect(origin: CGPoint(x: (imageSize.width - aspectSize.width)/2, y: (imageSize.height - aspectSize.height)/2), size: aspectSize)
                image.drawInRect(imageRect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.imageView?.frame.size = imageSize
                cell.setNeedsLayout()
            }
        }
        
        setCellImage(UIImage(assetIdentifier: .DefaultCover))
        news[indexPath.row].article.image(0) {
            guard let image = $0 else {
                return
            }
            setCellImage(image)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    enum SegueIdentifier: String {
        case PlayLiveSegue = "PlayLiveSegue"
        case ShowArticleSegue = "ShowArticleSegue"
        case ShowPlaybackSegue = "ShowPlaybackSegue"
        case DirectPlayPodcastSegue = "DirectPlayPodcastSegue"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        switch segueIdentifierForSegue(segue) {
        case .PlayLiveSegue:
            guard let playbackController = segue.destinationViewController as? PlaybackViewController
                else { fatalError("segue not possible") }
            guard case .LiveStreamItem = playbackController.currentItem else {
                playbackController.currentItem = .LiveStreamItem
                break
            }
        case .DirectPlayPodcastSegue:
            defer { selectedPodcast = nil }
            guard let playbackController = segue.destinationViewController as? PlaybackViewController,
                let pod = selectedPodcast
                else { fatalError("segue not possible") }
            playbackController.currentItem = .PodcastItem(pod)
            
        case .ShowPlaybackSegue:
            break
        case .ShowArticleSegue:
            guard let newsViewController = segue.destinationViewController as? NewsViewController
                else { fatalError("segue not possible") }
            newsViewController.news = news[tableView.indexPathForSelectedRow!.row]
        }
    }

}
