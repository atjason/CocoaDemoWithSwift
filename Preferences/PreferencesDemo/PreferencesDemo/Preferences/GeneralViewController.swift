//
//  GeneralViewController.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class GeneralViewController: NSViewController {
  
  dynamic var startAtLogin = false
  
  private let preferenceManager = PreferenceManager.sharedInstance
  
  override func viewDidLoad() {
    startAtLogin = preferenceManager.startAtLogin
  }
  
  override func viewWillDisappear() {
    preferenceManager.startAtLogin = startAtLogin
    preferenceManager.synchronize()
  }
}
