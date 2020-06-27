//
//  EditBookmarkViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 15/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditBookmarkViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var bookmark: Bookmarks?
    var isAdd = false
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field delegate
        nameTextField.delegate = self
        urlTextField.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Check if user is creating a new bookmark or editing an existing one
        if bookmark != nil {
            nameTextField.text = bookmark?.name
            urlTextField.text = bookmark?.url
        } else {
            nameTextField.text = ""
            urlTextField.text = "https://"
            isAdd = true
        }
    }

    @IBAction func saveBookmark(_ sender: Any) {
        // When the user saves the bookmark, check if the name and url text fields are filled in
        if nameTextField.text != "", urlTextField.text != "" {
            if (isAdd) {
                // If the bookmark is new, use the add database protocol
                let _ = databaseController?.addBookmark(name: nameTextField.text!, url: urlTextField.text!)
            } else {
                // If the bookmark is an exisiting bookmark, use the update database protocol
                bookmark?.name = nameTextField.text!
                bookmark?.url = urlTextField.text!
                let _ = databaseController?.updateBookmark(bookmark: bookmark!)
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            // Error message if the text fields aren't filled in
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if nameTextField.text == "" {
                errorMsg += "Must provide a name for the bookmark\n"
            }
            
            if urlTextField.text == "" {
                errorMsg += "Must provide a url for the bookmark\n"
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
