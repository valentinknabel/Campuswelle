//
//  PodcastPlayer.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer


// TODO: Save [AVPlayerItem:Podcast] for displaying info, Set<Podcast> because we dont want to repeat one podcast

@objc class PodcastPlayer: NSObject {
    
    private static var _sharedInstance: PodcastPlayer?
    static var sharedInstance: PodcastPlayer {
        return _sharedInstance ?? PodcastPlayer()
    }
    
    private let player: AVQueuePlayer = AVQueuePlayer.queuePlayerWithItems([]) as! AVQueuePlayer
    
    enum Status {
        case Paused
        case Playing
        case Empty
    }
    var status: Status = .Empty
    
    private override init() {
        
        super.init()
        PodcastPlayer._sharedInstance = self
        
        prepare()
    }
    
    private func prepare() {
        // Set AudioSession
        var setCategoryError: NSError?
        if !AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback,
            withOptions: AVAudioSessionCategoryOptions.MixWithOthers,
            error: &setCategoryError) {
                // handle error
                println(setCategoryError)
        }
    }
    
    // TODO: Reimplement
    func togglePlayback(sender: UIResponder) {
        switch self.status {
        case .Paused:
            play(sender)
        case .Playing:
            pause(sender)
        case .Empty:
            break
        }
    }
    
    private func play(sender: UIResponder) {
        self.player.play()
        status = .Playing
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender.becomeFirstResponder()
    }
    
    private func pause(sender: UIResponder) {
        self.player.play()
        status = .Paused
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    func next() {
        
        refreshInfoCenter()
    }
    
    private func refreshInfoCenter() {
        // TODO: implement
        /*switch (podcastQueue, status) {
        case (_, .Empty):
            break
        case let (.Some(next), _):
            let currentlyPlayingTrackInfo = [MPMediaItemPropertyArtist: "Campuswelle",
                MPMediaItemPropertyTitle: next.value.article.title]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
        default:
            println("PodcastPlayer inconsistent")
        }*/
    }
    
    func append(podcast: Podcast, sender: UIResponder) {
        
    }
    
}
