//
//  PodcastViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-18.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit
import MediaPlayer

private func timeString(time: Double) -> String {
    return String(format: "%02d:%02d", arguments: [Int(time)/60, Int(time)%60])
}

class PlaybackViewController: UIViewController {

    var currentItem: PodcastPlayer.PlayingItem {
        get {
            return PodcastPlayer.sharedInstance.currentItem
        }
        set {
            PodcastPlayer.sharedInstance.currentItem = newValue
        }
    }
    var podcast: Podcast? {
        didSet {
            guard let p = podcast else { return }
            PodcastPlayer.sharedInstance.currentItem = PodcastPlayer.PlayingItem.PodcastItem(p)
        }
    }
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var rewindButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var audioSlider: MPVolumeView!
    @IBOutlet weak var podcastProgress: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var autoplayButton: UIButton!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    
    
    @IBAction func rewind() {
    }
    @IBAction func play() {
        PodcastPlayer.sharedInstance.play()
        refreshButtons()
    }
    @IBAction func pause() {
        PodcastPlayer.sharedInstance.pause()
        refreshButtons()
    }
    @IBAction func fastForward() {
    }
    
    @IBAction func toggleAutoplay(sender: UIButton) {
        
    }
    
    @IBAction func unwindSegue(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshButtons() {
        func setEnabled(flag: Bool) {
            playButton.enabled = flag
            pauseButton.enabled = flag
            rewindButton.enabled = flag
            forwardButton.enabled = flag
        }
        
        switch PodcastPlayer.sharedInstance.status {
        case .Playing:
            playButton.hidden = true
            pauseButton.hidden = false
            setEnabled(true)
        case .Paused:
            playButton.hidden = false
            pauseButton.hidden = true
            setEnabled(true)
        case .Empty:
            playButton.hidden = false
            pauseButton.hidden = true
            setEnabled(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //audioSlider.setMinimumVolumeSliderImage(UIImage(assetIdentifier: .VolumeMin), forState: .Normal)
        //audioSlider.setMaximumVolumeSliderImage(UIImage(assetIdentifier: .VolumeMax), forState: .Normal)
        
        secondsObserver(nil)
        PodcastPlayer.sharedInstance.secondsObserver = secondsObserver
        
        PodcastPlayer.sharedInstance.titleObserver = titleObserver
        
        for sub in self.audioSlider.subviews {
            guard let button = sub as? UIButton
                else { continue }
            let airplayImage = button.imageForState(UIControlState.Normal)
            let blackImage = airplayImage?.imageWithColor(UIColor.blackColor())
            button.setImage(blackImage, forState: .Normal)
            let tintImage = airplayImage?.imageWithColor(button.tintColor)
            button.setImage(tintImage, forState: .Highlighted)
            button.setImage(tintImage, forState: .Selected)
        }
        self.refreshButtons()

    }

    private func secondsObserver(pair: (Double, Double)?) {
        // set time
        if let (current, limit) = pair {
            self.podcastProgress.progress = Float(current/limit)
            self.currentLabel.text = timeString(current)
            self.limitLabel.text = timeString(limit)
        }
        else {
            self.podcastProgress.progress = 0.0
            self.currentLabel.text = ""
            self.limitLabel.text = ""
        }
        
        // update title
        switch self.currentItem {
        case .EmptyItem:
            self.titleLabel.text = ""
            self.subLabel.text = ""
        case .LiveStreamItem:
            break
        case let .PodcastItem(p):
            self.titleLabel.text = p.article.title
            self.subLabel.text = "Campuswelle"
        }
    }
    
    private func titleObserver(title: String?) {
        self.titleLabel.text = title
        self.subLabel.text = "Campuswelle Live"
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
