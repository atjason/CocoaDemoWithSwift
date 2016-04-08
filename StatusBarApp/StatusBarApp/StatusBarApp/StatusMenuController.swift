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
  
  @IBOutlet weak var insertMenuItem: NSMenuItem!
  @IBOutlet weak var removeMenuItem: NSMenuItem!
  
  @IBOutlet weak var mouseOverMenuItem: NSMenuItem!
  @IBOutlet weak var quitMenuItem: NSMenuItem!
  
  weak var statusItem: NSStatusItem!
  
  // MRAK: - Lifecycle
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
  }
  
  // MRAK: - Helper
  func initMenuStatus() {
    updateStatusItemDisplay(.IconAndTitle)
    
    removeMenuItem.enabled = false
    
    quitMenuItem.keyEquivalent = "q"
    quitMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.CommandKeyMask.rawValue)
  }
  
  func updateStatusItemDisplay(display: StatusItemDisplay) {
    showIconMenuItem.state = NSOffState
    showTitleMenuItem.state = NSOffState
    showIconAndTitleMenuItem.state = NSOffState
    showPercentMenuItem.state = NSOffState
    
    statusItem.image = nil
    statusItem.title = ""
    
    if let button = statusItem.button {
      // FIXME: it works, but obviously not good.
      button.subviews.removeAll()
    }
    
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
      statusItem.image = NSImage(imageLiteral: "NSActionTemplate")
      statusItem.title = StatusItemController.defaultStatusTitle
      showIconAndTitleMenuItem.state = NSOnState
      
    case .Percent:
      showPercentMenuItem.state = NSOnState
      
      if let button = statusItem.button {
        // FIXME: it works, but obviously not good.
        let frame = NSRect(x: 6, y: 2, width: 18, height: 18)
        let progressIndicator = NSProgressIndicator(frame: frame)
        progressIndicator.style = .SpinningStyle
        progressIndicator.indeterminate = false
        progressIndicator.doubleValue = 30
        
        // Use empty image to extand the status item's size
        statusItem.image = NSImage(named: "EmptyIconImage")
        button.addSubview(progressIndicator)
      }
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
  
  @IBAction func showPercent(sender: NSMenuItem) {
    updateStatusItemDisplay(.Percent)
  }
  
  @IBAction func insertMenuItem(sender: NSMenuItem) {
    let menuItem = NSMenuItem.init(title: "New Item",
                                   action: Selector(), keyEquivalent: "")
    
    let index = menu.indexOfItem(sender) + 1
    menu.insertItem(menuItem, atIndex: index)
    
    removeMenuItem.enabled = true
  }
  
  @IBAction func removeMenuItem(sender: NSMenuItem) {
    let indexToRemove = menu.indexOfItem(sender) - 1
    let indexOfInsert = menu.indexOfItem(insertMenuItem)
    
    if indexToRemove != indexOfInsert {
      menu.removeItemAtIndex(indexToRemove)
    }
    
    if (indexOfInsert + 1) == indexToRemove {
      removeMenuItem.enabled = false
    }
  }
  
  @IBAction func quit(sender: NSMenuItem) {
    NSApplication.sharedApplication().terminate(self)
  }
  
  // MRAK: - NSMenuDelegate
  
  func menuWillOpen(menu: NSMenu) {
    
  }
  
  func menuDidClose(menu: NSMenu) {
    
  }
}
