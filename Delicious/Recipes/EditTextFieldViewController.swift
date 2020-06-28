//
//  EditInstructionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Common class used when one text field is needed
class EditTextFieldViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // Pass data to the text field if it is an existing data
    var labelTitle: String?
    var enteredText: String?
    
    // Set up delegate
    weak var recipeDelegate: AddToRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // Set navigation title to the data that is being changed
        navigationItem.title = "Add \(labelTitle!)"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Set the text field with the data that has been passed
        label.text = labelTitle
        textField.text = enteredText ?? ""
    }
    
    // When the user saves, check if the text field is filled
    // Use the delegate to pass the new data back to the previous controller
    @IBAction func save(_ sender: Any) {
        if textField.text != "" {
            recipeDelegate?.addToRecipe(type: label.text!, value: textField.text!, oldText: enteredText)
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure \(labelTitle!) field if filled\n"
            displayMessage(title: "", message: errorMsg)
        }
    }
    
    // Display alert message function
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // On return, hide the soft keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
