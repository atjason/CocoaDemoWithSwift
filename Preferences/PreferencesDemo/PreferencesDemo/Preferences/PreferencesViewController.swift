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
  
  private let preferenceManager = PreferenceManager.sharedInstance
  
  var tabViewSizes = [String: SizeArchiver]()
  
  override func viewDidLoad() {
    readTabViewSizes()
    
    super.viewDidLoad()
  }
  
  override func viewWillDisappear() {
    saveTabViewSizes()
  }
  
  // MARK: - Helper
  
  func readTabViewSizes() {
    tabViewSizes = preferenceManager.tabViewSizes
    
    for tabViewItem in tabViewItems {
      let label = tabViewItem.label
      if tabViewSizes[label] == nil {
        if let size = tabViewItem.view?.frame.size {
          tabViewSizes[label] = SizeArchiver(size: size)
        }
      }
    }
  }
  
  func saveTabViewSizes() {
    preferenceManager.tabViewSizes = tabViewSizes
    preferenceManager.synchronize()
  }
  
  // MARK: - NSTabViewDelegate
  
  override func tabView(tabView: NSTabView, willSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, willSelectTabViewItem: tabViewItem)
    
    // Save the size of the tab view item to be unselected
    if let selectedTabView = tabView.selectedTabViewItem {
      tabViewSizes[selectedTabView.label] = SizeArchiver(size: view.frame.size)
    }
    
    // Set the size of the tab view item to be selected
    if let tabViewItem = tabViewItem {
      if let size = tabViewSizes[tabViewItem.label]?.size {
        view.setFrameSize(size)
      }
    }
  }
  
  override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
    super.tabView(tabView, didSelectTabViewItem: tabViewItem)
    
    if let tabViewItem = tabView.selectedTabViewItem {
      if let window = view.window  {
        window.title = tabViewItem.label
        
        if let size = tabViewSizes[tabViewItem.label] {
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
}
