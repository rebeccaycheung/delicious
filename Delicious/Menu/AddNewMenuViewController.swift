//
//  AddNewMenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 5/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class AddNewMenuViewController: UIViewController {

    @IBOutlet weak var menuNameTextField: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    @IBAction func save(_ sender: Any) {
        if menuNameTextField.text != "" {
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
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
