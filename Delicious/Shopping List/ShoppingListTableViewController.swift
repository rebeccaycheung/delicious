//
//  ShoppingListTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_SHOPPING_LIST = 0
    let CELL_SHOPPING_ITEM = "shoppingItemCell"
    var shoppingList: [ShoppingList] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .shoppingList

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            shoppingItemCell.price.text = NSString(format: "%.2f", shoppingItem.price) as String
            shoppingItemCell.brand.text = shoppingItem.brand
            return shoppingItemCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SHOPPING_ITEM, for: indexPath)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editShoppingItemSegue", let cell = sender as? ShoppingListTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! EditShoppingItemViewController
                destination.shoppingItem = shoppingList[indexPath.row]
            }
        } else if segue.identifier == "addShoppingItem" {
            let destination = segue.destination as! EditShoppingItemViewController
        }
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
}

