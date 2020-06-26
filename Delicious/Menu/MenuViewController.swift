//
//  MenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var servingSize: UILabel!
    
    var menu: Menu?
    var recipeList: [String] = []
    var ingredientsName: [String] = []
    var ingredientsMeasurement: [String] = []
    var instructions: [String] = []
    var notes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
        
        if let recipes = menu?.recipes {
            if recipes.count > 0 {
                for recipe in recipes {
                    recipeList.append(recipe.name)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuSegue" {
            let destination = segue.destination as? EditMenuTableViewController
            destination?.menu = menu
        } else if segue.identifier == "viewIngredientsSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if ingredientsName.count > 0 {
                destination?.titleDataList = ingredientsName
                if ingredientsMeasurement.count > 0 {
                    destination?.detailDataList = ingredientsMeasurement
                }
            } else {
                destination?.titleDataList = ["No ingredients"]
            }
        } else if segue.identifier == "viewInstructionsSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if instructions.count > 0 {
                destination?.titleDataList = instructions
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "viewNotesSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if notes.count > 0 {
                destination?.titleDataList = notes
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "viewRecipeSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if recipeList.count > 0 {
                destination?.titleDataList = recipeList
            } else {
                destination?.titleDataList = ["No recipes"]
            }
        }
    }
}
