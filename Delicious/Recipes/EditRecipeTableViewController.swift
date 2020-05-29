//
//  EditRecipeTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditRecipeTableViewController: UITableViewController, DatabaseListener {
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
    
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
    
    var ingredientNameList: [String] = []
    var ingredientMeasurementList: [String] = []
    var instructionList: [String] = []
    var notesList: [String] = []
    var tagsList: [String] = []
    var menuList: [String] = []
    
    var recipe: Recipe?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if (recipe != nil) {
            navigationItem.title = "Edit Recipe"
            if (recipe?.instructionsList != nil) {
                instructionList = recipe!.instructionsList!
            }
            if (recipe?.ingredientNamesList != nil) {
                ingredientNameList = recipe!.ingredientNamesList!
            }
            if (recipe?.ingredientMeasurementsList != nil) {
                ingredientMeasurementList = recipe!.ingredientMeasurementsList!
            }
            if (recipe?.notesList != nil) {
                notesList = recipe!.notesList!
            }
            if (recipe?.tagsList != nil) {
                tagsList = recipe!.tagsList!
            }
            if (recipe?.menuList != nil) {
                menuList = recipe!.menuList!
            }
        } else {
            navigationItem.title = "Create New Recipe"
        }
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
            return ingredientNameList.count
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECTION_NAME:
            return "Recipe Name"
        case SECTION_IMAGE:
            return "Image/Video"
        case SECTION_SOURCE:
            return "Source"
        case SECTION_COOK_TIME:
            return "Cook time"
        case SECTION_SERVING_SIZE:
            return "Serving Size"
        case SECTION_INGREDIENT_LIST:
            return "Ingredients"
        case SECTION_INSTRUCTION_LIST:
            return "Instructions"
        case SECTION_NOTES_LIST:
            return "Notes"
        case SECTION_TAGS_LIST:
            return "Tags"
        case SECTION_MENU_LIST:
            return "Menu"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SECTION_NAME:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = recipe?.name ?? "Enter recipe name"
            return cell
        case SECTION_IMAGE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Upload an image"
            return cell
        case SECTION_SOURCE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = recipe?.source ?? "Enter source"
            return cell
        case SECTION_COOK_TIME:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if let cookTime = recipe?.cookTime {
                cell.label.text = String(cookTime)
            } else {
                cell.label.text = "Enter cook time"
            }
            return cell
        case SECTION_SERVING_SIZE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if let servingSize = recipe?.servingSize {
                cell.label.text = String(servingSize)
            } else {
                cell.label.text = "Enter serving size"
            }
            return cell
        case SECTION_INGREDIENT_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if ingredientNameList.count > 0 {
                for ingredient in ingredientNameList {
                    cell.label.text = ingredient
                }
            }
            if ingredientMeasurementList.count > 0 {
                for measurement in ingredientMeasurementList {
                    cell.detailTextLabel?.text = measurement
                }
            }
            return cell
        case SECTION_ADD_INGREDIENT:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new ingredient"
            return cell
        case SECTION_INSTRUCTION_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if instructionList.count > 0 {
                for instruction in instructionList {
                    cell.label.text = instruction
                }
            }
            return cell
        case SECTION_ADD_INSTRUCTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new instruction"
            return cell
        case SECTION_NOTES_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if notesList.count > 0 {
                for note in notesList {
                    cell.label.text = note
                }
            }
            return cell
        case SECTION_ADD_NOTES:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new note"
            return cell
        case SECTION_TAGS_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if tagsList.count > 0 {
                for tag in tagsList {
                    cell.label.text = tag
                }
            }
            return cell
        case SECTION_ADD_TAGS:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            cell.label.text = "Add new tag"
            return cell
        case SECTION_MENU_LIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
            if menuList.count > 0 {
                for menu in menuList {
                    cell.label.text = menu
                }
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SECTION_NAME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_SOURCE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_COOK_TIME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_SERVING_SIZE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_INGREDIENT_LIST:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
        case SECTION_ADD_INGREDIENT:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
        case SECTION_INSTRUCTION_LIST:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_ADD_INSTRUCTION:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_NOTES_LIST:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_ADD_NOTES:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
        case SECTION_ADD_TAGS:
            performSegue(withIdentifier: "addFromPickerSegue", sender: self)
        case SECTION_ADD_MENU:
            performSegue(withIdentifier: "addFromPickerSegue", sender: self)
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
                switch selectedRow {
                case SECTION_NAME:
                    destination.labelTitle = "Recipe Name"
                    if recipe != nil {
                        destination.enteredText = recipe?.name
                    }
                case SECTION_SOURCE:
                    destination.labelTitle = "Source Name"
                    if recipe != nil {
                        destination.enteredText = recipe?.source
                    }
                case SECTION_COOK_TIME:
                    destination.labelTitle = "Cook Time"
                    if recipe != nil, let cookTime = recipe?.cookTime {
                        destination.enteredText = String(cookTime)
                    }
                case SECTION_SERVING_SIZE:
                    destination.labelTitle = "Serving Size"
                    if recipe != nil, let servingSize = recipe?.servingSize {
                        destination.enteredText = String(servingSize)
                    }
                case SECTION_INSTRUCTION_LIST:
                    destination.labelTitle = "Instructions"
                    destination.enteredText = recipe?.instructionsList![indexPath.row]
                case SECTION_ADD_INSTRUCTION:
                    destination.labelTitle = "Instructions"
                case SECTION_NOTES_LIST:
                    destination.labelTitle = "Note"
                    destination.enteredText = recipe?.notesList![indexPath.row]
                case SECTION_ADD_NOTES:
                    destination.labelTitle = "Note"
                default:
                    destination.labelTitle = ""
                }
            }
        } else if segue.identifier == "editIngredientSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditIngredientViewController
                switch selectedRow {
                case SECTION_INGREDIENT_LIST:
                    destination.selectedIngredient = recipe?.ingredientNamesList![indexPath.row]
                    destination.selectedMeasurement = recipe?.ingredientMeasurementsList![indexPath.row]
                case SECTION_ADD_INGREDIENT:
                    destination.selectedIngredient = ""
                    destination.selectedMeasurement = ""
                default:
                    destination.selectedIngredient = ""
                    destination.selectedMeasurement = ""
                }
            }
        }
    }
}
