//
//  EditRecipeTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditRecipeTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_NAME = 0
    let SECTION_IMAGE = 1
    let SECTION_SOURCE = 2
    let SECTION_COOK_TIME = 3
    let SECTION_SERVING_SIZE = 4
    let SECTION_INGREDIENT_LIST = 5
    let SECTION_ADD_INGREDIENT = 6
    let SECTION_INSTRUCTION_LIST = 7
    let SECTION_ADD_INSTRUCTION = 8
    let SECTION_NOTES_LIST = 9
    let SECTION_ADD_NOTES = 10
    let SECTION_TAGS_LIST = 11
    let SECTION_ADD_TAGS = 12
    let SECTION_MENU_LIST = 13
    let SECTION_ADD_MENU = 14
    
    let ingredientList: [String] = []
    let instructionList: [String] = []
    let notesList: [String] = []
    let tagsList: [String] = []
    let menuList: [String] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
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
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 15
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_NAME:
            return 1
        case SECTION_IMAGE:
            return 1
        case SECTION_SOURCE:
            return 1
        case SECTION_COOK_TIME:
            return 1
        case SECTION_SERVING_SIZE:
            return 1
        case SECTION_INGREDIENT_LIST:
            return ingredientList.count
        case SECTION_ADD_INGREDIENT:
            return 1
        case SECTION_INSTRUCTION_LIST:
            return instructionList.count
        case SECTION_ADD_INSTRUCTION:
            return 1
        case SECTION_NOTES_LIST:
            return notesList.count
        case SECTION_ADD_NOTES:
            return 1
        case SECTION_TAGS_LIST:
            return tagsList.count
        case SECTION_ADD_TAGS:
            return 1
        case SECTION_MENU_LIST:
            return menuList.count
        case SECTION_ADD_MENU:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SECTION_NAME:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_IMAGE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_SOURCE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_COOK_TIME:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_SERVING_SIZE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_INGREDIENT_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_ADD_INGREDIENT:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new ingredient"
            return cell
        case SECTION_INSTRUCTION_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_ADD_INSTRUCTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new instruction"
            return cell
        case SECTION_NOTES_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_ADD_NOTES:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new note"
            return cell
        case SECTION_TAGS_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_ADD_TAGS:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new tag"
            return cell
        case SECTION_MENU_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = ""
            return cell
        case SECTION_ADD_MENU:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add to menu"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
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
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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

}
