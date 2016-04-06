//
//  MainWindowController.swift
//  Outline
//
//  Created by Jason Zheng on 4/6/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  @IBOutlet weak var outlineView: NSOutlineView!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
}