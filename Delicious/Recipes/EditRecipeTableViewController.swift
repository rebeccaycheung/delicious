//
//  EditRecipeTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 21/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditRecipeTableViewController: UITableViewController, DatabaseListener, AddToRecipeDelegate {
    
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
    let SECTION_DELETE_RECIPE = 13
    
    var recipe: Recipe?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Check if the user is editing an existing recipe or creating a new one or saving a searched recipe
        if (recipe != nil) {
            if recipe!.id != nil {
                navigationItem.title = "Edit Recipe"
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            } else {
                navigationItem.title = "Searched Recipe"
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        } else {
            navigationItem.title = "Create New Recipe"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
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
    
    // Reload the table when the recipe changes
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        tableView.reloadData()
    }
    
    // Number of sections for the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 14
    }
    
    // Number of items for each section
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
            return recipe?.ingredientNamesList?.count ?? 0
        case SECTION_ADD_INGREDIENT:
            return 1
        case SECTION_INSTRUCTION_LIST:
            return recipe?.instructionsList?.count ?? 0
        case SECTION_ADD_INSTRUCTION:
            return 1
        case SECTION_NOTES_LIST:
            return recipe?.notesList?.count ?? 0
        case SECTION_ADD_NOTES:
            return 1
        case SECTION_TAGS_LIST:
            return recipe?.tagsList?.count ?? 0
        case SECTION_ADD_TAGS:
            return 1
        case SECTION_DELETE_RECIPE:
            if recipe != nil {
                if recipe?.id != nil {
                    return 1
                }
            }
            return 0
        default:
            return 0
        }
    }
    
    // Header names for each section
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
        default:
            return ""
        }
    }
    
    // Populating the table view cells with the appropriate data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditRecipeTableViewCell
        cell.detailLabel.isHidden = true
        switch indexPath.section {
        case SECTION_NAME:
            cell.label.text = recipe?.name ?? "Enter recipe name"
            return cell
        case SECTION_IMAGE:
            if recipe?.imageReference != nil {
                cell.label.text = "Change image"
            } else {
                cell.label.text = "Add an image"
            }
            return cell
        case SECTION_SOURCE:
            cell.label.text = recipe?.source ?? "Enter source"
            return cell
        case SECTION_COOK_TIME:
            if let cookTime = recipe?.cookTime {
                cell.label.text = String(cookTime)
            } else {
                cell.label.text = "Enter cook time"
            }
            return cell
        case SECTION_SERVING_SIZE:
            if let servingSize = recipe?.servingSize {
                cell.label.text = String(servingSize)
            } else {
                cell.label.text = "Enter serving size"
            }
            return cell
        case SECTION_INGREDIENT_LIST:
            if let ingredientNameList = recipe?.ingredientNamesList, let ingredientMeasurementList = recipe?.ingredientMeasurementsList {
                let ingredient = ingredientNameList[indexPath.row]
                let measurement = ingredientMeasurementList[indexPath.row]
                cell.label.text = ingredient
                cell.detailLabel.isHidden = false
                cell.detailLabel.text = measurement
            }
            return cell
        case SECTION_ADD_INGREDIENT:
            cell.label.text = "Add new ingredient"
            return cell
        case SECTION_INSTRUCTION_LIST:
            if let instructionList = recipe?.instructionsList {
                let instruction = instructionList[indexPath.row]
                cell.label.text = instruction
            }
            return cell
        case SECTION_ADD_INSTRUCTION:
            cell.label.text = "Add new instruction"
            return cell
        case SECTION_NOTES_LIST:
            if let notesList = recipe?.notesList {
                let note = notesList[indexPath.row]
                cell.label.text = note
            }
            return cell
        case SECTION_ADD_NOTES:
            cell.label.text = "Add new note"
            return cell
        case SECTION_TAGS_LIST:
            if let tagsList = recipe?.tagsList {
                let tag = tagsList[indexPath.row]
                cell.label.text = tag
            }
            return cell
        case SECTION_ADD_TAGS:
            cell.label.text = "Add new tag"
            return cell
        case SECTION_DELETE_RECIPE:
            cell.label.text = "Delete recipe"
            return cell
        default:
            return cell
        }
    }
    
    // Check which table view cell was selected and prepare the appropriate segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SECTION_NAME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_IMAGE:
            performSegue(withIdentifier: "editImageSegue", sender: self)
            break
        case SECTION_SOURCE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_COOK_TIME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_SERVING_SIZE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_INGREDIENT_LIST:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
            break
        case SECTION_ADD_INGREDIENT:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
            break
        case SECTION_INSTRUCTION_LIST:
            performSegue(withIdentifier: "editInstructionSegue", sender: self)
            break
        case SECTION_ADD_INSTRUCTION:
            performSegue(withIdentifier: "editInstructionSegue", sender: self)
            break
        case SECTION_NOTES_LIST:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_ADD_NOTES:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_ADD_TAGS:
            performSegue(withIdentifier: "addFromPickerSegue", sender: self)
            break
        case SECTION_DELETE_RECIPE:
            deleteAction(item: "recipe", index: 0)
            break
        default:
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
    }
    
    // Prepare the segues depending on what identifer it is
    // Pass data if neccessary to the destination controller
    // Pass delegates if neccessary to the destination controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTextFieldSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditTextFieldViewController
                destination.recipeDelegate = self
                switch selectedRow {
                case SECTION_NAME:
                    destination.labelTitle = "Recipe Name"
                    if recipe != nil {
                        destination.enteredText = recipe?.name
                    }
                    break
                case SECTION_SOURCE:
                    destination.labelTitle = "Source Name"
                    if recipe != nil {
                        destination.enteredText = recipe?.source
                    }
                    break
                case SECTION_COOK_TIME:
                    destination.labelTitle = "Cook Time"
                    if recipe != nil, let cookTime = recipe?.cookTime {
                        destination.enteredText = String(cookTime)
                    }
                    break
                case SECTION_SERVING_SIZE:
                    destination.labelTitle = "Serving Size"
                    if recipe != nil, let servingSize = recipe?.servingSize {
                        destination.enteredText = String(servingSize)
                    }
                    break
                case SECTION_NOTES_LIST:
                    destination.labelTitle = "Note"
                    destination.enteredText = recipe?.notesList![indexPath.row]
                    break
                case SECTION_ADD_NOTES:
                    destination.labelTitle = "Note"
                    break
                default:
                    break
                }
            }
        } else if segue.identifier == "editIngredientSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditIngredientViewController
                destination.recipeDelegate = self
                switch selectedRow {
                case SECTION_INGREDIENT_LIST:
                    destination.selectedIngredient = recipe?.ingredientNamesList![indexPath.row]
                    destination.selectedMeasurement = recipe?.ingredientMeasurementsList![indexPath.row]
                    break
                case SECTION_ADD_INGREDIENT:
                    destination.selectedIngredient = ""
                    destination.selectedMeasurement = ""
                    break
                default:
                    break
                }
            }
        } else if segue.identifier == "addFromPickerSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditUIPickerViewController
                switch selectedRow {
                case SECTION_ADD_TAGS:
                    destination.selectedLabel = "Tag"
                    destination.recipeDelegate = self
                    break
                default:
                    break
                }
            }
        } else if segue.identifier == "editImageSegue" {
            let destination = segue.destination as! EditImageViewController
            destination.recipe = recipe
        } else if segue.identifier == "editInstructionSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditInstructionsViewController
                destination.recipeDelegate = self
                switch selectedRow {
                case SECTION_INSTRUCTION_LIST:
                    destination.selectedInstruction = recipe?.instructionsList![indexPath.row]
                    break
                case SECTION_ADD_INSTRUCTION:
                    break
                default:
                    break
                }
            }
        }
    }
    
    // If user deletes either ingredients, instructions, notes or tags
    // If the recipe does not have an id, i.e. creating a new recipe or saving a searched recipe, then remove the item from the recipe's item list
    // if the recipe does have an id, i.e. editing an existing recipe, then call the function to show the action sheet before permanently deleting the item
    // Reload the table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == SECTION_INGREDIENT_LIST {
                tableView.performBatchUpdates({
                    if recipe?.id == nil {
                        self.recipe?.ingredientNamesList?.remove(at: indexPath.row)
                        self.recipe?.ingredientMeasurementsList?.remove(at: indexPath.row)
                    } else {
                        deleteAction(item: "ingredient", index: indexPath.row)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_INGREDIENT_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_INSTRUCTION_LIST {
                tableView.performBatchUpdates({
                    if recipe?.id == nil {
                        self.recipe?.instructionsList?.remove(at: indexPath.row)
                    } else {
                        deleteAction(item: "instruction", index: indexPath.row)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_INSTRUCTION_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_NOTES_LIST {
                tableView.performBatchUpdates({
                    if recipe?.id == nil {
                        self.recipe?.notesList?.remove(at: indexPath.row)
                    } else {
                        deleteAction(item: "note", index: indexPath.row)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_NOTES_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_TAGS_LIST {
                tableView.performBatchUpdates({
                    if recipe?.id == nil {
                        self.recipe?.tagsList?.remove(at: indexPath.row)
                    } else {
                        deleteAction(item: "tag", index: indexPath.row)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_TAGS_LIST], with: .automatic)
                }, completion: nil)
            }
        }
    }
    
    // Display an action sheet for deleting an item
    func deleteAction(item: String, index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete \(item)", style: .destructive) { action in
            switch item {
            case "ingredient":
                self.recipe?.ingredientNamesList?.remove(at: index)
                self.recipe?.ingredientMeasurementsList?.remove(at: index)
                self.saveRecipe()
                break
            case "instruction":
                self.recipe?.instructionsList?.remove(at: index)
                self.saveRecipe()
                break
            case "note":
                self.recipe?.notesList?.remove(at: index)
                self.saveRecipe()
                break
            case "tag":
                self.recipe?.tagsList?.remove(at: index)
                self.saveRecipe()
                break
            case "recipe":
                self.databaseController?.deleteRecipe(recipe: self.recipe!)
                //Reference - https://stackoverflow.com/questions/30003814/how-can-i-pop-specific-view-controller-in-swift
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                break
            default:
                break
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // When user saves the created recipe or searched recipe, add to the database and also add the tags to the database
    @IBAction func save(_ sender: Any) {
        if recipe?.name != nil {
            if recipe?.id == nil {
                let _ = databaseController?.addRecipe(recipe: recipe!)
                if let tags = recipe?.tagsList {
                    for i in tags {
                        let _ = databaseController?.addTag(name: i)
                    }
                }
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure the name is filled\n"
            displayMessage(title: "Error", message: errorMsg)
        }
    }
    
    // Display alert function
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Delegate to add items to the recipe
    func addToRecipe(type: String, value: String, oldText: String?) {
        if recipe == nil {
            // If recipe does not exist then create one
            recipe = Recipe()
            recipe?.name = "Default name"
            recipe?.source = "Default source"
            recipe?.ingredientNamesList = [String]()
            recipe?.ingredientMeasurementsList = [String]()
            recipe?.instructionsList = [String]()
            recipe?.tagsList = [String]()
            recipe?.notesList = [String]()
        }
        if type == "Recipe Name" {
            recipe?.name = value
        } else if type == "Source Name" {
            recipe?.source = value
        } else if type == "Cook Time" {
            recipe?.cookTime = Int(value)!
        } else if type == "Serving Size" {
            recipe?.servingSize = Int(value)!
        } else if type == "Instructions" {
            // Check if the item was editted
            if oldText != nil, oldText != "" {
                // Replace the existing item with the new values
                let index = recipe!.instructionsList!.firstIndex(of: oldText!)
                recipe!.instructionsList![index!] = value
            } else {
                // Append the item if it does not exist already
                recipe?.instructionsList?.append(value)
            }
        } else if type == "Note" {
            if oldText != nil, oldText != "" {
                let index = recipe!.notesList!.firstIndex(of: oldText!)
                recipe!.notesList![index!] = value
            } else {
                recipe?.notesList?.append(value)
            }
        } else if type == "Ingredient" {
            if oldText != nil, oldText != "" {
                let index = recipe!.ingredientNamesList!.firstIndex(of: oldText!)
                recipe!.ingredientNamesList![index!] = value
            } else {
                recipe?.ingredientNamesList?.append(value)
            }
        } else if type == "Measurement" {
            if oldText != nil, oldText != "" {
                let index = recipe!.ingredientMeasurementsList!.firstIndex(of: oldText!)
                recipe!.ingredientMeasurementsList![index!] = value
            } else {
                recipe?.ingredientMeasurementsList?.append(value)
            }
        } else if type == "Tag" {
            recipe?.tagsList?.append(value)
        }
        
        saveRecipe()
        tableView.reloadData()
    }
    
    // Save the recipe to the database
    func saveRecipe() {
        if recipe != nil {
            if recipe!.id != nil {
                let _ = databaseController?.updateRecipe(recipe: recipe!)
            }
        }
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
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
}
