//
//  EditMenuTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditMenuTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_NAME = 0
    let SECTION_INCLUDED_RECIPES = 1
    let SECTION_ADD_RECIPE = 2
    let SECTION_IMAGE = 3
    let SECTION_COOK_TIME = 4
    let SECTION_SERVING_SIZE = 5
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .menu
    
    var menu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Menu"
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_NAME:
            return 1
        case SECTION_INCLUDED_RECIPES:
            return menu?.recipes?.count ?? 0
        case SECTION_ADD_RECIPE:
            return 1
        case SECTION_IMAGE:
            return 1
        case SECTION_COOK_TIME:
            return 1
        case SECTION_SERVING_SIZE:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECTION_NAME:
            return "Menu Name"
        case SECTION_INCLUDED_RECIPES:
            return "Included Recipes"
        case SECTION_IMAGE:
            return "Image/Video"
        case SECTION_COOK_TIME:
            return "Cook time"
        case SECTION_SERVING_SIZE:
            return "Serving size"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
    }
}
