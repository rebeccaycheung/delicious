//
//  ItemTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 24/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Common class for table
class ItemTableViewController: UITableViewController, DatabaseListener{
    
    // Passed in data
    var titleDataList: [String] = []
    var detailDataList: [String] = []
    var type = ""
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To make the cell the height of the content
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "View \(type)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    // Number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of items in the sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDataList.count
    }
    
    // Populate the cells with the appropriate data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        let title = titleDataList[indexPath.row]
        cell.titleLabel.text = title
        if detailDataList.count > 0 {
            let detail = detailDataList[indexPath.row]
            cell.detailLabel.text = detail
        } else {
            cell.detailLabel.text = ""
        }
        return cell
    }
    
    // If the screen is showing ingredients, when an ingredient is selected, show an action sheet
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "ingredients" {
            showActionSheet(item: titleDataList[indexPath.row])
        }
    }
    
    // Show action sheet function
    func showActionSheet(item: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // If chosen to add the item to the shopping list, add it to the database
        // On success, show a message
        let addAction = UIAlertAction(title: "Add \(item) to shopping list", style: .default) { action in
            let added = self.databaseController?.addShoppingItem(item: item, brand: "No brand", price: 0)
            if added != nil {
                self.displayMessage("\(item) was added to shopping list!", "Success")
            } else {
                self.displayMessage("Could not add \(item). Try adding it again", "Error")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(addAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Display alert message function
    func displayMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
}

