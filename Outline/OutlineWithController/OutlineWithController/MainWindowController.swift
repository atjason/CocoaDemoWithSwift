//
//  MainWindowController.swift
//  OutlineWithController
//
//  Created by Jason Zheng on 4/7/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  dynamic var nodes = [Node]()
  
  @IBOutlet weak var outlineView: NSOutlineView!
  @IBOutlet weak var treeController: NSTreeController!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  func initNodes() {
    let node = Node(title: "Node")
    let group = Node(title: "Group")
    let nodeA = Node(title: "Node A")
    let nodeB = Node(title: "Node B")
    
    group.children = [nodeA, nodeB]
    
    nodes = [node, group]
  }
  
  // MARK: - lifecycle
  
  override func windowWillLoad() {
    initNodes()
  }
  
  // MARK: - Actions
  
  @IBAction func editNode(_ sender: NSObject) {
    let row = outlineView.selectedRow
    if row != -1 {
      outlineView.editColumn(0, row: row, with: nil, select: true)
    }
  }
  
  @IBAction func refresh(_ sender: NSObject!) {
    treeController.rearrangeObjects()
  }
}
