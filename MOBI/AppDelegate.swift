//
//  AppDelegate.swift
//  MOBI
//
//  Created by Michele Bigi on 20/09/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var mobiData :MobiData = MobiData()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //AppDelegate.mobiData.ReadInfrastruttura()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


