//
//  EditShoppingListTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditShoppingListTableViewController: UITableViewController, DatabaseListener {
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
    
    
    let SECTION_SHOPPING_LIST = 0
    let SECTION_ADD_SHOPPING_ITEM = 1
    let CELL_SHOPPING_ITEM = "shoppingItemCell"
    var shoppingList: [ShoppingList] = []
    
    var deleteShoppingItem: [ShoppingList] = []

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SHOPPING_LIST {
            let shoppingItemCell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
            let shoppingItem = shoppingList[indexPath.row]
            shoppingItemCell.item.text = shoppingItem.item
            shoppingItemCell.price.text = "$\(NSString(format: "%.2f", shoppingItem.price) as String)"
            shoppingItemCell.brand.text = shoppingItem.brand
            return shoppingItemCell
        } else if indexPath.section == SECTION_ADD_SHOPPING_ITEM {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath) as! ShoppingListTableViewCell
            cell.item.text = "Add new shopping item"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SHOPPING_LIST {
            tableView.performBatchUpdates({
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                deleteShoppingItem.append(shoppingList[indexPath.row])
                tableView.reloadSections([SECTION_SHOPPING_LIST], with: .automatic)
            }, completion: nil)
        }
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        if deleteShoppingItem.count > 0 {
            for item in deleteShoppingItem {
                databaseController?.deleteShoppingItem(shoppingItem: item)
            }
        }
        navigationController?.popViewController(animated: true)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editShoppingItemSegue", let cell = sender as? ShoppingListTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.section == SECTION_SHOPPING_LIST {
                    let destination = segue.destination as! EditShoppingItemViewController
                    destination.shoppingItem = shoppingList[indexPath.row]
                }
            }
        }
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
}
