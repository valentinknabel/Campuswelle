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


private func toItem(podcast: Podcast) -> AVPlayerItem {
    return AVPlayerItem(URL: podcast.enclosure)
}

private let livestreamURL = NSURL(string: "http://campuswelle.uni-ulm.de:8000/listen.mp3")!

// TODO: Save [AVPlayerItem:Podcast] for displaying info, Set<Podcast> because we dont want to repeat one podcast

class PodcastPlayer {
    
    private static var _sharedInstance: PodcastPlayer?
    static var sharedInstance: PodcastPlayer {
        return _sharedInstance ?? PodcastPlayer()
    }
    
    private init() {
        PodcastPlayer._sharedInstance = self
        
        prepare()
    }
    
    enum PlayingItem {
        case PodcastItem(Podcast)
        case LiveStreamItem
        case EmptyItem
    }
    
    
    private var player: AVPlayer? {
        didSet {
            defer { updateInfoCenter() }
            guard let _ = self.player else { return }
            self.play()
        }
    }
    var currentItem: PlayingItem = .EmptyItem {
        didSet {
            switch currentItem {
            case .EmptyItem:
                player = nil
            case .LiveStreamItem:
                player = AVPlayer(URL: livestreamURL)
            case .PodcastItem(let pod):
                player = AVPlayer(playerItem: toItem(pod))
            }
        }
    }
    
    enum PlaybackStatus {
        case Playing
        case Paused
        case Empty
    }
    var status: PlaybackStatus {
        switch currentItem {
        case .EmptyItem:
            return .Empty
        default:
            guard let p = player else { fatalError("Playing empty track") }
            return p.rate == 0 ? .Paused : .Playing
        }
    }
    
    private func updateInfoCenter() {
        switch currentItem {
        case .EmptyItem:
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
        case .LiveStreamItem:
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
            //TODO: implement
        case .PodcastItem(let pod):
            let currentlyPlayingTrackInfo = [MPMediaItemPropertyArtist: "Campuswelle",
                MPMediaItemPropertyTitle: pod.article.title]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
        }
    }
    
    private func prepare() {
        // Set AudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
        }
        catch {
            print(error)
        }
    }
    
    func playPodcast(podcast: Podcast, sender: UIResponder) {
        currentItem = .PodcastItem(podcast)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender.becomeFirstResponder()
    }
    
    func play(sender: UIResponder? = nil) {
        player?.play()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender?.becomeFirstResponder()
    }
    
    func pause(sender: UIResponder? = nil) {
        player?.pause()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender?.becomeFirstResponder()
    }
    
}
