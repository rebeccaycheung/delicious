//
//  EditShoppingListTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Edit shopping list screen
class EditShoppingListTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_SHOPPING_LIST = 0
    let SECTION_ADD_SHOPPING_ITEM = 1
    let CELL_SHOPPING_ITEM = "shoppingItemCell"
    var shoppingList: [ShoppingList] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .shoppingList
    
    var selectedItem: ShoppingList?

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
    
    // Reload the table when the shopping list changes
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        self.shoppingList = shoppingList
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_SHOPPING_LIST:
            return shoppingList.count
        case SECTION_ADD_SHOPPING_ITEM:
            return 1
        default:
            return 0
        }
    }
    
    // Same as the Shopping List Table View Controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SHOPPING_LIST {
            let shoppingItemCell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
            let shoppingItem = shoppingList[indexPath.row]
            shoppingItemCell.item.text = shoppingItem.item
            shoppingItemCell.price.text = "$\(NSString(format: "%.2f", shoppingItem.price) as String)"
            shoppingItemCell.brand.text = shoppingItem.brand
            return shoppingItemCell
        } else if indexPath.section == SECTION_ADD_SHOPPING_ITEM {
            let addCell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
            addCell.item.text = "Add new shopping item"
            addCell.price.text = nil
            addCell.brand.text = nil
            return addCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SHOPPING_LIST {
            tableView.performBatchUpdates({
                // Show action sheet before deleting
                deleteAction(index: indexPath.row)
                // Animate the deletion
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table
                tableView.reloadSections([SECTION_SHOPPING_LIST], with: .automatic)
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare segue for the selected shopping item, pass the shopping item to the editing screen
        if segue.identifier == "editShoppingItemSegue", let cell = sender as? ShoppingListTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.section == SECTION_SHOPPING_LIST {
                    let destination = segue.destination as! EditShoppingItemViewController
                    destination.shoppingItem = shoppingList[indexPath.row]
                }
            }
        }
    }
    
    func deleteAction(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete shopping list item", style: .destructive) { action in
            
            let _ = self.databaseController?.deleteShoppingItem(shoppingItem: self.shoppingList[index])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }

    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
}
