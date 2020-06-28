//
//  KitchenWishlistTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Kitchen Wishlist screen
class KitchenWishlistTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_WISHLIST = 0
    let CELL_WISHLIST_ITEM = "kitchenWishlistItemCell"
    var wishlist: [Wishlist] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .wishlist
    
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
    
    // When wishlist changes, reload table
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        self.wishlist = wishlist
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // Number of sections in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of items in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wishlist.count > 0 {
            return wishlist.count
        }
        return 1
    }
    
    // Populating the table view cells with the appropriate data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishlistCell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath) as! KitchenWishlistTableViewCell
        
        if wishlist.count > 0 {
            let wishlistItem = wishlist[indexPath.row]
            wishlistCell.name.text = wishlistItem.name
            wishlistCell.brand.text = wishlistItem.brand
            wishlistCell.price.text = "$\(NSString(format: "%.2f", wishlistItem.price) as String)"
            if (wishlistItem.checked) {
                wishlistCell.accessoryType = .checkmark
            }
            return wishlistCell
        }
        
        wishlistCell.name.text = "No wishlist items"
        wishlistCell.brand.text = nil
        wishlistCell.price.text = nil
        return wishlistCell
    }
    
    // If item has been selected, check if the wishlist item is checked or not and update the database
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if wishlist.count > 0 {
            if indexPath.section == SECTION_WISHLIST {
                let cell = tableView.cellForRow(at: indexPath)
                let wishlistItem = wishlist[indexPath.row]
                if (wishlistItem.checked) {
                    cell?.accessoryType = .none
                    databaseController?.checkWishlistItem(item: wishlistItem, checked: false)
                } else {
                    cell?.accessoryType = .checkmark
                    databaseController?.checkWishlistItem(item: wishlistItem, checked: true)
                }
                // Deselect the row after selecing it
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // When the item is deselected, remove the accessory of the checkmark
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if wishlist.count > 0 {
            if indexPath.section == SECTION_WISHLIST {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // Prepare the segue for the wishlist list, passing the wishlist list to the editing screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWishlistSegue" {
            let destination = segue.destination as! EditWishlistTableViewController
            destination.wishlistList = wishlist
        }
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
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
