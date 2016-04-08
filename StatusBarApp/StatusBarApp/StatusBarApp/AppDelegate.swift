//
//  AppDelegate.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var statusItem: NSStatusItem!
  var statusItemController: StatusItemController?
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let statusItemController = StatusItemController()
    
    self.statusItemController = statusItemController
    
//    statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
//    statusItem.title = "App"
//    statusItem.highlightMode = true
  }
}

