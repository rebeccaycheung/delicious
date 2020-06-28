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
    let SECTION_EXTRA_INGREDIENTS = 6
    let SECTION_ADD_EXTRA_INGREDIENTS = 7
    let SECTION_EXTRA_INSTRUCTIONS = 8
    let SECTION_ADD_EXTRA_INSTRUCTIONS = 9
    let SECTION_NOTES_LIST = 10
    let SECTION_ADD_NOTES = 11
    let SECTION_DELETE_MENU = 12
    
    var menu: Menu?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .menu
    
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
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 13
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
        case SECTION_EXTRA_INGREDIENTS:
            return menu?.extraIngredientsName?.count ?? 0
        case SECTION_ADD_EXTRA_INGREDIENTS:
            return 1
        case SECTION_EXTRA_INSTRUCTIONS:
            return menu?.extraInstructions?.count ?? 0
        case SECTION_ADD_EXTRA_INSTRUCTIONS:
            return 1
        case SECTION_NOTES_LIST:
            return menu?.notesList?.count ?? 0
        case SECTION_ADD_NOTES:
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
        case SECTION_EXTRA_INGREDIENTS:
            return "Additional Ingredients"
        case SECTION_EXTRA_INSTRUCTIONS:
           return "Additional Instructions"
        case SECTION_NOTES_LIST:
           return "Additional Notes"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditMenuTableViewCell
        cell.detailLabel.isHidden = true
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
        case SECTION_EXTRA_INGREDIENTS:
            if let ingredientNameList = menu?.extraIngredientsName, let ingredientMeasurementList = menu?.extraIngredientsMeasurement {
                let ingredient = ingredientNameList[indexPath.row]
                let measurement = ingredientMeasurementList[indexPath.row]
                cell.label.text = ingredient
                cell.detailLabel.isHidden = false
                cell.detailLabel.text = measurement
            }
            return cell
        case SECTION_ADD_EXTRA_INGREDIENTS:
            cell.label.text = "Add new ingredient"
            return cell
        case SECTION_EXTRA_INSTRUCTIONS:
            if let instructionList = menu?.extraInstructions {
                let instruction = instructionList[indexPath.row]
                cell.label.text = instruction
            }
            return cell
        case SECTION_ADD_EXTRA_INSTRUCTIONS:
            cell.label.text = "Add new instruction"
            return cell
        case SECTION_NOTES_LIST:
            if let notesList = menu?.notesList {
                let note = notesList[indexPath.row]
                cell.label.text = note
            }
            return cell
        case SECTION_ADD_NOTES:
            cell.label.text = "Add new note"
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
            break
        case SECTION_COOK_TIME:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_SERVING_SIZE:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_ADD_RECIPE:
            performSegue(withIdentifier: "addFromPickerSegue", sender: self)
            break
        case SECTION_EXTRA_INGREDIENTS:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
            break
        case SECTION_ADD_EXTRA_INGREDIENTS:
            performSegue(withIdentifier: "editIngredientSegue", sender: self)
            break
        case SECTION_EXTRA_INSTRUCTIONS:
            performSegue(withIdentifier: "editInstructionSegue", sender: self)
            break
        case SECTION_ADD_EXTRA_INSTRUCTIONS:
            performSegue(withIdentifier: "editInstructionSegue", sender: self)
            break
        case SECTION_NOTES_LIST:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_ADD_NOTES:
            performSegue(withIdentifier: "editTextFieldSegue", sender: self)
            break
        case SECTION_DELETE_MENU:
            deleteAction(item: "menu", index: 0)
            break
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
                case SECTION_NOTES_LIST:
                    destination.labelTitle = "Note"
                    destination.enteredText = menu?.notesList![indexPath.row]
                    break
                case SECTION_ADD_NOTES:
                    destination.labelTitle = "Note"
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
        } else if segue.identifier == "editIngredientSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.section
                let destination = segue.destination as! EditIngredientViewController
                destination.recipeDelegate = self
                switch selectedRow {
                case SECTION_EXTRA_INGREDIENTS:
                    destination.selectedIngredient = menu?.extraIngredientsName![indexPath.row]
                    destination.selectedMeasurement = menu?.extraIngredientsMeasurement![indexPath.row]
                    break
                case SECTION_ADD_EXTRA_INGREDIENTS:
                    destination.selectedIngredient = ""
                    destination.selectedMeasurement = ""
                    break
                default:
                    break
                }
            }
        } else if segue.identifier == "editInstructionSegue" {
           if let indexPath = tableView.indexPathForSelectedRow {
               let selectedRow = indexPath.section
               let destination = segue.destination as! EditInstructionsViewController
               destination.recipeDelegate = self
               switch selectedRow {
               case SECTION_EXTRA_INSTRUCTIONS:
                   destination.selectedInstruction = menu?.extraInstructions![indexPath.row]
                   break
               case SECTION_ADD_EXTRA_INSTRUCTIONS:
                   break
               default:
                   break
               }
           }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == SECTION_INCLUDED_RECIPES {
                tableView.performBatchUpdates({
                    deleteAction(item: "recipe", index: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections([SECTION_INCLUDED_RECIPES], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_EXTRA_INGREDIENTS {
                tableView.performBatchUpdates({
                    deleteAction(item: "ingredient", index: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections([SECTION_EXTRA_INGREDIENTS], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_EXTRA_INSTRUCTIONS {
                tableView.performBatchUpdates({
                    deleteAction(item: "instruction", index: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections([SECTION_EXTRA_INSTRUCTIONS], with: .automatic)
                }, completion: nil)
            }
            if indexPath.section == SECTION_NOTES_LIST {
                tableView.performBatchUpdates({
                    deleteAction(item: "note", index: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections([SECTION_NOTES_LIST], with: .automatic)
                }, completion: nil)
            }
        }
    }
    
    func deleteAction(item: String, index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete \(item)", style: .destructive) { action in
            switch item {
            case "recipe":
                let _ = self.databaseController?.removeRecipeFromMenu(recipe: self.menu!.recipes![index], menu: self.menu!)
                self.menu?.recipes?.remove(at: index)
                break
            case "ingredient":
                self.menu?.extraIngredientsName?.remove(at: index)
                self.menu?.extraIngredientsMeasurement?.remove(at: index)
                self.saveMenu()
                break
            case "instruction":
                self.menu?.extraInstructions?.remove(at: index)
                self.saveMenu()
                break
            case "note":
                self.menu?.notesList?.remove(at: index)
                self.saveMenu()
                break
            case "menu":
                self.databaseController?.deleteMenu(menu: self.menu!)
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
    
    func addToRecipe(type: String, value: String, oldText: String?) {
        if type == "Menu Name" {
            menu?.name = value
        } else if type == "Cook Time" {
            menu?.cookTime = Int(value)
        } else if type == "Serving Size" {
            menu?.servingSize = Int(value)
        } else if type == "Instructions" {
            if menu?.extraInstructions == nil {
                print("got here")
                menu?.extraInstructions = [String]()
            }
            if oldText != nil, oldText != "" {
                let index = menu!.extraInstructions!.firstIndex(of: oldText!)
                menu!.extraInstructions![index!] = value
            } else {
                menu?.extraInstructions?.append(value)
            }
        } else if type == "Note" {
            if menu?.notesList == nil {
                menu?.notesList = [String]()
            }
            if oldText != nil, oldText != "" {
                let index = menu!.notesList!.firstIndex(of: oldText!)
                menu!.notesList![index!] = value
            } else {
                menu?.notesList?.append(value)
            }
        } else if type == "Ingredient" {
            if menu?.extraIngredientsName == nil {
                menu?.extraIngredientsName = [String]()
            }
            if oldText != nil, oldText != "" {
                let index = menu!.extraIngredientsName!.firstIndex(of: oldText!)
                menu!.extraIngredientsName![index!] = value
            } else {
                menu?.extraIngredientsName?.append(value)
            }
        } else if type == "Measurement" {
            if menu?.extraIngredientsMeasurement == nil {
                menu?.extraIngredientsMeasurement = [String]()
            }
            if oldText != nil, oldText != "" {
                let index = menu!.extraIngredientsMeasurement!.firstIndex(of: oldText!)
                menu!.extraIngredientsMeasurement![index!] = value
            } else {
                menu?.extraIngredientsMeasurement?.append(value)
            }
        }
        
        saveMenu()
        tableView.reloadData()
    }
    
    func addRecipeToMenu(recipe: Recipe) {
        menu?.recipes?.append(recipe)
        let _ = databaseController?.addRecipeToMenu(recipe: recipe, menu: menu!)
        tableView.reloadData()
    }
    
    func saveMenu() {
        let _ = databaseController?.updateMenu(menu: menu!)
        tableView.reloadData()
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
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

