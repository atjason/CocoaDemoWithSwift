//
//  MainWindowController.swift
//  Outline
//
//  Created by Jason Zheng on 4/6/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

enum MoveDirection {
  case Up, Down
}

class MainWindowController: NSWindowController,
    NSOutlineViewDataSource, NSOutlineViewDelegate {
  
  @IBOutlet weak var outlineView: NSOutlineView!
  
  dynamic var removeButtonEnabled = false
  dynamic var actionButtonEnabled = false
  dynamic var editMenuItemEnabled = false
  dynamic var moveUpMenuItemEnabled = false
  dynamic var moveDownMenuItemEnabled = false
  dynamic var hostsTextFiledEnabled = false
  
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
    nodeA.parent = group
    nodeB.parent = group
    group.children = [nodeA, nodeB]
    
    nodes = [node, group]
  }
  
  // MARK: - lifecycle
  
  override func windowWillLoad() {
    initNodes()
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()    
    
    let index = 0
    outlineView.scrollRowToVisible(index)
    outlineView.expandItem(nil, expandChildren: true)
    
    updateUIStatus()
  }
  
  // MARK: - Helper Functions
  
  func appendItem(item: Node, afterItem: Node?, inout inItems items: [Node]) {
    
    if let parent = afterItem?.parent {
      item.parent = parent
    }
    
    if let afterItem = afterItem {
      if let index = items.indexOf(afterItem) {
        items.insert(item, atIndex: index + 1)
        
        return
      }
    }
    
    items.append(item)
  }
  
  func insertItemInOutlineView(item: Node, outlineView: NSOutlineView) {
    
    var index = 0
    var parent: Node? = nil
    
    if let itemParent = item.parent {
      index = itemParent.children.indexOf(item) ?? 0
      
      parent = itemParent
      
    } else {
      index = nodes.indexOf(item) ?? 0
    }
    
    outlineView.insertItemsAtIndexes(NSIndexSet(index: index),
                                     inParent: parent, withAnimation: .EffectFade)
  }
  
  func selectItem(item: Node, outlineView: NSOutlineView) {
    let index = outlineView.rowForItem(item)
    outlineView.scrollRowToVisible(index)
    outlineView.selectRowIndexes(NSIndexSet(index: index), byExtendingSelection: false)
  }
  
  func editSelectedItemInOutlineView(outlineView: NSOutlineView) {
    let row = outlineView.selectedRow
    if row != -1 {
      outlineView.editColumn(0, row: row, withEvent: nil, select: true)
    }
  }
  
  func removeItem(item: Node, inout itemArray: [Node]) {
    if let index = itemArray.indexOf(item) {
      itemArray.removeAtIndex(index)
    }
  }
  
  func moveItem(item: Node, inout itemArray: [Node], direction: MoveDirection) {
    if let index = itemArray.indexOf(item) {
      var toIndex = index
      switch direction {
      case .Up:
        toIndex -= 1
      default:
        toIndex += 1
      }
      
      if toIndex >= 0 && toIndex < itemArray.count {
        swap(&itemArray[index], &itemArray[toIndex])
      }
    }
  }
  
  func moveItemInOutlineView(direction: MoveDirection) {
    if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) as? Node {
      
      if let parent = selectedItem.parent {
        moveItem(selectedItem, itemArray: &parent.children, direction: direction)
        
      } else {
        moveItem(selectedItem, itemArray: &nodes, direction: direction)
      }
      
      outlineView.reloadData()
      selectItem(selectedItem, outlineView: outlineView)
    }
  }
  
  func canMoveItemInOutlineView(direction: MoveDirection) -> Bool {
    
    if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) as? Node {
      
      let index = outlineView.childIndexForItem(selectedItem)
      let count = outlineView.numberOfChildrenOfItem(selectedItem.parent)
      
      switch direction {
      case .Up:
        return index > 0
      default:
        return index < (count - 1)
      }
    }
    
    return false
  }
  
  func updateUIStatus() {
    if outlineView.selectedRow == -1 {
      removeButtonEnabled = false
      
      actionButtonEnabled = false
      editMenuItemEnabled = false
      moveUpMenuItemEnabled = false
      moveDownMenuItemEnabled = false
      
    } else {
      removeButtonEnabled = true
      
      actionButtonEnabled = true
      editMenuItemEnabled = true
      moveUpMenuItemEnabled = canMoveItemInOutlineView(.Up)
      moveDownMenuItemEnabled = canMoveItemInOutlineView(.Down)
    }
  }
  
  // MARK: - Actions
  
  @IBAction func addNode(sender: NSObject) {
    let item = Node()
    
    if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) as? Node {
      
      // For root item or group
      if selectedItem.parent == nil || selectedItem.isGroup {
        
        appendItem(item, afterItem: selectedItem, inItems: &nodes)
        
      } else { // For child item
        
        if let parent = selectedItem.parent {
          
          appendItem(item, afterItem: selectedItem, inItems: &parent.children)
          
        } else {
          print("Error")
        }
      }
      
    } else { // Currently now item selected. Insert in the end.
      nodes.append(item)
    }
    
    insertItemInOutlineView(item, outlineView: outlineView)
    selectItem(item, outlineView: outlineView)
    editSelectedItemInOutlineView(outlineView)
  }
  
  @IBAction func addGroup(sender: NSObject) {
    let item = Node()
    
    item.title = "Group"
    item.isGroup = true
    
    if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) as? Node {
      
      // For root item or group
      if selectedItem.parent == nil || selectedItem.isGroup {
        
        appendItem(item, afterItem: selectedItem, inItems: &nodes)
        
      } else { // For child item
        appendItem(item, afterItem: selectedItem.parent, inItems: &nodes)
      }
      
    } else {
      appendItem(item, afterItem: nil, inItems: &nodes)
    }
    
    // Insert a sub item
    let subItem = Node()
    subItem.parent = item
    
    appendItem(subItem, afterItem: nil, inItems: &item.children)
    
    // Update in outline view.
    insertItemInOutlineView(item, outlineView: outlineView)
    insertItemInOutlineView(subItem, outlineView: outlineView)
    
    // Must expand parent item before select sub item.
    outlineView.expandItem(item)
    selectItem(subItem, outlineView: outlineView)
    editSelectedItemInOutlineView(outlineView)
  }
  
  // MARK: - NSOutlineViewDataSource
  
  func outlineView(outlineView: NSOutlineView,
                   child index: Int, ofItem item: AnyObject?) -> AnyObject {
    
    if item == nil { // Case of virtual root
      return nodes[index]
      
    } else if let node = item as? Node {
      return node.children[index]
      
    } else {
      // TODO: Use better object
      print("Error: invalid object.")
      return ""
    }
  }
  
  func outlineView(outlineView: NSOutlineView,
                   isItemExpandable item: AnyObject) -> Bool {
    guard let node = item as? Node else {
      print("Error: invalid object.")
      return false
    }
    
    return node.children.count > 0
  }
  
  func outlineView(outlineView: NSOutlineView,
                   numberOfChildrenOfItem item: AnyObject?) -> Int {
    
    if item == nil { // Case of virtual root
      return nodes.count
      
    } else if let node = item as? Node {
      return node.children.count
      
    } else {
      print("Error: invalid object.")
      return 0
    }
  }
  
  func outlineView(outlineView: NSOutlineView,
                   objectValueForTableColumn tableColumn: NSTableColumn?,
                                             byItem item: AnyObject?) -> AnyObject? {
    guard let node = item as? Node else {
      print("Error: invalid object.")
      return nil
    }
    
    return node
  }
  
  @IBAction func removeItem(sender: NSButton) {
    
    let selectedRow = outlineView.selectedRow
    
    if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) as? Node {
      
      // For root item
      if selectedItem.parent == nil && !selectedItem.isGroup {
        
        removeItem(selectedItem, itemArray: &nodes)
        
      } else if selectedItem.isGroup { // For group
        selectedItem.children.removeAll()
        
        removeItem(selectedItem, itemArray: &nodes)
        
      } else { // For child item
        
        if let parent = selectedItem.parent {
          
          removeItem(selectedItem, itemArray: &parent.children)
          
          if parent.children.isEmpty {
            removeItem(parent, itemArray: &nodes)
          }
        }
      }
      
      outlineView.reloadData()
      
      var newSelectedRow = selectedRow
      
      while newSelectedRow >= outlineView.numberOfRows {
        newSelectedRow -= 1
      }
      
      outlineView.scrollRowToVisible(newSelectedRow)
      outlineView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection: false)
      
      if newSelectedRow == -1 {
        // Note: when remove last item, outlineViewSelectionDidChange will not be called.
        //       Thus maunally update status here.
        updateUIStatus()
      }
    }
  }
  
  @IBAction func editSelectedItem(sender: NSObject) {
    editSelectedItemInOutlineView(outlineView)
  }
  
  @IBAction func moveItemUp(sender: NSObject) {
    moveItemInOutlineView(.Up)
  }
  
  @IBAction func moveItemDown(sender: NSObject) {
    moveItemInOutlineView(.Down)
  }
  
  // MARK: - NSOutlineViewDelegate
  
  func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
    
    guard let node = item as? Node else {
      return false
    }
    
    return node.isGroup
  }
  
  func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?,
                   item: AnyObject) -> NSView? {
    // For a group row, the tableColumn == nil.
    // In this case use get the column by outlineView.tableColumns[0]
    let identifier = tableColumn?.identifier ?? outlineView.tableColumns[0].identifier
    return outlineView.makeViewWithIdentifier(identifier, owner: self)
  }
  
  func outlineViewSelectionDidChange(notification: NSNotification) {
    updateUIStatus()
  }
}