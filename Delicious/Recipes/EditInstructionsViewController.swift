//
//  EditInstructionsViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 27/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditInstructionsViewController: UIViewController {
    
    @IBOutlet weak var instructionText: UITextView!
    
    var selectedInstruction: String?
    
    weak var recipeDelegate: AddToRecipeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        instructionText.text = selectedInstruction ?? "Enter instructions here"
    }
    
    @IBAction func save(_ sender: Any) {
        if instructionText.text != "" {
            recipeDelegate?.addToRecipe(type: "Instructions", value: instructionText.text!, oldText: selectedInstruction)
            navigationController?.popViewController(animated: true)
            return
        } else {
            let errorMsg = "Please ensure instructions are filled\n"
            
            displayMessage(title: "", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
