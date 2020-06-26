//
//  RecipeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseStorage

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipe: Recipe?
    
    var storageReference = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = recipe?.name
        
        cookTimeLabel.text = "Cook time: \(recipe!.cookTime)"
        servingSizeLabel.text = "Serving size: \(recipe!.servingSize)"
        sourceLabel.text = recipe?.source
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let ref = self.storageReference.reference(forURL: recipe!.imageReference!)
//        let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            do {
//                if let error = error {
//                    print(error)
//                } else {
//                    let image = UIImage(data: data!)
//                    self.recipeImage.image = image
//                    self.recipeImage.frame = CGRect(x: 0, y: 150, width: 374, height: 164)
//                }
//            } catch let err {
//                print(err)
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingredientsSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if let ingredientNamesList = recipe!.ingredientNamesList {
                if ingredientNamesList.count > 0 {
                    destination?.titleDataList = ingredientNamesList
                } else {
                    destination?.titleDataList = ["No ingredients"]
                    }
                if let ingredientMeasurementsList = recipe!.ingredientMeasurementsList {
                    if ingredientMeasurementsList.count > 0 {
                        destination?.detailDataList = ingredientMeasurementsList
                    }
                }
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "instructionsSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if let instructionsList = recipe!.instructionsList {
                if instructionsList.count > 0 {
                    destination?.titleDataList = instructionsList
                } else {
                    destination?.titleDataList = ["No instructions"]
                }
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "notesSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if let notesList = recipe!.notesList {
                if notesList.count > 0 {
                    destination?.titleDataList = notesList
                } else {
                    destination?.titleDataList = ["No notes"]
                }
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "editRecipeSegue" {
            let destination = segue.destination as? EditRecipeTableViewController
            destination?.recipe = recipe
        }
    }
}
