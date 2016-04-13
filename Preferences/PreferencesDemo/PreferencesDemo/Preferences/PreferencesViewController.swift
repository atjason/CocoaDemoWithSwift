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
  
  lazy var tabViewSizes = [String : NSSize]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for tabViewItem in tabViewItems {
      tabViewSizes[tabViewItem.label] = tabViewItem.view?.frame.size
    }
  }
  
  // MARK: - NSTabViewDelegate
  
  override func tabView(tabView: NSTabView, willSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, willSelectTabViewItem: tabViewItem)
    
    if let selectedTabView = tabView.selectedTabViewItem {
      tabViewSizes[selectedTabView.label] = selectedTabView.view?.frame.size
    }
  }
  
  override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, didSelectTabViewItem: tabViewItem)
    
    if let window = view.window  {
      window.title = tabViewItem!.label
      
      if let size = tabViewSizes[tabViewItem!.label] {
        let contentFrame = window.frameRectForContentRect(NSMakeRect(0.0, 0.0, size.width, size.height))
        
        var frame = window.frame
        frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
        frame.size.height = contentFrame.size.height;
        frame.size.width = contentFrame.size.width;
        window.setFrame(frame, display: false, animate: true)
      }
    }
  }
}
