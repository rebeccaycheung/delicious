//
//  EditBookmarkViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 15/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditBookmarkViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var bookmark: Bookmarks?
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if bookmark != nil {
            nameTextField.text = bookmark?.name
            urlTextField.text = bookmark?.url
        } else {
            nameTextField.text = "Enter bookmark name"
            urlTextField.text = "Enter bookmark url"
        }
    }
    
    @IBAction func saveBookmark(_ sender: Any) {
        if nameTextField.text != "", urlTextField.text != "" {
            let _ = databaseController?.updateBookmark(name: nameTextField.text!, url: urlTextField.text!)
            navigationController?.popViewController(animated: true)
            return
        } else {
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
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
