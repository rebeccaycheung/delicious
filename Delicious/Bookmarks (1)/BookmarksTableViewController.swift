//
//  BookmarksTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 8/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class BookmarksTableViewController: UITableViewController, DatabaseListener {
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
    
    let SECTION_BOOKMARKS = 0
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
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        bookmarksList = bookmarks
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookmarksList.count > 0 {
            return bookmarksList.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if bookmarksList.count > 0 {
            let bookmarksCell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOKMARKS, for: indexPath) as! BookmarksTableViewCell
            let bookmarks = bookmarksList[indexPath.row]
            bookmarksCell.name.text = bookmarks.name
            return bookmarksCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOKMARKS, for: indexPath) as! BookmarksTableViewCell
        cell.name.text = "No bookmarks saved"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bookmarksList.count > 0 {
            let url = bookmarksList[indexPath.row].url
            UIApplication.shared.open(URL(string: "\(url)")!)
        } else {
            tableView.allowsSelection = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBookmarksSegue" {
            let destination = segue.destination as! EditBookmarksListTableViewController
            destination.bookmarksList = bookmarksList
        }
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }

    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
}
