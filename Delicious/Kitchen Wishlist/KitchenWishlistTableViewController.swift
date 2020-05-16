//
//  KitchenWishlistTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class KitchenWishlistTableViewController: UITableViewController, DatabaseListener {

    let SECTION_WISHLIST = 0
    let SECTION_WISHLIST_TOTAL_PRICE = 1
    let SECTION_WISHLIST_TOTAL_PRICE_SPENT = 2
    let CELL_WISHLIST_ITEM = "kitchenWishlistItemCell"
    var wishlist: [Wishlist] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .wishlist
    
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
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        self.wishlist = wishlist
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_WISHLIST:
            return wishlist.count
        case SECTION_WISHLIST_TOTAL_PRICE:
            return 1
        case SECTION_WISHLIST_TOTAL_PRICE_SPENT:
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
        } else if indexPath.section == SECTION_WISHLIST_TOTAL_PRICE {
            let totalPriceCell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath) as! KitchenWishlistTableViewCell
            totalPriceCell.name.text = "Total Price"
            return totalPriceCell
        } else if indexPath.section == SECTION_WISHLIST_TOTAL_PRICE_SPENT {
            let totalPriceSpentCell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath) as! KitchenWishlistTableViewCell
            totalPriceSpentCell.name.text = "Total Price Spent"
            return totalPriceSpentCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_WISHLIST_ITEM, for: indexPath)
            return cell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWishlistItemSegue", let cell = sender as? KitchenWishlistTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! EditKitchenWishlistViewController
                destination.wishlistItem = wishlist[indexPath.row]
            }
        } else if segue.identifier == "addWishlistItemSegue" {
            let destination = segue.destination as! EditKitchenWishlistViewController
        }
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
}
