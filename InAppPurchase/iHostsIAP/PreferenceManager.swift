//
//  PreferenceManager.swift
//  iHosts
//
//  Created by Jason Zheng on 4/9/16.
//  Copyright © 2016 Toolinbox.net. All rights reserved.
//

import Foundation

let Preferences = PreferenceManager.sharedInstance

class PreferenceManager {
  // Single instance
  static let sharedInstance = PreferenceManager()
  
  private init() {
    registerFactoryDefaults()
  }
  
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  private let accountTypeKey = "Account Type"
  private let defaultAccountType = AccountType.Free
  private var privateAccountType: AccountType?
  
  var accountType: AccountType {
    get {
      if let accountType = privateAccountType {
        return accountType
        
      } else {
        if let data = userDefaults.objectForKey(accountTypeKey) as? NSData {
          if let accountType = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? AccountType {
            privateAccountType = accountType
            return accountType
          }
        }
      }
      
      return defaultAccountType
    }
    
    set {
      privateAccountType = newValue
      let data = NSKeyedArchiver.archivedDataWithRootObject(newValue)
      userDefaults.setObject(data, forKey: accountTypeKey)
    }
  }
  
  private func registerFactoryDefaults() {
    let factoryDefaults = [
      accountTypeKey: NSKeyedArchiver.archivedDataWithRootObject(defaultAccountType),
    ]
    
    userDefaults.registerDefaults(factoryDefaults)
  }
  
  func synchronize() {
    userDefaults.synchronize()
  }
}
