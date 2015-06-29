//
//  AppDelegate.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-16.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        PodcastPlayer.sharedInstance
        
        UITabBar.appearance().tintColor = UIColor(red: 204/255.0, green: 51/255.0, blue: 0.0, alpha: 1.0)
        
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        switch event!.subtype {
        case .MotionShake:
            PodcastPlayer.sharedInstance.juneEgg()
        default:
            break
        }
    }
    
    override func remoteControlReceivedWithEvent(optEvent: UIEvent?) {
        guard let event = optEvent else { return }
        switch event.type {
        case .RemoteControl:
            switch event.subtype {
            case .RemoteControlPause:
                PodcastPlayer.sharedInstance.pause()
            case .RemoteControlPlay:
                PodcastPlayer.sharedInstance.play()
            default:
                break
            }
        case .Motion:
            switch event.subtype {
            case .MotionShake:
                PodcastPlayer.sharedInstance.juneEgg()
            default:
                break
            }
        default:
            break
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

