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
  
  var hiddenWindowController: NSWindowController?
  
  var popover: NSPopover?
  
  // MRAK: - Lifecycle
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
  }
  
  // MRAK: - Helper
  func initMenuStatus() {
    updateStatusItemDisplay(.IconAndTitle)
    
    quitMenuItem.keyEquivalent = "q"
    quitMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.CommandKeyMask.rawValue)
    
    // Please read the comments for this property:
    /* Set and get whether the menu autoenables items.  If a menu autoenables items, then calls to -[NSMenuItem setEnabled:] are ignored, and the enabled state is computed via the NSMenuValidation informal protocol below.  Autoenabling is on by default. */
    menu.autoenablesItems = false
    
    removeMenuItem.enabled = false
    
    // Set menu item's image
    mouseOverMenuItem.image = NSImage(imageLiteral: "NSIconViewTemplate")
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
      statusItem.image?.template = true
      showIconMenuItem.state = NSOnState
      
    case .Title:
      statusItem.title = StatusItemController.defaultStatusTitle
      showTitleMenuItem.state = NSOnState
      
    case .IconAndTitle:
      // FIXME: now need to set title twice,
      //        otherwise the title can't be fully displayed.
      statusItem.title = StatusItemController.defaultStatusTitle
      statusItem.image = NSImage(imageLiteral: "NSActionTemplate")
      statusItem.image?.template = true
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
        statusItem.image?.template = true
        button.addSubview(progressIndicator)
      }
    }
  }
  
  func initHiddenWindowController() {
    let hiddenWindow = NSWindow()
    
    let size = 30 // A small size to let the window be covered by status menu.
    hiddenWindow.styleMask = NSBorderlessWindowMask
    hiddenWindow.setFrame(NSRect(x: size, y: size, width: size, height: size), display: true)
    hiddenWindow.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
    
    hiddenWindowController = NSWindowController()
    hiddenWindowController?.window = hiddenWindow
  }
  
  func showPopover(sender: AnyObject?) {
    if popover?.contentViewController == nil {
      popover = NSPopover()
      popover?.contentViewController = NSViewController(nibName: "PopoverViewController", bundle: nil)
    }
    
//    if let button = statusItem.button {
//      popover?.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinX)
//    }

    if hiddenWindowController == nil {
      initHiddenWindowController()
    }
    
    if let window = hiddenWindowController?.window {
      
      if let view = window.contentView {
        
        if let statusItemWindow = statusItem.button?.window {
          
          var point = NSPoint()
          point.x = statusItemWindow.frame.origin.x
          point.y = NSEvent.mouseLocation().y + window.frame.size.height / 2.0
          window.setFrameTopLeftPoint(point)
          
          hiddenWindowController?.showWindow(self)
          
          popover?.showRelativeToRect(view.bounds, ofView: view, preferredEdge: .MinX)
        }
      }
    }
  }
  
  func closePopover(sender: AnyObject?) {
    popover?.performClose(sender)
    hiddenWindowController?.window?.close()
  }
  
  func togglePopover(sender: AnyObject?) {
    if let popover = popover {
      if popover.shown {
        closePopover(sender)
      } else {
        showPopover(sender)
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
  
  @IBAction func mouseOverMenuItem(sender: NSMenuItem) {
    togglePopover(sender)
  }
  
  @IBAction func insertMenuItem(sender: NSMenuItem) {
    let menuItem = NSMenuItem.init(title: "New Item",
                                   action: Selector(), keyEquivalent: "")
    menuItem.enabled = false
    menuItem.indentationLevel = sender.indentationLevel + 1
    
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
  
  func menu(menu: NSMenu, willHighlightItem item: NSMenuItem?) {
    if item === mouseOverMenuItem {
      showPopover(item)
      //item?.toolTip = ""
    } else {
      closePopover(menu)
    }
  }
}
