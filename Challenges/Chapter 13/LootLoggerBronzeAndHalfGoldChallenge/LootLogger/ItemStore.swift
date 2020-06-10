//
//  ItemStore.swift
//  LootLogger
//
//  Created by Marko Kramar on 09/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    let itemArchiveUrl: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    init() {
        loadChanges()
        
        // Save changes after going to the background and after scene has been deactivated
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get references to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        self.removeItem(movedItem)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    
    @objc func saveChanges() throws {
        print("Now saving changes...")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveUrl, options: [.atomic])
            print("Written to \(itemArchiveUrl.absoluteString)")
            print("Saved all of the items")
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
    
    @objc func loadChanges() {
        print("Now loading changes...")
        do {
            let data = try Data(contentsOf: itemArchiveUrl)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
    }
}
