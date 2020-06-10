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
    
    func favoriteItems() -> [Item] {
        return allItems.filter { $0.isFavorite }
    }
}
