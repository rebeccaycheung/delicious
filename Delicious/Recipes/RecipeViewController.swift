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
        
        cookTimeLabel.text = String(recipe!.cookTime)
        servingSizeLabel.text = String(recipe!.servingSize)
        sourceLabel.text = recipe?.source
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ref = self.storageReference.reference(forURL: recipe!.imageReference!)
        let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
            do {
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    self.recipeImage.image = image
                    self.recipeImage.frame = CGRect(x: 0, y: 150, width: 374, height: 164)
                }
            } catch let err {
                print(err)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedIngredientsTableSegue" {
            let destination = segue.destination as? IngredientsTableViewController
            destination?.view.translatesAutoresizingMaskIntoConstraints = false
            destination?.ingredientsList = recipe!.ingredientNamesList!
            destination?.measurementsList = recipe!.ingredientMeasurementsList!
        }
        
        if segue.identifier == "embedInstructionsTableSegue" {
            let destination = segue.destination as? InstructionsTableViewController
            destination?.instructionsList = recipe!.instructionsList!
        }
        
        if segue.identifier == "editRecipeSegue" {
            let destination = segue.destination as? EditRecipeTableViewController
            destination?.recipe = recipe
        }
    }
}
