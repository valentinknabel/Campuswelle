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

/// Converts a podcast to an player item.
private func toItem(podcast: Podcast) -> AVPlayerItem {
    return AVPlayerItem(URL: podcast.enclosure)
}

private let livestreamURL = NSURL(string: "http://campuswelle.uni-ulm.de:8000/listen.mp3")!
private let metaDataURL = NSURL(string: "http://campuswelle.uni-ulm.de/wp-content/themes/campuswelle/stream-meta_api.php?amount=1")!

/// The podcast player can play a livestream and podcasts.
public class PodcastPlayer {
    
    /// Stores the singleton instance.
    private static var _sharedInstance: PodcastPlayer?
    /// Use this property instead of init().
    public static var sharedInstance: PodcastPlayer {
        return _sharedInstance ?? PodcastPlayer()
    }
    private let rcc = MPRemoteCommandCenter.sharedCommandCenter()
    
    
    /// Instances of this class shall only be instantiated from inside this class.
    private init() {
        PodcastPlayer._sharedInstance = self
        
        prepare()
    }
    
    /// Represents the currently playing items.
    public enum PlayingItem {
        /// Buffers a bit when paused.
        case PodcastItem(Podcast)
        /// Pausing and playing will take some time to prevent infinite buffering.
        /// Rewind and fast forward will be disabled.
        case LiveStreamItem
        /// All controls will be disabled.
        case EmptyItem
    }
    
    /// The currently played item. 
    /// For further details see PlaingItem's cases.
    public var currentItem: PlayingItem = .EmptyItem {
        didSet {
            switch currentItem {
            case .EmptyItem:
                player = nil
            case .LiveStreamItem:
                player = AVPlayer(URL: livestreamURL)
                self.refreshTitle()
            case .PodcastItem(let pod):
                player = AVPlayer(playerItem: toItem(pod))
            }
        }
    }
    
    /// This property stores the object returned for the seconds observer.
    private var observerObject: AnyObject? {
        willSet {
            guard let observerObject = observerObject else { return }
            self.player?.removeTimeObserver(observerObject)
        }
    }
    
    /// Set this property to receive time updates.
    public var secondsObserver: ((Double, Double)? -> Void)?  {
        didSet {
            guard let new = secondsObserver else { return }
            let time = CMTimeMake(1, 1)
            observerObject = self.player?.addPeriodicTimeObserverForInterval(time, queue: nil) { _ in
                guard let limit = self.player?.currentItem?.duration,
                    current = self.player?.currentTime()
                    where limit != kCMTimeIndefinite
                    else { new(nil);return }

                new((current.seconds, limit.seconds))
            }
        }
    }
    
    /// Stores the current player.
    private var player: AVPlayer? {
        willSet {
            defer { self.observerObject = nil }
            guard case .LiveStreamItem = self.currentItem else {
                self.secondsObserver = nil
                return
            }
        }
        didSet {
            defer { updateInfoCenter() }
            guard let _ = self.player else { return }
            
            self.play()
            
            // resetting the seconds observer will create a new periodic time observer
            let temp = self.secondsObserver
            self.secondsObserver = temp
        }
    }
    
    /// Stores the least recent title. May not be the current item's title.
    private var leastRecentTitle: String?
    
    /// Stores an observer for a given title.
    public var titleObserver: ((String?) -> Void)? {
        didSet {
            titleObserver?(leastRecentTitle)
        }
    }
    private var titleTimer: NSTimer?
    
}

/// PodcastPlayer additions for playback.
public extension PodcastPlayer {
    
    /// Represents the external status of the current playback.
    public enum PlaybackStatus {
        case Playing
        case Paused
        case Empty
    }
    
    /// The current playback status of the podcast player.
    public var status: PlaybackStatus {
        switch currentItem {
        case .EmptyItem:
            return .Empty
        case .LiveStreamItem:
            guard let _ = player else { return .Paused }
            fallthrough
        default:
            guard let p = player else { fatalError("PodcastPlayer.status: Playing empty track") }
            return p.rate == 0 ? .Paused : .Playing
        }
    }
    
    /// Initiates playback of a given podcast.
    public func playPodcast(podcast: Podcast, sender: UIResponder? = nil) {
        currentItem = .PodcastItem(podcast)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender?.becomeFirstResponder()
    }
    
    /// Re-plays currentItem, if not .EmptyItem. 
    /// May take some time to start for .LiveStreamItem.
    public func play(sender: UIResponder? = nil) {
        if case .LiveStreamItem = self.currentItem where player == nil {
            self.currentItem = .LiveStreamItem
        }
        
        player?.play()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
        delegate.becomeFirstResponder()
    }
    
    /// Pauses playback of currentItem.
    public func pause(sender: UIResponder? = nil) {
        player?.pause()
        if case .LiveStreamItem = self.currentItem {
            self.player = nil
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        sender?.becomeFirstResponder()
    }
    
    public func seekAbsolute(percent: Float) {
        guard let limit = self.player?.currentItem?.duration
            where limit != kCMTimeIndefinite && percent >= 0.0 && percent <= 1.0
            else { return }
        let seconds = Float(limit.seconds) * percent
        let targetTime = CMTimeMake(Int64(seconds), 1)
        player?.seekToTime(targetTime) { b in
            print("PodcastPlayer.seekAbsolute: \(b)")
        }
    }
    
    public static let DefaultSeekInterval: NSTimeInterval = 30
    
    /// Performs a step rewind.
    public func seekRelative(timeInterval: NSTimeInterval = DefaultSeekInterval) {
        let current = player?.currentTime() ?? CMTimeMake(0, 0)
        let targetTime = CMTimeMake(Int64(current.seconds + timeInterval), 1)
        player?.seekToTime(targetTime) { b in
            print("PodcastPlayer.seekRelative: \(b)")
        }
    }
    
}

/// PodcastPlayer additions for meta info of the current item.
public extension PodcastPlayer {
    
    /// Typically a new title
    private func refreshTitleAfter(timeInterval: NSTimeInterval) {
        titleTimer = NSTimer(timeInterval: timeInterval, target: self, selector: Selector("refreshTitle"), userInfo: nil, repeats: false)
    }
    
    private func refreshTitle() {
        enum LocalError: ErrorType {
            /// Repeat after some seconds
            case LoadingError
        }
        
        do {
            let fetchedMetaData = NSData(contentsOfURL: metaDataURL)
            guard let metaData = fetchedMetaData else { throw LocalError.LoadingError }
            let json = try NSJSONSerialization.JSONObjectWithData(metaData, options: NSJSONReadingOptions.AllowFragments)
            guard let songs = json as? [NSDictionary],
                title = songs[0]["title"] as? String
                else {
                    print("PodcastPlayer.refreshTitle: Invalid server data")
                    return
            }
            self.leastRecentTitle = title
            titleObserver?(title)
            
            /// succeeded
            updateInfoCenter()
            refreshTitleAfter(120)
        }
        catch {
            refreshTitleAfter(5)
        }
        
    }
    
}


/// Internal PodcastPlayer additions.
private extension PodcastPlayer {
    
    /// Prepares the audio session.
    private func prepare() {
        // Set AudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
        }
        catch {
            print("PodcastPlayer.prepare \(error)")
        }
        
        // init rcc
        //skip forward
        do {
            let skipForward = rcc.skipForwardCommand
            skipForward.enabled = false
            skipForward.preferredIntervals = [PodcastPlayer.DefaultSeekInterval]
            skipForward.addTargetWithHandler { (event) -> MPRemoteCommandHandlerStatus in
                guard let skipEvent = event as? MPSkipIntervalCommandEvent
                    else { return .CommandFailed }
                self.seekRelative(skipEvent.interval)
                return MPRemoteCommandHandlerStatus.Success
            }
        }
        
        // skip backward
        do {
            let skipBackward = rcc.skipBackwardCommand
            skipBackward.preferredIntervals = [PodcastPlayer.DefaultSeekInterval]
            skipBackward.enabled = false
            skipBackward.addTargetWithHandler { (event) -> MPRemoteCommandHandlerStatus in
                guard let skipEvent = event as? MPSkipIntervalCommandEvent
                    else { return .CommandFailed }
                self.seekRelative(-skipEvent.interval)
                return MPRemoteCommandHandlerStatus.Success
            }
        }
        
        // pause
        do {
            let pause = rcc.pauseCommand
            pause.enabled = false
            pause.addTargetWithHandler { (event) -> MPRemoteCommandHandlerStatus in
                self.pause()
                return MPRemoteCommandHandlerStatus.Success
            }
        }
        
        // play
        do {
            let play = rcc.pauseCommand
            play.enabled = false
            play.addTargetWithHandler { (event) -> MPRemoteCommandHandlerStatus in
                self.play()
                return MPRemoteCommandHandlerStatus.Success
            }
        }
        
    }
    
    /// Updates the info center.
    private func updateInfoCenter() {
        switch currentItem {
        case .EmptyItem:
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
            
            // remote controls
            rcc.skipBackwardCommand.enabled = false
            rcc.skipForwardCommand.enabled = false
            rcc.pauseCommand.enabled = false
            rcc.playCommand.enabled = false
            
        case .LiveStreamItem:
            let artwork = MPMediaItemArtwork(image: UIImage(assetIdentifier: UIImage.AssetIdentifier.DefaultCover))
            let currentlyPlayingTrackInfo = [
                MPMediaItemPropertyArtist: "Campuswelle Live",
                MPMediaItemPropertyTitle: leastRecentTitle ?? "",
                MPMediaItemPropertyArtwork: artwork,
                MPMediaItemPropertyMediaType: MPMediaType.AnyAudio.rawValue
            ]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
            
            // remote controls
            rcc.skipBackwardCommand.enabled = false
            rcc.skipForwardCommand.enabled = false
            rcc.pauseCommand.enabled = true
            rcc.playCommand.enabled = true
            
        case .PodcastItem(let pod):
            let artwork = MPMediaItemArtwork(image: UIImage(assetIdentifier: UIImage.AssetIdentifier.DefaultCover))
            let currentlyPlayingTrackInfo = [
                MPMediaItemPropertyArtist: "Campuswelle",
                MPMediaItemPropertyTitle: pod.article.title,
                MPMediaItemPropertyArtwork: artwork,
                MPMediaItemPropertyMediaType: MPMediaType.Podcast.rawValue
            ]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingTrackInfo
            
            // remote controls
            rcc.skipBackwardCommand.enabled = true
            rcc.skipForwardCommand.enabled = true
            rcc.pauseCommand.enabled = true
            rcc.playCommand.enabled = true
        }
    }
    
}

/// Eggs
internal extension PodcastPlayer {
    
    internal func juneEgg() {
        guard let p = player else { return }
        switch p.rate {
        case 1.0:
            p.rate = 0.5
        case 0.5:
            p.rate = 3.0
        default:
            p.rate = 1.0
        }
    }
    
}

