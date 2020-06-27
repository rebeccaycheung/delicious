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
    var currentRecipe: Recipe?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    var deleteIngredients = [String]()
    var deleteIngredientMeasurements = [String]()
    var deleteInstructions = [String]()
    var deleteNotes = [String]()
    var deleteTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if (recipe != nil) {
            navigationItem.title = "Edit Recipe"
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
    
    // Reference - https://stackoverflow.com/questions/8228411/detecting-when-the-back-button-is-pressed-on-a-navbar/14155394
    // Check if the back button was pressed
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        // Check if the view is popping off the stack
        if parent == nil {
            //
        }
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 14
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
                    return 1
            }
            return 0
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
        default:
            return ""
        }
    }
    
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
            let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe permantently?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { action in self.databaseController?.deleteRecipe(recipe: self.recipe!)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == SECTION_INGREDIENT_LIST {
                tableView.performBatchUpdates({
                    if recipe?.ingredientNamesList != nil {
                        deleteIngredients.append(recipe!.ingredientNamesList![indexPath.row])
                    }
                    if recipe?.ingredientMeasurementsList != nil {
                        deleteIngredientMeasurements.append(recipe!.ingredientMeasurementsList![indexPath.row])
                    }
                    recipe?.ingredientNamesList?.remove(at: indexPath.row)
                    recipe?.ingredientMeasurementsList?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_INGREDIENT_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_INSTRUCTION_LIST {
                tableView.performBatchUpdates({
                    if recipe?.instructionsList != nil {
                        deleteInstructions.append(recipe!.instructionsList![indexPath.row])
                    }
                    recipe?.instructionsList?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_INSTRUCTION_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_NOTES_LIST {
                tableView.performBatchUpdates({
                    if recipe?.notesList != nil {
                        deleteNotes.append(recipe!.notesList![indexPath.row])
                    }
                    recipe?.notesList?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_NOTES_LIST], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_TAGS_LIST {
                tableView.performBatchUpdates({
                    if recipe?.tagsList != nil {
                        deleteTags.append(recipe!.tagsList![indexPath.row])
                    }
                    recipe?.tagsList?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([SECTION_TAGS_LIST], with: .automatic)
                }, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if recipe?.name != nil {
            if recipe?.id == nil {
                let _ = databaseController?.addRecipe(recipe: recipe!)
                if let tags = recipe?.tagsList {
                    for i in tags {
                        let _ = databaseController?.addTag(name: i)
                    }
                }
            } else {
                let _ = databaseController?.updateRecipe(recipe: recipe!)
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure the name is filled\n"
            displayMessage(title: "", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addToRecipe(type: String, value: String) {
        if recipe == nil {
            recipe = Recipe()
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
            recipe?.instructionsList?.append(value)
        } else if type == "Note" {
            recipe?.notesList?.append(value)
        } else if type == "Ingredient" {
            recipe?.ingredientNamesList?.append(value)
        } else if type == "Measurement" {
            recipe?.ingredientMeasurementsList?.append(value)
        } else if type == "Tag" {
            recipe?.tagsList?.append(value)
        }
        
        tableView.reloadData()
    }
}

