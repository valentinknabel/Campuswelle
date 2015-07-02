//
//  PlaybackBarViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 02.07.15.
//  Copyright © 2015 Valentin Knabel. All rights reserved.
//

import UIKit


func preparePlaybackBar(viewController: UIViewController) -> PlaybackBarViewController {
    let vc = PlaybackBarViewController(nibName: "PlaybackBarViewController", bundle: nil)
    viewController.toolbarItems = [UIBarButtonItem(customView: vc.view)]
    vc.parent = viewController
    return vc
}


class PlaybackBarViewController: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var parent: UIViewController?
    private var pollingTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillLayoutSubviews() {
        if pollingTimer == nil {
            self.pollingTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("refresh"), userInfo: nil, repeats: true)
        }

        if let bar = view.superview where view.frame != bar.bounds {
            view.frame = bar.bounds
            print(view.frame)
        }
        
        if case .Empty = PodcastPlayer.sharedInstance.status {
            parent?.navigationController?.setToolbarHidden(true, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        
        let p = PodcastPlayer.sharedInstance
        if p.titleObserver == nil {
            p.titleObserver = {_ in}
        }
        
        self.progressView.progress = Float(p.progress)
        
        switch p.currentItem {
        case .EmptyItem:
            previewImage.image = UIImage(assetIdentifier: .DefaultCover)
            titleLabel.text = p.leastRecentTitle ?? ""
            
        case .LiveStreamItem:
            previewImage.image = UIImage(assetIdentifier: .DefaultCover)
            titleLabel.text = p.leastRecentTitle ?? "Campuswelle Live"
            
        case .PodcastItem(let pod):
            titleLabel.text = pod.article.title
            pod.article.image(0) {
                guard let i = $0 else {
                    self.previewImage.image = UIImage(assetIdentifier: .DefaultCover)
                    return
                }
                self.previewImage.image = i
            }
        }
        
        switch p.status {
        case .Empty:
            //view.superview?.hidden = true
            parent?.navigationController?.setToolbarHidden(true, animated: true)
            
        case .Paused:
            //view.superview?.hidden = false
            parent?.navigationController?.setToolbarHidden(false, animated: true)
            playButton.hidden = false
            pauseButton.hidden = true
            
        case .Playing:
            //view.superview?.hidden = false
            parent?.navigationController?.setToolbarHidden(false, animated: true)
            playButton.hidden = true
            pauseButton.hidden = false
        }
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
