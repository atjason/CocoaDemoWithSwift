//
//  StatusItemController.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class StatusItemController {

  var statusItem: NSStatusItem!
  
  init() {
    // -1 means dynamic length
    statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    statusItem.title = "App"
    statusItem.highlightMode = true
  }
}
