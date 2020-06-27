//
//  EditInstructionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditTextFieldViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var labelTitle: String?
    var enteredText: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        navigationItem.title = "Add \(labelTitle!)"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        label.text = labelTitle
        textField.text = enteredText ?? ""
    }
    
    @IBAction func save(_ sender: Any) {
        if textField.text != "" {
            recipeDelegate?.addToRecipe(type: label.text!, value: textField.text!)
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure \(labelTitle!) field if filled\n"
            displayMessage(title: "", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
