//
//  PodcastViewController.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-18.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {

    var podcast: Podcast!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func togglePodcast() {
        PodcastPlayer.sharedInstance.togglePlayback(self)
        self.refreshButtons()
    }
    
    func refreshButtons() {
        if PodcastPlayer.sharedInstance.isPaused {
            playButton.hidden = false
            pauseButton.hidden = true
        }
        else {
            playButton.hidden = true
            pauseButton.hidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.refreshButtons()
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
