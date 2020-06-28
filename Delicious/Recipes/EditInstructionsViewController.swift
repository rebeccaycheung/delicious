//
//  EditInstructionsViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 27/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Editing instructions common class
class EditInstructionsViewController: UIViewController {
    
    @IBOutlet weak var instructionText: UITextView!
    
    // Optional data to pass in
    var selectedInstruction: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Set the text fields to the passed in data
        instructionText.text = selectedInstruction ?? "Enter instructions here"
    }
    
    // On save, check if the text fields are filled
    // Pass the data through the delegate back to the previous controller
    @IBAction func save(_ sender: Any) {
        if instructionText.text != "" {
            recipeDelegate?.addToRecipe(type: "Instructions", value: instructionText.text!, oldText: selectedInstruction)
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure instructions are filled\n"
            
            displayMessage(title: "Error", message: errorMsg)
        }
    }
    
    // Display alert message function
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

