//
//  AdvancedViewController.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class AdvancedViewController: NSViewController {
  
  private let preferenceManager = PreferenceManager.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func reset(sender: NSButton) {
    preferenceManager.reset()
  }
}
