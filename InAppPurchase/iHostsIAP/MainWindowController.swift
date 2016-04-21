//
//  MainWindowController.swift
//  iHostsIAP
//
//  Created by Jason Zheng on 4/18/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    window?.contentViewController = MainWindowViewContoller()
  }
}