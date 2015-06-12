//
//  AssetIdentifier.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 12.06.15.
//  Copyright © 2015 Valentin Knabel. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum AssetIdentifier: String {
        case AppIcon = "AppIcon"
        case DefaultCover = "default-cover"
        case ArrowDown = "ios7-arrow-down"
        
        case FastForward = "ios7-fastforward"
        case Pause = "ios7-pause"
        case Play = "ios7-play"
        case Rewind = "ios7-rewind"
        
        case VolumeMax = "ios7-volume-high"
        case VolumeMin = "ios7-volume-low"
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
    
}
