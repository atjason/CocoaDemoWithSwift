//
//  PreferenceManager.swift
//  iHosts
//
//  Created by Jason Zheng on 4/9/16.
//  Copyright © 2016 Toolinbox.net. All rights reserved.
//

import Foundation

class PreferenceManager {
  // Single instance
  static let sharedInstance = PreferenceManager()
  
  private init() {
    registerFactoryDefaults()
  }
  
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  private let initializedKey = "Initialized"
  
  var initialized: Bool {
    get {
      return userDefaults.boolForKey(initializedKey)
    }
    
    set {
      userDefaults.setBool(newValue, forKey: initializedKey)
    }
  }
  
//  var nodes: [Node] {
//    get {
//      if let data = userDefaults.objectForKey(hostNodesKey) as? NSData {
//        if let nodes = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Node] {
//          return nodes
//        }
//      }
//      
//      return defaultHostNodes
//    }
//    
//    set {
//      let data = NSKeyedArchiver.archivedDataWithRootObject(newValue)
//      userDefaults.setObject(data, forKey: hostNodesKey)
//    }
//  }
  
  func registerFactoryDefaults() {
    let factoryDefaults = [
      initializedKey: NSNumber(bool: false),
//      everPromptUserForHostsChangedKey: NSNumber(bool: false),
//      activateOneItemInOneGroupKey: NSNumber(bool: false),
//      hostNodesKey: defaultHostNodes,
    ]
    
    userDefaults.registerDefaults(factoryDefaults)
  }
  
  func synchronize() {
    userDefaults.synchronize()
  }
}
