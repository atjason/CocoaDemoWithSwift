//
//  WaitingViewController.swift
//  iHostsIAP
//
//  Created by Jason Zheng on 4/21/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class WaitingViewController: NSViewController {
  
  @IBOutlet weak var waitingIndicator: NSProgressIndicator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    waitingIndicator.startAnimation(self)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    waitingIndicator.stopAnimation(self)
  }
}
