//
//  concurrency.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 2015-04-18.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import Foundation

/// Performs a given closure after a given time has passed.
/// :param: delay Duration the execution is delayed in seconds.
/// :param: closure The action to be performed delayed.
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

/// Performs a given closure in a background queue.
func async(closure:()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}

/// Performs a given closure in main queue.
/// This function should be used when manipulating interface.
func main(closure:()->()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}
