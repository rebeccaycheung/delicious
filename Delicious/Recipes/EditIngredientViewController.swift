//
//  EditIngredientViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditIngredientViewController: UIViewController {

    @IBOutlet weak var ingredient: UITextField!
    @IBOutlet weak var measurement: UITextField!
    
    var selectedIngredient: String?
    var selectedMeasurement: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredient.text = selectedIngredient ?? ""
        measurement.text = selectedMeasurement ?? ""
    }
    
    @IBAction func save(_ sender: Any) {
        if ingredient.text != "", measurement.text != "" {
            recipeDelegate?.addToRecipe(type: "Ingredient", value: ingredient.text!)
            recipeDelegate?.addToRecipe(type: "Measurement", value: measurement.text!)
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if ingredient.text == "" {
                errorMsg += "Must provide an ingredient \n"
            }
            
            if measurement.text == "" {
                errorMsg += "Must provide a measurement \n"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
