//
//  StatusMenuController.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, NSMenuDelegate {
  
  @IBOutlet weak var menu: NSMenu!
  
  @IBOutlet weak var showIconMenuItem: NSMenuItem!
  @IBOutlet weak var showTitleMenuItem: NSMenuItem!
  @IBOutlet weak var showIconAndTitleMenuItem: NSMenuItem!
  @IBOutlet weak var showPercentMenuItem: NSMenuItem!
  
  weak var statusItem: NSStatusItem!
  
  // MRAK: - Lifecycle
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
  }
  
  // MRAK: - Helper
  
  func updateStatusItemDisplay(display: StatusItemDisplay) {
    showIconMenuItem.state = NSOffState
    showTitleMenuItem.state = NSOffState
    showIconAndTitleMenuItem.state = NSOffState
    showPercentMenuItem.state = NSOffState
    
    statusItem.image = nil
    statusItem.title = ""
    
    switch display {
    case .Icon:
      statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
      showIconMenuItem.state = NSOnState
      
    case .Title:
      statusItem.title = StatusItemController.defaultStatusTitle
      showTitleMenuItem.state = NSOnState
      
    case .IconAndTitle:
      // FIXME: now need to set title twice,
      //        otherwise the title can't be fully displayed.
      statusItem.title = StatusItemController.defaultStatusTitle
      statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
      statusItem.title = StatusItemController.defaultStatusTitle
      showIconAndTitleMenuItem.state = NSOnState
      
    case .Percent:
      showPercentMenuItem.state = NSOnState
    }
  }
  
  // MRAK: - Actions
  @IBAction func showIcon(sender: NSMenuItem) {
    updateStatusItemDisplay(.Icon)
  }
  
  @IBAction func showTitle(sender: NSMenuItem) {
    updateStatusItemDisplay(.Title)
  }
  
  @IBAction func showIconAndTitle(sender: NSMenuItem) {
    updateStatusItemDisplay(.IconAndTitle)
  }
  
  // MRAK: - NSMenuDelegate
  
  func menuWillOpen(menu: NSMenu) {
    
  }
  
  func menuDidClose(menu: NSMenu) {
    
  }
}
