//
//  EditWishlistTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Edit wishlist list screen
class EditWishlistTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_WISHLIST = 0
    let SECTION_ADD_WISHLIST = 1
    let CELL_WISHLIST_ITEM = "kitchenWishlistItemCell"
    var wishlistList: [Wishlist] = []
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        wishlistList = wishlist
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_WISHLIST:
            return wishlistList.count
        case SECTION_ADD_WISHLIST:
            return 1
        default:
            return 0
        }
    }
    
    // Same as the Kitchen Wishlist Table View Controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishlistCell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath) as! KitchenWishlistTableViewCell
        
        if indexPath.section == SECTION_WISHLIST {
            let wishlistItem = wishlistList[indexPath.row]
            wishlistCell.name.text = wishlistItem.name
            wishlistCell.brand.text = wishlistItem.brand
            wishlistCell.price.text = NSString(format: "%.2f", wishlistItem.price) as String
        } else if indexPath.section == SECTION_ADD_WISHLIST {
            wishlistCell.name.text = "Add new wishlist item"
            wishlistCell.brand.text = nil
            wishlistCell.price.text = nil
        }
        
        return wishlistCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_WISHLIST {
            tableView.performBatchUpdates({
                // Show action sheet before deleting
                deleteAction(index: indexPath.row)
                // Animate the deletion
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table
                tableView.reloadSections([SECTION_WISHLIST], with: .automatic)
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare segue for the selected wishlist item, pass the wishlist item to the editing screen
        if segue.identifier == "editWishlistItemSegue", let cell = sender as? KitchenWishlistTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! EditKitchenWishlistViewController
                if indexPath.section == SECTION_WISHLIST {
                    destination.wishlistItem = wishlistList[indexPath.row]
                }
            }
        }
    }
    
    func deleteAction(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete wishlist item", style: .destructive) { action in
            let _ = self.databaseController?.deleteWishlistItem(wishlistItem: self.wishlistList[index])
            self.wishlistList.remove(at: index)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
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
