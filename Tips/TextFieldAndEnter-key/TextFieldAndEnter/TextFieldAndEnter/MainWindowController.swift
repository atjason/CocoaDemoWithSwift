//
//  MainWindowController.swift
//  TextFieldAndEnter
//
//  Created by Jason Zheng on 4/17/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  dynamic var label = ""
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  @IBAction func onTextFieldEntered(sender: NSTextField) {
    label = sender.stringValue
  }
}
