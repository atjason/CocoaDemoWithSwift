//
//  GeneralViewController.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class GeneralViewController: NSViewController {
  
  // Note: Should bind the checkbox's value to it.
  dynamic var startAtLogin = false
  
  private let preferenceManager = PreferenceManager.sharedInstance
  
  override func viewDidLoad() {
    // Note: Beside this way, another way is directly bound to user defaults.
    //       Check the bind for "Warn before quit".
    startAtLogin = preferenceManager.startAtLogin
  }
  
  override func viewWillDisappear() {
    preferenceManager.startAtLogin = startAtLogin
    preferenceManager.synchronize()
  }
}
