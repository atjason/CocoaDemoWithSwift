//
//  StatusItemController.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {

  var statusItem: NSStatusItem!
  @IBOutlet weak var menuController: StatusMenuController!
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
    statusItem = NSStatusBar.systemStatusBar()
      .statusItemWithLength(NSVariableStatusItemLength)
    statusItem.title = "App"
    statusItem.highlightMode = true
    statusItem.menu = menuController.menu
  }
}
