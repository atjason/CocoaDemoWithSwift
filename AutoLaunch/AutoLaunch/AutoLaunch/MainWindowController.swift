//
//  MainWindowController.swift
//  AutoLaunch
//
//  Created by Jason Zheng on 4/14/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa
import ServiceManagement

class MainWindowController: NSWindowController {
  
  @IBOutlet weak var autoLaunchCheckbox: NSButton!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  @IBAction func set(sender: NSButton) {
    
    let appBundleIdentifier = "com.atjason.swift.cocoa.AutoLaunchHelper"
    let autoLaunch = (autoLaunchCheckbox.state == NSOnState)
    if SMLoginItemSetEnabled(appBundleIdentifier, autoLaunch) {
      if autoLaunch {
        NSLog("Successfully add login item.")
      } else {
        NSLog("Successfully remove login item.")
      }
      
    } else {
      NSLog("Failed to add login item.")
    }
  }
}
