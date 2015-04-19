//
//  common-vc.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-19.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import UIKit

//TODO: Need to update (hide/display) button
@objc private class ButtonHandler: NSObject {
    
    weak private var vc: UIViewController?
    var hasItem: Bool = false
    
    init(viewController: UIViewController) {
        self.vc = viewController
        super.init()
        
        updateButtonItem()
    }
    
    private func removeSelf() {
        listeningButtonHandlers.remove(self)
    }
    
    func triggerPodcastSegue(sender: AnyObject?) {
        if let vc = vc {
            vc.showViewController(vc, sender: sender)
        }
        else {
            removeSelf()
        }
    }
    
    func updateButtonItem() {
        if let vc = vc {
            switch (hasItem, PodcastPlayer.sharedInstance.status) {
            case (true, .Empty):
                vc.navigationItem.rightBarButtonItem = nil
            case (false, .Playing), (false, .Paused):
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Podcast",
                    style: UIBarButtonItemStyle.Plain,
                    target: self,
                    action: Selector("triggerPodcastSegue:"))
            default:
                break
            }
        }
        else {
            removeSelf()
        }
    }
    
}


private var listeningButtonHandlers = Set<ButtonHandler>()

func addListeningButton(vc: UIViewController) {
    listeningButtonHandlers.insert(ButtonHandler(viewController: vc))
}
