//
//  MenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import TagListView

// Menu screen
class MenuViewController: UIViewController, DatabaseListener {
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var servingSize: UILabel!
    
    @IBOutlet weak var tagsListView: TagListView!
    
    var menu: Menu?
    var recipeList: [String] = []
    var ingredientsName: [String] = []
    var ingredientsMeasurement: [String] = []
    var instructions: [String] = []
    var notes: [String] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        tagsListView.textFont = UIFont.systemFont(ofSize: 17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        navigationItem.title = menu?.name
        
        if let cookTime = menu?.cookTime {
            self.cookTime.text = "Cook time: \(cookTime)"
        } else {
            self.cookTime.text = "Cook time: 0"
        }
        
        if let servingSize = menu?.servingSize {
            self.servingSize.text = "Serving size: \(servingSize)"
        } else {
            self.servingSize.text = "Serving size: 0"
        }
        
        tagsListView.removeAllTags()
        
        self.recipeList = []
        self.ingredientsName = []
        self.ingredientsMeasurement = []
        self.instructions = []
        self.notes = []
        if let recipes = menu?.recipes {
            if recipes.count > 0 {
                for recipe in recipes {
                    recipeList.append(recipe.name)
                    if let tags = recipe.tagsList {
                        tagsListView.addTags(tags)
                    }
                    if let ingredientsName = recipe.ingredientNamesList {
                        if ingredientsName.count > 0 {
                            for i in ingredientsName {
                                self.ingredientsName.append(i)
                            }
                        }
                    }
                    if let ingredientsMeasurement = recipe.ingredientMeasurementsList {
                        if ingredientsMeasurement.count > 0 {
                            for i in ingredientsMeasurement {
                                self.ingredientsMeasurement.append(i)
                            }
                        }
                    }
                    if let instructions = recipe.instructionsList {
                        if instructions.count > 0 {
                            for i in instructions {
                                self.instructions.append(i)
                            }
                        }
                    }
                    if let notes = recipe.notesList {
                        if notes.count > 0 {
                            for i in notes {
                                self.notes.append(i)
                            }
                        }
                    }
                }
            }
        }
        
        if let extraIngredients = menu?.extraIngredientsName {
            for i in extraIngredients {
                self.ingredientsName.append(i)
            }
        }
        if let extraIngredientsMeasurement = menu?.extraIngredientsMeasurement {
            for i in extraIngredientsMeasurement {
                self.ingredientsMeasurement.append(i)
            }
        }
        if let extraInstructions = menu?.extraInstructions {
            for i in extraInstructions {
                self.instructions.append(i)
            }
        }
        if let notesList = menu?.notesList {
            for i in notesList {
                self.notes.append(i)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       databaseController?.removeListener(listener: self)
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        self.view.setNeedsDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuSegue" {
            let destination = segue.destination as? EditMenuTableViewController
            destination?.menu = menu
        } else if segue.identifier == "viewIngredientsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "ingredients"
            if ingredientsName.count > 0 {
                destination?.titleDataList = ingredientsName
                if ingredientsMeasurement.count > 0 {
                    destination?.detailDataList = ingredientsMeasurement
                }
            } else {
                destination?.titleDataList = ["No ingredients"]
            }
        } else if segue.identifier == "viewInstructionsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "instructions"
            if instructions.count > 0 {
                destination?.titleDataList = instructions
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "viewNotesSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "notes"
            if notes.count > 0 {
                destination?.titleDataList = notes
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "viewRecipeSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "recipe"
            if recipeList.count > 0 {
                destination?.titleDataList = recipeList
            } else {
                destination?.titleDataList = ["No recipes"]
            }
        }
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
