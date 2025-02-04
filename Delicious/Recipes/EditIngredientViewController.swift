//
//  EditIngredientViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Editing ingredients common class
class EditIngredientViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ingredient: UITextField!
    @IBOutlet weak var measurement: UITextField!
    
    // Optional data to pass in
    var selectedIngredient: String?
    var selectedMeasurement: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredient.delegate = self
        measurement.delegate = self
        
        navigationItem.title = "Add Ingredient"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Set the text fields to the passed in data
        ingredient.text = selectedIngredient ?? ""
        measurement.text = selectedMeasurement ?? ""
    }
    
    // On save, check if the text fields are filled
    // Pass the data through the delegate back to the previous controller
    @IBAction func save(_ sender: Any) {
        if ingredient.text != "", measurement.text != "" {
            recipeDelegate?.addToRecipe(type: "Ingredient", value: ingredient.text!, oldText: selectedIngredient)
            recipeDelegate?.addToRecipe(type: "Measurement", value: measurement.text!, oldText: selectedMeasurement)
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if ingredient.text == "" {
                errorMsg += "Ingredient \n"
            }
            
            if measurement.text == "" {
                errorMsg += "Measurement \n"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
    }
    
    // Display alert message function
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // On return, hide soft keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

