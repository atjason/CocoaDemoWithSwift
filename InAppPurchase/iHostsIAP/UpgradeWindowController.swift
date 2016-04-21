//
//  UpgradeWindowController.swift
//  iHostsIAP
//
//  Created by Jason Zheng on 4/19/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa
import StoreKit
import SwiftyStoreKit

enum UpgradeMode: Int {
  case Purchase
  case Restore
}

enum UpgradeResult: Int {
  case Succeed
  case Failed
  case Cancel
}

class UpgradeWindowController: NSWindowController {
  
  @IBOutlet private weak var tabView: NSTabView!
  @IBOutlet private weak var waitingView: NSTabViewItem!
  @IBOutlet private weak var productListView: NSTabViewItem!
  
  @IBOutlet private weak var upgradeButton: NSButton!
  @IBOutlet private weak var accountTypeButton: NSPopUpButton!
  
  dynamic private var logoImage: NSImage?
  
  dynamic private var accountList = Set<Account>()
  dynamic private var selectedAccount: Account? {
    didSet {
      accountTypeDescription = selectedAccount?.accountType.localizedDescription ?? ""
    }
  }
  dynamic private var accountTypeDescription = ""
  var newAccountType: AccountType?
  private var retrievingProductCount = 0
  
  var alertMessageText = ""
  var alertInformativeText = ""
  
  private let SwiftyStoreKitErrorDomain = "SwiftyStoreKit"
  
  private var windowAppeared = false
  
  override var windowNibName: String? {
    return "UpgradeWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    windowAppeared = true
    
    selectTabViewItem(waitingView)
    
    logoImage = NSImage(named: "AppIcon")
    upgradeButton.keyEquivalent = "\r"
  }
  
  // MARK: - Key Feature
  
  func purchase() {
    windowAppeared = true
    
    if accountList.isEmpty {
      selectTabViewItem(waitingView)
      initAccountList()
    } else {
      selectTabViewItem(productListView)
    }
  }
  
  func restore() {
    windowAppeared = true
    selectTabViewItem(waitingView)
    
    SwiftyStoreKit.restorePurchases(restorePurchasesHandler)
  }
  
  func verify() {
    windowAppeared = true
    selectTabViewItem(waitingView)
    
    #if DEBUG
      let url = ReceiptVerifyURL.Test
    #else
      let url = ReceiptVerifyURL.Production
    #endif
    SwiftyStoreKit.verifyReceipt(receiptVerifyURL: url, password: nil,
                                 session: NSURLSession.sharedSession(),
                                 completion: verifyReceiptHandler)
  }
  
  // MARK: - Action
  
  @IBAction func purchase(sender: NSButton) {
    // This is let binding value be updated.
    window?.endEditingFor(nil)
    
    if let productIdentifier = selectedAccount?.accountType.productIdentifier {
      selectTabViewItem(waitingView)
      
      SwiftyStoreKit.purchaseProduct(productIdentifier, completion: purchaseProductHandler)
    } else {
      // selectedAccount will not be nil. As if no product get, will not come to here.
      NSLog("Product identifier is nil when start to purchase.")
    }
  }
  
  @IBAction func cancel(sender: NSButton) {
    dismissWindowWithResponse(UpgradeResult.Cancel.rawValue)
  }
  
  // MARK: - Handler
  
  func retrieveProductInfoHandler(result: SwiftyStoreKit.RetrieveResult) {
    guard windowAppeared else { return }
    
    switch result {
    case .Success(let product):
      if let productIdentifier = product.productIdentifier, accountType = AccountType.getAccountType(productIdentifier) {
        accountList.insert(Account(accountType: accountType, product: product))
      } else {
        NSLog("Purchase succeed, but failed to get product identifier or account type.")
      }
      
    case .Error(let error):
      NSLog("Could not retrieve product info with error: \(errorString(error as NSError))")
    }

    // TODO: This way may have multi-thread issue.
    retrievingProductCount -= 1
    if retrievingProductCount <= 0 {
      if accountList.isEmpty {
        alertMessageText = "Failed to Get Advanced Account List"
        alertInformativeText = "Please try again later."
        dismissWindowWithResponse(UpgradeResult.Failed.rawValue)
        
      } else {
        // Remove current account type
        for account in accountList {
          if account.accountType.productIdentifier == Preferences.accountType.productIdentifier {
            accountList.remove(account)
          }
        }
        
        // Select the account type with lowest price
        var accountToSelect: Account? = nil
        var lowestPrice = NSDecimalNumber(int: Int32.max)
        for account in accountList {
          if let price = account.product?.price {
            if price.compare(lowestPrice) == NSComparisonResult.OrderedAscending {
              lowestPrice = price
              accountToSelect = account
            }
          }
        }
        
        selectedAccount = accountToSelect
        selectTabViewItem(productListView)
      }
    }
  }
  
  func purchaseProductHandler(result: SwiftyStoreKit.PurchaseResult) {
    guard windowAppeared else { return }
    
    var purchaseFailed = true
    alertInformativeText = ""
    
    switch result {
    case .Success(let productId):
      purchaseFailed = false
      newAccountType = AccountType.getAccountType(productId)
      if newAccountType != nil {
        dismissWindowWithResponse(UpgradeResult.Succeed.rawValue)
      } else {
        NSLog("Purchased succeed, but failed to parse the account type.")
      }
      
    case .Error(let purchaseError):
      
      switch purchaseError {
      case .Failed(let errorType):
        
        let error = errorType as NSError
        if error.domain == SwiftyStoreKitErrorDomain {
          if error.code == SwiftyStoreKit.InternalErrorCode.RestoredPurchaseWhenPurchasing.rawValue {
            purchaseFailed = false
            verify()
          }
          
        } else if error.domain == SKErrorDomain {
          
          switch error.code {
          case SKErrorPaymentCancelled:
            purchaseFailed = false
            dismissWindowWithResponse(UpgradeResult.Cancel.rawValue)
            
          case SKErrorUnknown, SKErrorClientInvalid, SKErrorPaymentInvalid, SKErrorPaymentNotAllowed:
            alertInformativeText = errorString(error as NSError)
            
          default:
            break
          }
        }
        
      case .NoProductIdentifier:
        alertInformativeText = "The advanced acount wasn't found."
        
      case .PaymentNotAllowed:
        alertInformativeText = "You are not allowed to authorize payments."
      }
    }
    
    if purchaseFailed {
      alertMessageText = "Failed to Upgrade"
      if alertInformativeText.isEmpty {
        alertInformativeText = "Unknown error. Please feedback for help."
      }
      dismissWindowWithResponse(UpgradeResult.Failed.rawValue)
    }
  }
  
  func restorePurchasesHandler(result: SwiftyStoreKit.RestoreResults) {
    guard windowAppeared else { return }
    
    newAccountType = nil
    
    var restoreFailed = true
    alertInformativeText = ""
    
    // Note: it will return duplicated products.
    if result.restoredProductIds.count > 0 {
      newAccountType = preferredPaidAccount(result.restoredProductIds)
      
      if newAccountType != nil {
        restoreFailed = false
        dismissWindowWithResponse(UpgradeResult.Succeed.rawValue)
      } else {
        // Note: This should not happen
        alertInformativeText = ""
      }
      
    } else {
      if result.restoreFailedProducts.count > 0 {
        alertInformativeText = ""
        for (errorType, _) in result.restoreFailedProducts {
          alertInformativeText += errorString(errorType as NSError) + "\n"
        }
        
      } else {
        alertInformativeText = "No previous purchases were found."
      }
    }
    
    if restoreFailed {
      alertMessageText = "Failed to Restore"
      dismissWindowWithResponse(UpgradeResult.Failed.rawValue)
    }
  }
  
  func verifyReceiptHandler(result: SwiftyStoreKit.VerifyReceiptResult) {
    guard windowAppeared else { return }
    
    var verifyFailed = true
    alertInformativeText = ""
    
    switch result {
    case .Success(let receipt):
      let productIdentifiers = parseReceiptJSON(receipt)
      newAccountType = preferredPaidAccount(productIdentifiers)
      
      if newAccountType != nil {
        verifyFailed = false
        dismissWindowWithResponse(UpgradeResult.Succeed.rawValue)
      } else {
        // Note: This should not happen
        alertInformativeText = ""
      }
      
    case .Error(let error):
      alertInformativeText = errorString(error as NSError)
    }
    
    if verifyFailed {
      alertMessageText = "Failed to Verify Advanced Account"
      dismissWindowWithResponse(UpgradeResult.Failed.rawValue)
    }
  }
  
  // MARK: - Helper
  
  func preferredPaidAccount(productIdentifiers: [String]) -> AccountType? {
    
    if productIdentifiers.contains(AccountType.Pro.productIdentifier) {
      return AccountType.Pro
      
    } else if productIdentifiers.contains(AccountType.Plus.productIdentifier) {
      return AccountType.Plus
    }
    
    return nil
  }
  
  func parseReceiptJSON(receipt: [String: AnyObject]) -> [String] {
    var products = [String]()
    
    if let receiptRecord = receipt["receipt"] {
      if let in_app = receiptRecord["in_app"] as? [[String: String]] {
        for product in in_app {
          if let product_id = product["product_id"] {
            products.append(product_id)
          }
        }
      }
    }
    
    return products
  }
  
  func dismissWindowWithResponse(response: NSModalResponse) {
    if let window = window {
      window.sheetParent?.endSheet(window, returnCode: response)
    }
    
    selectTabViewItem(waitingView)
    windowAppeared = false
  }
  
  func initAccountList() {
    retrievingProductCount = 2
    
    SwiftyStoreKit.retrieveProductInfo(AccountType.Plus.productIdentifier, completion: retrieveProductInfoHandler)
    SwiftyStoreKit.retrieveProductInfo(AccountType.Pro.productIdentifier, completion: retrieveProductInfoHandler)
  }
  
  func selectTabViewItem(tabViewItem: NSTabViewItem) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tabView.selectTabViewItem(tabViewItem)
    })
  }
  
  func errorString(error: NSError) -> String {
    return "Error code: \(error.code). \(error.localizedDescription)"
  }
}
