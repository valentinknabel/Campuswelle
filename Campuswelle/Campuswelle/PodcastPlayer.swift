//
//  PodcastPlayer.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import MediaPlayer

private class Queue<T> {
    let value: T
    var next: Queue<T>?
    private var previous: Queue<T>?
    
    init(value v: T) {
        value = v
    }
    
    func append(v: T) {
        if next == nil {
            next = Queue<T>(value: v)
            next?.previous = self
        }
        else {
            next!.append(v)
        }
    }
}

class PodcastPlayer: NSObject, AVAudioPlayerDelegate {
    
    private static var _sharedInstance: PodcastPlayer?
    static var sharedInstance: PodcastPlayer {
        return _sharedInstance ?? PodcastPlayer()
    }
    
    private let audioPlayer: AVAudioPlayer
    private var podcastQueue: Queue<Podcast>?
    
    var isPaused: Bool {
        return !audioPlayer.playing
    }
    
    private override init() {
        audioPlayer = AVAudioPlayer()
        
        super.init()
        PodcastPlayer._sharedInstance = self
        audioPlayer.delegate = self
    }
    
    func prepare() {
        // Set AudioSession
        var setCategoryError: NSError?
        if !AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback,
            withOptions: AVAudioSessionCategoryOptions.MixWithOthers,
            error: &setCategoryError) {
                // handle error
                println(setCategoryError)
        }
    }
    
    func togglePlayback(sender: UIResponder) {
        (!audioPlayer.playing ? play : pause)(sender)
    }
    
    private func play(sender: UIResponder) {
        self.audioPlayer.play()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender.becomeFirstResponder()
    }
    
    private func pause(sender: UIResponder) {
        self.audioPlayer.play()
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    func next() {
        let old = podcastQueue
        podcastQueue = old?.next
        
        refreshInfoCenter()
    }
    
    private func refreshInfoCenter() {
        if let next = podcastQueue?.value {
            let currentlyPlayingTrackInfo = [MPMediaItemPropertyArtist: "Campuswelle",
                MPMediaItemPropertyTitle: next.article.title]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
        }
    }
    
    func append(podcast: Podcast) {
        if podcastQueue == nil {
            podcastQueue = Queue(value: podcast)
        }
        else {
            podcastQueue!.append(podcast)
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag {
            next()
        }
    }
    
}
