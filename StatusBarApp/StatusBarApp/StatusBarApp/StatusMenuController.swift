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
  
  override init() {
    super.init()
  }
  
  override func awakeFromNib() {
    
  }
  
  // MRAK: - NSMenuDelegate
  
  func menuWillOpen(menu: NSMenu) {
    
  }
  
  func menuDidClose(menu: NSMenu) {
    
  }
}
