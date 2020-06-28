//
//  ShoppingListTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Shopping list screen
class ShoppingListTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_SHOPPING_LIST = 0
    let CELL_SHOPPING_ITEM = "shoppingItemCell"
    var shoppingList: [ShoppingList] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .shoppingList

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // Reload when shopping items change
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        self.shoppingList = shoppingList
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shoppingList.count > 0 {
            return shoppingList.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shoppingList.count > 0 {
            let shoppingItemCell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
            let shoppingItem = shoppingList[indexPath.row]
            shoppingItemCell.item.text = shoppingItem.item
            // Format the price to convert a float to a string
            shoppingItemCell.price.text = "$\(NSString(format: "%.2f", shoppingItem.price) as String)"
            shoppingItemCell.brand.text = shoppingItem.brand
            shoppingItemCell.item.isHidden = false
            shoppingItemCell.price.isHidden = false
            shoppingItemCell.brand.isHidden = false
            shoppingItemCell.textLabel?.isHidden = true
            // Add check mark accessory if the shopping item has been checked
            if (shoppingItem.checked) {
                shoppingItemCell.accessoryType = .checkmark
            }
            return shoppingItemCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
        cell.textLabel?.text = "No shopping items"
        cell.textLabel?.isHidden = false
        cell.item.isHidden = true
        cell.price.isHidden = true
        cell.brand.isHidden = true
        return cell
    }
    
    // If item has been selected, check if the shopping item is checked or not and update the database
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shoppingList.count > 0 {
            let cell = tableView.cellForRow(at: indexPath)
            let shoppingItem = shoppingList[indexPath.row]
            if (shoppingItem.checked) {
                cell?.accessoryType = .none
                databaseController?.checkShoppingItem(item: shoppingItem, checked: false)
            } else {
                cell?.accessoryType = .checkmark
                databaseController?.checkShoppingItem(item: shoppingItem, checked: true)
            }
            // Deselect the row after selecing it
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // When the item is deselected, remove the accessory of the checkmark
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if shoppingList.count > 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Prepare the segue for the shopping list, passing the shopping list to the editing screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editShoppingListSegue" {
            let destination = segue.destination as! EditShoppingListTableViewController
            destination.shoppingList = shoppingList
        }
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
}
