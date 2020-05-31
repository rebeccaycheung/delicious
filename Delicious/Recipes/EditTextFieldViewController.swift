//
//  EditInstructionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditTextFieldViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var labelTitle: String?
    var enteredText: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = labelTitle
        textField.text = enteredText ?? ""
    }
    
    @IBAction func save(_ sender: Any) {
        if textField.text != "" {
            recipeDelegate?.addToRecipe(type: label.text!, value: textField.text!)
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if textField.text == "" {
                errorMsg += "Must provide a value \n"
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
