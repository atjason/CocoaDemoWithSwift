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
  
  // MRAK: - Lifecycle
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
    
  }
  
  // MRAK: - Helper
  
  func updateStatusItemDisplay(display: StatusItemDisplay) {
    switch display {
    case .Icon:
      statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
      statusItem.title = ""
      
    case .Title:
      statusItem.image = nil
      statusItem.title = StatusItemController.defaultStatusTitle
      
    case .IconAndTitle:
      // Note: need to first set the image, and then the title,
      //       otherwise the length of status item will be incorrect.
      // FIXME: switch status between title/icon/both for many times,
      //        sometimes the title can't be fully displayed in both status.
      statusItem.image = NSImage.init(imageLiteral: "NSActionTemplate")
      statusItem.title = StatusItemController.defaultStatusTitle
      
    case .Percent:
      break
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
