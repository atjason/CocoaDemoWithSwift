//
//  Node.swift
//  OutlineWithController
//
//  Created by Jason Zheng on 4/7/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

class Node: NSObject {
  var title = "Node"
  var children = [Node]()
  
  override init() {
    super.init()
  }
  
  init(title: String) {
    self.title = title
  }
}
