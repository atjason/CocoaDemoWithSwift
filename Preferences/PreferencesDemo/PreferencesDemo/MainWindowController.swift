//
//  MainWindowController.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  var preferencesWindowController: PreferencesWindowController?
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  @IBAction func showPreferences(sender: NSButton) {
    if preferencesWindowController == nil {
      let storyboard = NSStoryboard(name: "Preferences", bundle: NSBundle.mainBundle())
      if let controller = storyboard.instantiateInitialController() as? PreferencesWindowController {
        preferencesWindowController = controller
      } else {
        print("The controller of preferences main window wasn't correctly set.")
      }
    }
    
    preferencesWindowController?.showWindow(self)
  }
}
