//
//  EditBookmarksTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Edit bookmarks list screen
class EditBookmarksListTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_BOOKMARKS = 0
    let SECTION_ADD_BOOKMARKS = 1
    let CELL_BOOKMARKS = "bookmarksCell"
    var bookmarksList: [Bookmarks] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .bookmarks
    
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
    
    // Reload the table when bookmarks change
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        bookmarksList = bookmarks
        tableView.reloadData()
    }
    
    // 2 table sections, one for the bookmarks and one to add a new bookmark
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Number of items for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_BOOKMARKS:
            return bookmarksList.count
        case SECTION_ADD_BOOKMARKS:
            return 1
        default:
            return 0
        }
    }
    
    // Populating the table view cells with the appropriate data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_BOOKMARKS {
            let bookmarksCell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOKMARKS, for: indexPath) as! BookmarksTableViewCell
            let bookmarks = bookmarksList[indexPath.row]
            bookmarksCell.name.text = bookmarks.name
            return bookmarksCell
        } else if indexPath.section == SECTION_ADD_BOOKMARKS {
            let addBookmarkCell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOKMARKS, for: indexPath) as! BookmarksTableViewCell
            addBookmarkCell.name.text = "Add new bookmark"
            return addBookmarkCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOKMARKS, for: indexPath)
            return cell
        }
    }
    
    // Deleting table view cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_BOOKMARKS {
            tableView.performBatchUpdates({
                // Show action sheet before deleting
                deleteAction(index: indexPath.row)
                // Animate the deletion
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table
                self.tableView.reloadSections([SECTION_BOOKMARKS], with: .automatic)
            }, completion: nil)
        }
    }
    
    // Prepare the segues depending on what identifer it is
    // Pass data if neccessary to the destination controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check which cell was pressed and send the bookmark details to the editing screen
        if segue.identifier == "editBookmarkSegue", let cell = sender as? BookmarksTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.section == SECTION_BOOKMARKS {
                    let destination = segue.destination as! EditBookmarkViewController
                    destination.bookmark = bookmarksList[indexPath.row]
                }
            }
        }
    }
    
    // Display an action sheet for deleting an item
    func deleteAction(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Delete the bookmark from the database
        let deleteAction = UIAlertAction(title: "Delete bookmark", style: .destructive) { action in
            
            let _ = self.databaseController?.deleteBookmark(bookmark: self.bookmarksList[index])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
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

