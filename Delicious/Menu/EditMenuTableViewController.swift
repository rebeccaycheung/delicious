//
//  EditMenuTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditMenuTableViewController: UITableViewController, DatabaseListener, AddToRecipeDelegate, AddRecipeToMenuDelegate {
    
    let SECTION_NAME = 0
    let SECTION_INCLUDED_RECIPES = 1
    let SECTION_ADD_RECIPE = 2
    let SECTION_IMAGE = 3
    let SECTION_COOK_TIME = 4
    let SECTION_SERVING_SIZE = 5
    let SECTION_DELETE_MENU = 6
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .menu
    
    var menu: Menu?
    
    var removeRecipes = [Recipe]()
    
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
        return 7
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
        case SECTION_DELETE_MENU:
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditMenuTableViewCell
        switch indexPath.section {
        case SECTION_NAME:
            cell.label.text = menu?.name ?? "Enter menu name"
            return cell
        case SECTION_INCLUDED_RECIPES:
            if let recipeList = menu?.recipes {
                let recipe = recipeList[indexPath.row]
                cell.label.text = recipe.name
            }
            return cell
        case SECTION_ADD_RECIPE:
            cell.label.text = "Add recipe"
            return cell
        case SECTION_IMAGE:
            cell.label.text = "Upload an image"
            return cell
        case SECTION_COOK_TIME:
            if let cookTime = menu?.cookTime {
                cell.label.text = String(cookTime)
            } else {
                cell.label.text = "Enter cook time"
            }
            return cell
        case SECTION_SERVING_SIZE:
            if let servingSize = menu?.servingSize {
                cell.label.text = String(servingSize)
            } else {
                cell.label.text = "Enter serving size"
            }
            return cell
        case SECTION_DELETE_MENU:
            cell.label.text = "Delete menu"
            return cell
        default:
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SECTION_NAME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_COOK_TIME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_SERVING_SIZE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_ADD_RECIPE:
            performSegue(withIdentifier: "addFromPickerSegue", sender: self)
        case SECTION_DELETE_MENU:
            let alertController = UIAlertController(title: "Delete Menu", message: "Are you sure you want to delete this menu permantently?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { action in self.databaseController?.deleteMenu(menu: self.menu!)
                //Reference - https://stackoverflow.com/questions/30003814/how-can-i-pop-specific-view-controller-in-swift
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        default:
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTextFieldSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditTextFieldViewController
                destination.recipeDelegate = self
                switch selectedRow {
                case SECTION_NAME:
                    destination.labelTitle = "Menu Name"
                    if menu != nil {
                        destination.enteredText = menu?.name
                    }
                    break
                case SECTION_COOK_TIME:
                    destination.labelTitle = "Cook Time"
                    if menu != nil, let cookTime = menu?.cookTime {
                        destination.enteredText = String(cookTime)
                    }
                    break
                case SECTION_SERVING_SIZE:
                    destination.labelTitle = "Serving Size"
                    if menu != nil, let servingSize = menu?.servingSize {
                        destination.enteredText = String(servingSize)
                    }
                    break
                default:
                    destination.labelTitle = ""
                }
            }
        } else if segue.identifier == "addFromPickerSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditUIPickerViewController
                destination.menuDelegate = self
                switch selectedRow {
                case SECTION_ADD_RECIPE:
                    destination.selectedLabel = "Recipe"
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INCLUDED_RECIPES {
            tableView.performBatchUpdates({
                if let recipes = menu?.recipes {
                    removeRecipes.append(recipes[indexPath.row])
                        menu!.recipes!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections([SECTION_INCLUDED_RECIPES], with: .automatic)
                }
            }, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if menu?.name != nil, menu?.cookTime != nil, menu?.servingSize != nil {
            let _ = databaseController?.updateMenu(menu: menu!)
            if let recipes = menu?.recipes {
                for recipe in recipes {
                    let _ = databaseController?.addRecipeToMenu(recipe: recipe, menu: menu!)
                }
                if removeRecipes.count > 0 {
                    for recipe in removeRecipes {
                        let _ = databaseController?.removeRecipeFromMenu(recipe: recipe, menu: menu!)
                    }
                }
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if menu?.name == nil {
                errorMsg += "Name\n"
            }
            if menu?.cookTime == nil {
                errorMsg += "Cook time\n"
            }
            if menu?.servingSize == nil {
                errorMsg += "Serving size\n"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addToRecipe(type: String, value: String) {
        if type == "Menu Name" {
            menu?.name = value
        } else if type == "Cook Time" {
            menu?.cookTime = Int(value)
        } else if type == "Serving Size" {
            menu?.servingSize = Int(value)
        }
        tableView.reloadData()
    }
    
    func addRecipeToMenu(recipe: Recipe) {
        menu?.recipes?.append(recipe)
        tableView.reloadData()
    }
}
