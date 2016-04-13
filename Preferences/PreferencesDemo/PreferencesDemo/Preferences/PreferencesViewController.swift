//
//  PreferencesViewController.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

/*!
 * In the storyboard, ensure
     the view controller's transition checkboxes are all off
     the NSTabView's delegate is set to this controller object
 */

class PreferencesViewController: NSTabViewController {
  
  lazy var originalSizes = [String : NSSize]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - NSTabViewDelegate
  
  override func tabView(tabView: NSTabView, willSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, willSelectTabViewItem: tabViewItem)
    
    _ = tabView.selectedTabViewItem
    let originalSize = self.originalSizes[tabViewItem!.label]
    if (originalSize == nil) {
      self.originalSizes[tabViewItem!.label] = (tabViewItem!.view?.frame.size)!
    }
  }
  
  override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, didSelectTabViewItem: tabViewItem)
    
    let window = self.view.window
    if (window != nil) {
      window?.title = tabViewItem!.label
      let size = (self.originalSizes[tabViewItem!.label])!
      let contentFrame = (window?.frameRectForContentRect(NSMakeRect(0.0, 0.0, size.width, size.height)))!
      var frame = (window?.frame)!
      frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
      frame.size.height = contentFrame.size.height;
      frame.size.width = contentFrame.size.width;
      window?.setFrame(frame, display: false, animate: true)
    }
  }
}
