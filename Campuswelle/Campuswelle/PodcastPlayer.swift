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

@objc class PodcastPlayer: NSObject, AVAudioPlayerDelegate {
    
    private static var _sharedInstance: PodcastPlayer?
    static var sharedInstance: PodcastPlayer {
        return _sharedInstance ?? PodcastPlayer()
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var podcastQueue: Queue<Podcast>?
    
    enum Status {
        case Paused
        case Playing
        case Empty
    }
    var status: Status = .Empty {
        willSet {
            switch newValue {
            case .Empty:
                audioPlayer = nil
            default:
                break
            }
        }
    }
    
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
        self.audioPlayer?.play()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender.becomeFirstResponder()
    }
    
    private func pause(sender: UIResponder) {
        self.audioPlayer?.play()
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    func next() {
        let old = podcastQueue
        podcastQueue = old?.next
        
        if podcastQueue == nil {
            status = .Empty
        }
        refreshInfoCenter()
    }
    
    private func refreshInfoCenter() {
        switch (podcastQueue, status) {
        case (_, .Empty):
            break
        case let (.Some(next), _):
            let currentlyPlayingTrackInfo = [MPMediaItemPropertyArtist: "Campuswelle",
                MPMediaItemPropertyTitle: next.value.article.title]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
        default:
            println("PodcastPlayer inconsistent")
        }
    }
    
    func append(podcast: Podcast) {
        switch (podcastQueue, status) {
        case (_, .Empty):
            podcastQueue = Queue(value: podcast)
        case let (.Some(queue), _):
            queue.append(podcast)
        default:
            println("PodcastPlayer inconsistent")
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag {
            next()
        }
    }
    
}
