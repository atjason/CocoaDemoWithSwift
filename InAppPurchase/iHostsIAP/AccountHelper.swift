//
//  AccountHelper.swift
//  iHosts
//
//  Created by Jason Zheng on 4/16/16.
//  Copyright © 2016 Toolinbox.net. All rights reserved.
//

import Foundation
import StoreKit

class Account: NSObject {
  var accountType = AccountType.Free
  var product: SKProduct?
  
  override var description: String {
    let title = product?.localizedTitle ?? ""
    let priceString = NSNumberFormatter.localizedStringFromNumber(product?.price ?? 0, numberStyle: .CurrencyStyle)
    return title + " - " + priceString
  }
  
  init(accountType: AccountType, product: SKProduct?) {
    super.init()
    
    self.accountType = accountType
    self.product = product
  }
}

class AccountType: NSObject, NSCoding {
  private static let nodeAmountKey = "Node Amount"
  private static let productIdentifierKey = "Product Identifier"
  private static let localizedTitleKey = "Localized Title"
  private static let localizedDescriptionKey = "Localized Description"
  
  var nodeAmount: Int32 = 0
  var productIdentifier = ""
  var localizedTitle = ""
  var localizedDescription = ""
  
  // MARK: - NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    super.init()
    
    nodeAmount = aDecoder.decodeInt32ForKey(AccountType.nodeAmountKey)
    productIdentifier = (aDecoder.decodeObjectForKey(AccountType.productIdentifierKey) as? String) ?? ""
    localizedTitle = (aDecoder.decodeObjectForKey(AccountType.localizedTitleKey) as? String) ?? ""
    localizedDescription = (aDecoder.decodeObjectForKey(AccountType.localizedDescriptionKey) as? String) ?? ""
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInt32(nodeAmount, forKey: AccountType.nodeAmountKey)
    aCoder.encodeObject(productIdentifier, forKey: AccountType.productIdentifierKey)
    aCoder.encodeObject(localizedTitle, forKey: AccountType.localizedTitleKey)
    aCoder.encodeObject(localizedDescription, forKey: AccountType.localizedDescriptionKey)
  }
  
  private override init() {}
  
  private init(nodeAmount: Int32, productIdentifier: String, localizedTitle: String, localizedDescription: String) {
    self.nodeAmount = nodeAmount
    self.productIdentifier = productIdentifier
    self.localizedTitle = localizedTitle
    self.localizedDescription = localizedDescription
  }
  
  static func getAccountType(productIdentifier: String) -> AccountType? {
    switch productIdentifier {
    case Free.productIdentifier:
      return Free
    case Plus.productIdentifier:
      return Plus
    case Pro.productIdentifier:
      return Pro
    default:
      return nil
    }
  }
  
  private static let nodeAmountOfFreeAccount: Int32 = 4
  private static let nodeAmountOfPlusAccount: Int32 = 10
  private static let nodeAmountOfProAccount: Int32 = 50
  
  private static let productIdentifierPrefix = "net.toolinbox.hosts."
  private static let productLocalizedDescription = NSLocalizedString("Add at most %d Hosts nodes.", comment: "Account")
  
  static let Free = AccountType(nodeAmount: nodeAmountOfFreeAccount,
                                productIdentifier: "",
                                localizedTitle: NSLocalizedString("iHosts Free", comment: "Account"),
                                localizedDescription: String(format: productLocalizedDescription, nodeAmountOfFreeAccount))
  
  static let Plus = AccountType(nodeAmount: nodeAmountOfPlusAccount,
                                productIdentifier: productIdentifierPrefix + "plus",
                                localizedTitle: NSLocalizedString("iHosts Plus", comment: "Account"),
                                localizedDescription: String(format: productLocalizedDescription, nodeAmountOfPlusAccount))
  
  static let Pro = AccountType(nodeAmount: nodeAmountOfProAccount,
                               productIdentifier: productIdentifierPrefix + "pro",
                               localizedTitle: NSLocalizedString("iHosts Pro", comment: "Account"),
                               localizedDescription: String(format: productLocalizedDescription, nodeAmountOfProAccount))  
  
}

class AccountHelper {
  static let sharedInstance = AccountHelper()
  private init() {}
}
