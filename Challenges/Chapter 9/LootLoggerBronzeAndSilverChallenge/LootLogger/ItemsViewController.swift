//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Marko Kramar on 09/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    var noDataLabel: UILabel?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemStore.allItems.count == 0 {
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            noDataLabel?.text = "No items!"
            noDataLabel?.textColor = UIColor.black
            noDataLabel?.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
        }
        
        switch section {
        case 0:
            return itemStore.allCheapItems().count
        case 1:
            return itemStore.allExpensiveItems().count
        default:
            return itemStore.allItems.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Cheap items (< $50)" : "Expensive items (> $50)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        // Create an instance of UITableViewCell with default appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        */
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the table view
        var item: Item?
        if indexPath.section == 0 {
            item = itemStore.allCheapItems()[indexPath.row]
        } else if indexPath.section == 1 {
            item = itemStore.allExpensiveItems()[indexPath.row]
        }
        
        cell.textLabel?.text = item!.name
        cell.detailTextLabel?.text = "$\(item!.valueInDollars)"
        
        return cell
    }
    
    // Needed for deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            var item: Item?
            if indexPath.section == 0 {
                item = itemStore.allCheapItems()[indexPath.row]
            } else if indexPath.section == 1 {
                item = itemStore.allExpensiveItems()[indexPath.row]
            }
            
            // Remove the item from the store
            itemStore.removeItem(item!)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Needed for reordering rows
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        let isCheap = newItem.valueInDollars < 50
        let itemsSubArray = isCheap ? itemStore.allCheapItems() : itemStore.allExpensiveItems()
        
        // Figure out where that item is in the array
        if let index = itemsSubArray.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: isCheap ? 0 : 1)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }

    
}

