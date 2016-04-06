//
//  MainWindowController.swift
//  Outline
//
//  Created by Jason Zheng on 4/6/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSOutlineViewDataSource {
  
  @IBOutlet weak var outlineView: NSOutlineView!
  
  var nodes = [Node]()
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  func initNodes() {
    let node = Node(title: "Node")
    let group = Node(title: "Group")
    let nodeA = Node(title: "Node A")
    let nodeB = Node(title: "Node B")
    
    group.isGroup = true
    group.children = [nodeA, nodeB]
    
    nodes = [node, group]
  }
  
  override func windowWillLoad() {
    initNodes()
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()    
    
    let index = 0
    outlineView.scrollRowToVisible(index)
    outlineView.expandItem(nil, expandChildren: true)
  }
  
  // MARK: - NSOutlineViewDataSource
  
  func outlineView(outlineView: NSOutlineView,
                   child index: Int, ofItem item: AnyObject?) -> AnyObject {
    
    if item == nil { // Case of virtual root
      return nodes[index]
      
    } else if let hostsItem = item as? Node {
      return hostsItem.children[index]
      
    } else {
      // TODO: Use better object
      print("Error: invalid object.")
      return ""
    }
  }
  
  func outlineView(outlineView: NSOutlineView,
                   isItemExpandable item: AnyObject) -> Bool {
    guard let hostsItem = item as? Node else {
      print("Error: invalid object.")
      return false
    }
    
    return hostsItem.children.count > 0
  }
  
  func outlineView(outlineView: NSOutlineView,
                   numberOfChildrenOfItem item: AnyObject?) -> Int {
    
    if item == nil { // Case of virtual root
      return nodes.count
      
    } else if let hostsItem = item as? Node {
      return hostsItem.children.count
      
    } else {
      print("Error: invalid object.")
      return 0
    }
  }
  
  func outlineView(outlineView: NSOutlineView,
                   objectValueForTableColumn tableColumn: NSTableColumn?,
                                             byItem item: AnyObject?) -> AnyObject? {
    guard let hostsItem = item as? Node else {
      print("Error: invalid object.")
      return nil
    }
    
    return hostsItem
  }
}