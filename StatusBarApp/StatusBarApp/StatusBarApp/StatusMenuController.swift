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
  
  weak var statusItem: NSStatusItem!
    
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
    
  }
  
  // MRAK: - Actions
  @IBAction func showIcon(sender: NSMenuItem) {
    statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
    statusItem.title = ""
  }
  
  @IBAction func showTitle(sender: NSMenuItem) {
    statusItem.image = nil
    statusItem.title = StatusItemController.defaultStatusTitle
  }
  
  @IBAction func showBoth(sender: NSMenuItem) {
    // Note: need to first set the image, and then the title,
    //       otherwise the length of status item will be incorrect.
    // FIXME: switch status between title/icon/both for many times,
    //        sometimes the title can't be fully displayed in both status.
    statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
    statusItem.title = StatusItemController.defaultStatusTitle
  }
  
  // MRAK: - NSMenuDelegate
  
  func menuWillOpen(menu: NSMenu) {
    
  }
  
  func menuDidClose(menu: NSMenu) {
    
  }
}
