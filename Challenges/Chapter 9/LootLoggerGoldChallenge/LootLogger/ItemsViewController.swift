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
    @IBOutlet weak var favoritesFilter: UISegmentedControl!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shouldShowFavoritesOnly() ? itemStore.favoriteItems().count : itemStore.allItems.count
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
        let item = self.shouldShowFavoritesOnly() ? itemStore.favoriteItems()[indexPath.row] : itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name + (item.isFavorite ? " ★" : "")
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    // Needed for deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = self.shouldShowFavoritesOnly() ? itemStore.favoriteItems()[indexPath.row] : itemStore.allItems[indexPath.row]
            
            // Remove the item from the store
            itemStore.removeItem(item)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Needed for reordering rows
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.shouldShowFavoritesOnly() {
            return nil
        }
        
        let item = self.itemStore.allItems[indexPath.row]
        let title = item.isFavorite ? "Unmark as favorite" : "Mark as favorite"
        
        let markAsFavoriteAction = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
            let item = self.itemStore.allItems[indexPath.row]
            item.isFavorite = !item.isFavorite
            completionHandler(true)
            self.tableView.reloadData()
        })
        markAsFavoriteAction.image = UIImage(systemName: item.isFavorite ? "star" : "star.fill")
        markAsFavoriteAction.backgroundColor = item.isFavorite ? .red : .green
        return UISwipeActionsConfiguration(actions: [markAsFavoriteAction])
    }
    
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
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
    
    @IBAction func favoriteFilterChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func shouldShowFavoritesOnly() -> Bool {
        return favoritesFilter.selectedSegmentIndex == 1
    }
    
}

