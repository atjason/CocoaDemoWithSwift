//
//  MainWindowViewContoller.swift
//  iHostsIAP
//
//  Created by Jason Zheng on 4/19/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa
import StoreKit
import SwiftyStoreKit

class MainWindowViewContoller: NSViewController {
  
  @IBOutlet weak var imageView: NSImageView!
  @IBOutlet weak var upgradeButton: NSButton!
  @IBOutlet weak var restoreButton: NSButton!
  
  @IBOutlet weak var productTitleLabel: NSTextField!
  @IBOutlet weak var productDescriptionLabel: NSTextField!
  
  lazy var upgradeWindowController: UpgradeWindowController = UpgradeWindowController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = NSImage(named: "AppIcon")
    upgradeButton.keyEquivalent = "\r"
    
    displayAccountType(Preferences.accountType)
  }
  
  // MARK: - Action
  
  @IBAction func purchase(sender: NSButton) {
    showUpgradeWindow(.Purchase)
  }
  
  @IBAction func restore(sender: NSButton) {
    showUpgradeWindow(.Restore)
  }
  
  // MARK: - Helper
  
  func displayAccountType(accountType: AccountType, withAnimation: Bool = false) {
    
    productTitleLabel.stringValue = accountType.localizedTitle
    productDescriptionLabel.stringValue = accountType.localizedDescription
    
    if withAnimation {
      productTitleLabel.alphaValue = 0
      productDescriptionLabel.alphaValue = 0
      
      dispatch_async(dispatch_get_main_queue(), {
        CATransaction.begin()
        CATransaction.setAnimationDuration(3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        self.productTitleLabel.animator().alphaValue = 1
        self.productDescriptionLabel.animator().alphaValue = 1
        CATransaction.commit()
      })
    }
    
    // Adjust window's size
    var yShrunk: CGFloat = 0
    
    if accountType.productIdentifier != AccountType.Free.productIdentifier {
      if !restoreButton.hidden {
        yShrunk += restoreButton.frame.size.height
        restoreButton.hidden = true
      }
      
      if accountType.productIdentifier == AccountType.Pro.productIdentifier && !upgradeButton.hidden {
        yShrunk += upgradeButton.frame.size.height + 20
        upgradeButton.hidden = true
      }
    }
    
    dispatch_async(dispatch_get_main_queue(), {
      if yShrunk > 0 {
        if let window = self.view.window {
          var windowFrame = window.frame
          
          windowFrame.size.height -= yShrunk
          windowFrame.origin.y += yShrunk
          
          window.setFrame(windowFrame, display: true, animate: true)
        }
      }
    })
  }
  
  func showUpgradeWindow(mode: UpgradeMode) {
    if let window = upgradeWindowController.window {
      self.view.window?.beginSheet(window, completionHandler: dealWithUpgradeResponse)
      
      if mode == UpgradeMode.Purchase {
        upgradeWindowController.purchase()
      } else if mode == UpgradeMode.Restore {
        upgradeWindowController.restore()
      }
    }
  }
  
  func dealWithUpgradeResponse(response: NSModalResponse) {
    switch response {
    case UpgradeResult.Succeed.rawValue:
      if let newAccountType = upgradeWindowController.newAccountType {
        Preferences.accountType = newAccountType
        displayAccountType(newAccountType, withAnimation: true)
      }
      
    case UpgradeResult.Failed.rawValue:
      let alert = NSAlert()
      alert.messageText = upgradeWindowController.alertMessageText
      alert.informativeText = upgradeWindowController.alertInformativeText
      if let window = self.view.window {
        alert.beginSheetModalForWindow(window, completionHandler: nil)
      }
      
    default:
      break
    }
  }
}
