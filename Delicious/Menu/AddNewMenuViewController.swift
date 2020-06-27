//
//  AddNewMenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 5/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Add a new menu screen
class AddNewMenuViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var menuNameTextField: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field delegate
        menuNameTextField.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    // When the user saves the menu, check if the text field has been filled
    @IBAction func save(_ sender: Any) {
        if menuNameTextField.text != "" {
            // Add the menu to the database
            let _ = databaseController?.addMenu(name: menuNameTextField.text!)
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if menuNameTextField.text == "" {
                errorMsg += "Must provide a name \n"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
    }
    
    // Display the error message method
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Soft keyboard to disappear when the user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
