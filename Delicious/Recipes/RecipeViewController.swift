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
    @IBOutlet weak var liveModeButton: UIButton!
    
    var recipe: Recipe?
    
    var storageReference = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = recipe?.name

        liveModeButton.layer.cornerRadius = 23
        liveModeButton.layer.borderWidth = 1
        liveModeButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        cookTimeLabel.text = String(recipe!.cookTime)
        servingSizeLabel.text = String(recipe!.servingSize)
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
            destination?.titleDataList = recipe!.ingredientNamesList!
            destination?.detailDataList = recipe!.ingredientMeasurementsList!
        } else if segue.identifier == "instructionsSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            destination?.titleDataList = recipe!.instructionsList!
        } else if segue.identifier == "notesSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            if let notesList = recipe!.notesList {
                destination?.titleDataList = notesList
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "editRecipeSegue" {
            let destination = segue.destination as? EditRecipeTableViewController
            destination?.recipe = recipe
        }
    }
}
