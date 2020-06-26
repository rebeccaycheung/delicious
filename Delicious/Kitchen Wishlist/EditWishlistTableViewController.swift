//
//  EditWishlistTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditWishlistTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_WISHLIST = 0
    let SECTION_ADD_WISHLIST = 1
    let CELL_WISHLIST_ITEM = "kitchenWishlistItemCell"
    var wishlist: [Wishlist] = []
    
    var deleteWishlistItem: [Wishlist] = []
    
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
        self.wishlist = wishlist
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_WISHLIST:
            return wishlist.count
        case SECTION_ADD_WISHLIST:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_WISHLIST {
            let wishlistCell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath) as! KitchenWishlistTableViewCell
            let wishlistItem = wishlist[indexPath.row]
            wishlistCell.name.text = wishlistItem.name
            wishlistCell.brand.text = wishlistItem.brand
            wishlistCell.price.text = NSString(format: "%.2f", wishlistItem.price) as String
            return wishlistCell
        } else if indexPath.section == SECTION_ADD_WISHLIST {
            let totalPriceCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! KitchenWishlistTableViewCell
            totalPriceCell.textLabel?.text = "Add new wishlist item"
            totalPriceCell.accessoryType = .disclosureIndicator
            return totalPriceCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_WISHLIST {
            tableView.performBatchUpdates({
                deleteWishlistItem.append(wishlist[indexPath.row])
                self.wishlist.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections([SECTION_WISHLIST], with: .automatic)
            }, completion: nil)
        }
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        if deleteWishlistItem.count > 0 {
            for item in deleteWishlistItem {
                databaseController?.deleteWishlistItem(wishlistItem: item)
            }
        }
        navigationController?.popViewController(animated: true)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWishlistItemSegue", let cell = sender as? KitchenWishlistTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! EditKitchenWishlistViewController
                if indexPath.section == SECTION_WISHLIST {
                    destination.wishlistItem = wishlist[indexPath.row]
                }
            }
        } else if segue.identifier == "addNewItemSegue" {
            let _ = segue.destination as! EditKitchenWishlistViewController
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
