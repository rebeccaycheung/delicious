//
//  EditShoppingItemViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Editing shopping item screen
class EditShoppingItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var item: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var price: UITextField!
    
    var shoppingItem: ShoppingList?
    var isAdd = false
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field delegate
        item.delegate = self
        brand.delegate = self
        price.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Check if the user is creating a new shopping item or editing an existing one
        if shoppingItem != nil {
            item.text = shoppingItem?.item
            brand.text = shoppingItem?.brand
            price.text = NSString(format: "%.2f", shoppingItem!.price) as String
        } else {
            item.text = ""
            brand.text = ""
            price.text = ""
            isAdd = true
        }
    }
    
    // When the user saves the item, check if the text fields have been filled
    @IBAction func saveShoppingItem(_ sender: Any) {
        if item.text != "", brand.text != "", price.text != "" {
            if (isAdd) {
                // If the item is new, then use the add database protocol
                let priceProcessed: Float? = Float(price.text!)
                if priceProcessed != nil {
                    let _ = databaseController?.addShoppingItem(item: item.text!, brand: brand.text!, price: priceProcessed!)
                } else {
                    let errorMsg = "Please ensure price is a number\n"
                    displayMessage(title: "", message: errorMsg)
                }
            } else {
                // If the item exists, then use the update database protocol
                shoppingItem?.item = item.text!
                shoppingItem?.brand = brand.text!
                let priceProcessed: Float? = Float(price.text!)
                if priceProcessed != nil {
                    shoppingItem?.price = priceProcessed!
                } else {
                    let errorMsg = "Please ensure price is a number\n"
                    displayMessage(title: "", message: errorMsg)
                }
                
                let _ = databaseController?.updateShoppingItem(item: shoppingItem!)
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if item.text == "" {
                errorMsg += "Must provide a name for the item\n"
            }
            
            if brand.text == "" {
                errorMsg += "Must provide a brand for the item\n"
            }
            
            if price.text == "" {
                errorMsg += "Must provide a price for the item\n"
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
