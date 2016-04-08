//
//  StatusItemController.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

enum StatusItemDisplay {
  case Icon, Title, IconAndTitle, Percent
}

class StatusItemController: NSObject {

  var statusItem: NSStatusItem!
  @IBOutlet weak var menuController: StatusMenuController!
  
  static let defaultStatusTitle = "App"
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
    statusItem = NSStatusBar.systemStatusBar()
      .statusItemWithLength(NSVariableStatusItemLength)
    statusItem.title = StatusItemController.defaultStatusTitle
    statusItem.highlightMode = true
    statusItem.menu = menuController.menu
    
    menuController.statusItem = statusItem
  }
}
