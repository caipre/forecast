//
//  AppDelegate.swift
//  forecast
//
//  Created by Nicholas Platt on 8/27/16.
//  Copyright © 2016 Recurse. All rights reserved.
//

import Cocoa
import Log

let log = Logger.init(minLevel: .debug)
let weather = Weather()
let location = Location()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        location.startUpdating()
    }

}
