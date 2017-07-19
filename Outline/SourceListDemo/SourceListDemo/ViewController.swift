//
//  ViewController.swift
//  SourceListDemo
//
//  Created by Jason Zheng on 2017/02/18.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import Cocoa

class Book: NSObject {
  var title = ""
  
  init(_ title: String) {
    self.title = title
  }
}

class BookGroup: NSObject {
  var title = ""
  var books = [Book]()
  
  init(_ title: String) {
    self.title = title
  }
}

class ViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {
  
  @IBOutlet weak var outlineView1: NSOutlineView!
  @IBOutlet weak var outlineView2: NSOutlineView!
  
  var bookGroups = [BookGroup]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initBookGroups()
    
    outlineView1.dataSource = self
    outlineView2.dataSource = self
    
    outlineView1.delegate = self
    outlineView2.delegate = self
    
    expandOutlineView()
  }
  
  // MARK: - Action
  
  @IBAction func reload(_ sender: AnyObject?) {
    reloadOutlineView()
  }
  
  @IBAction func move(_ sender: AnyObject?) {
    for outlineView in [outlineView1] {
      if let book = outlineView?.item(atRow: outlineView!.selectedRow) as? Book {
        let bookInFirstGroup = bookGroups[0].books.contains(book)
        let bookGroupToAdd = bookInFirstGroup ? bookGroups[1] : bookGroups[0]
        let bookGroupToRemove = bookInFirstGroup ? bookGroups[0] : bookGroups[1]
        
        bookGroupToAdd.books.append(book)
        if let index = bookGroupToRemove.books.index(of: book) {
          bookGroupToRemove.books.remove(at: index)
        }
        
        reloadOutlineView()
        
        let index = row(ofBook: book, inOutlineView: outlineView!)
        let indexSet = IndexSet(integer: index)
        outlineView?.selectRowIndexes(indexSet, byExtendingSelection: false)
      }
    }
  }
  
  @IBAction func reset(_ sender: AnyObject?) {
    initBookGroups()
    reloadOutlineView()
  }
  
  // MARK: - NSOutlineViewDataSource
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if item == nil {
      return bookGroups.count
      
    } else if let bookGroup = item as? BookGroup {
      return bookGroup.books.count
    }
    
    return 0
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if item == nil {
      return bookGroups[index]
      
    } else if let bookGroup = item as? BookGroup {
      return bookGroup.books[index]
    }
    
    // TODO Will not come to this case, but it's better to adjust the code.
    return bookGroups[index]
  }
  
  // MARK: - NSOutlineViewDelegate
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    switch item {
    case let bookGroup as BookGroup:
      let view = outlineView.make(withIdentifier: "HeaderCell", owner: self) as! NSTableCellView
      if let textField = view.textField {
        textField.stringValue = bookGroup.title
      }
      return view
      
    case let book as Book:
      let view = outlineView.make(withIdentifier: "DataCell", owner: self) as! NSTableCellView
      
      if let textField = view.textField {
        textField.stringValue = book.title
      }
      
      var image: NSImage? = nil
  
      if bookGroups.first?.books.contains(book) == true {
        image = NSImage(named: "Book")
      } else {
        image = NSImage(named: "BookRead")
      }
  
      image?.isTemplate = true
      view.imageView?.image = image
      
      return view
      
    default:
      return nil
    }
  }
  
  func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
    return (item as? Book)
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return (item is BookGroup)
  }
  
  func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
    return (item is BookGroup)
  }
  
  func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    return (item is Book)
  }
  
  // MARK: - Helper
  
  func initBookGroups() {
    let bookGroupA = BookGroup("Book")
    let bookGroupB = BookGroup("Read Book")
    
    bookGroupA.books.append(Book("Book 1"))
    bookGroupA.books.append(Book("Book 2"))
    
    bookGroupB.books.append(Book("Book 3"))
    
    bookGroups.removeAll()
    bookGroups.append(bookGroupA)
    bookGroups.append(bookGroupB)
  }
  
  func reloadOutlineView() {
//    if let book = bookGroups.first?.books.removeFirst() {
//      bookGroups.last?.books.append(book)
//    }
//    bookGroups.first?.books.append(Book("Book New"))
    
    for outlineView in [outlineView1, outlineView2] {
      outlineView?.reloadData()
      
      expandOutlineView()
    }
  }
  
  func expandOutlineView() {
    for outlineView in [outlineView1, outlineView2] {
      outlineView?.expandItem(nil, expandChildren: true)
      
      let indexSet = IndexSet(integer: 1)
      outlineView?.selectRowIndexes(indexSet, byExtendingSelection: false)
    }
  }
  
  func row(ofBook book: Book, inOutlineView outlineView: NSOutlineView) -> Int {
    var row = -1
    for _ in 0..<outlineView.numberOfChildren(ofItem: nil) { // For book group.
      row += 1
      if let bookGroup = outlineView.item(atRow: row) {
        for _ in 0..<outlineView.numberOfChildren(ofItem: bookGroup) { // For book.
          row += 1
          let theBook = outlineView.item(atRow: row) as? Book
          if theBook == book {
            return row
          }
        }
      }
    }
    
    return -1
  }
}

