//
//  Size.swift
//  PreferencesDemo
//
//  Created by Jason Zheng on 4/13/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class SizeArchiver: NSObject, NSCoding {
  private static let sizeKey = "Size"
  
  var size = NSSize()
  
  var width: CGFloat {
    return size.width
  }
  
  var height: CGFloat {
    return size.height
  }
  
  override init() {
    super.init()
  }
  
  init(size: NSSize) {
    super.init()
    
    self.size = size
  }
  
  // MARK: - NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    super.init()
    
    self.size = aDecoder.decodeSizeForKey(SizeArchiver.sizeKey)
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeSize(self.size, forKey: SizeArchiver.sizeKey)
  }
}
