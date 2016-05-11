//
//  PopoverViewController.swift
//  StatusBarApp
//
//  Created by Jason Zheng on 4/8/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
  
  @IBOutlet var textView: NSTextView!
  var text = ""
  
  private var popover: NSPopover?
  private var hiddenWindowController: NSWindowController?
  
  weak var statusItem: NSStatusItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Public Method
  
  func showPopover(sender: AnyObject?) {
    if popover == nil {
      popover = NSPopover()
      popover?.contentViewController = self
    
      initHiddenWindowController()
    }
    
    if let window = hiddenWindowController?.window {
      if let view = window.contentView {
        if let statusItemWindow = statusItem?.button?.window {
          var point = NSPoint()
          point.x = statusItemWindow.frame.origin.x
          point.y = NSEvent.mouseLocation().y + window.frame.size.height / 2.0
          window.setFrameTopLeftPoint(point)
          
          hiddenWindowController?.showWindow(self)
          
          popover?.showRelativeToRect(view.bounds, ofView: view, preferredEdge: .MinX)
          updateTextView()
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
  
  // MARK: - Helper
  
  private func updateTextView() {
    if let textStorage = textView.textStorage {
      textStorage.replaceCharactersInRange(NSRange(0..<textStorage.length), withString: text)
      
      let textSize = textStorage.size()
      let margin: CGFloat = 80
      let maxWidth: CGFloat = 400
      let maxHeight: CGFloat = 700
      let newWindowSize = NSSize(width: min(maxWidth, textSize.width + margin),
                                 height: min(maxHeight, textSize.height + margin))
      
      if let window = textView.window {
        let oldWindowFrame = window.frame
        var newWindowOrigin = oldWindowFrame.origin
        newWindowOrigin.x += oldWindowFrame.size.width - newWindowSize.width
        newWindowOrigin.y += (oldWindowFrame.size.height - newWindowSize.height) / 2
        
        if let screenSize = NSScreen.mainScreen()?.frame.size {
          let menuBarHeight: CGFloat = 22
          if (newWindowOrigin.y + newWindowSize.height) > (screenSize.height - menuBarHeight) {
            newWindowOrigin.y -= (newWindowOrigin.y + newWindowSize.height) - (screenSize.height - menuBarHeight)
            newWindowOrigin.y = max(0, newWindowOrigin.y)
          }
        }
        window.setFrame(NSRect.init(origin: newWindowOrigin, size: newWindowSize), display: true)
      }
    }
  }
  
  private func initHiddenWindowController() {
    let hiddenWindow = NSWindow()
    
    let size = 30 // A small size to let the window be covered by status menu.
    hiddenWindow.styleMask = NSBorderlessWindowMask
    hiddenWindow.setFrame(NSRect(x: size, y: size, width: size, height: size), display: true)
    hiddenWindow.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
    
    hiddenWindowController = NSWindowController()
    hiddenWindowController?.window = hiddenWindow
  }
}
