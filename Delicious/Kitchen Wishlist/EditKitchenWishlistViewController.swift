//
//  EditKitchenWishlistViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Editing wishlist item screen
class EditKitchenWishlistViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var price: UITextField!
    
    var wishlistItem: Wishlist?
    var isAdd = false
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field delegate
        name.delegate = self
        brand.delegate = self
        price.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Check if the user is creating a new wishlist item or editing an existing one
        if wishlistItem != nil {
            name.text = wishlistItem?.name
            brand.text = wishlistItem?.brand
            price.text = NSString(format: "%.2f", wishlistItem!.price) as String
        } else {
            name.text = ""
            brand.text = ""
            price.text = ""
            isAdd = true
        }
    }
    
    // When the user saves the item, check if the text fields have been filled
    @IBAction func saveWishlistItem(_ sender: Any) {
        if name.text != "", brand.text != "", price.text != "" {
            if (isAdd) {
                // If the item is new, then use the add database protocol
                let priceProcessed: Float? = Float(price.text!)
                if priceProcessed != nil {
                    let _ = databaseController?.addWishlistItem(name: name.text!, brand: brand.text!, price: priceProcessed!)
                } else {
                    let errorMsg = "Please ensure price is a number\n"
                    displayMessage(title: "", message: errorMsg)
                }
            } else {
                // If the item exists, then use the update database protocol
                wishlistItem?.name = name.text!
                wishlistItem?.brand = brand.text!
                let priceProcessed: Float? = Float(price.text!)
                if priceProcessed != nil {
                    wishlistItem?.price = priceProcessed!
                } else {
                    let errorMsg = "Please ensure price is a number\n"
                    displayMessage(title: "", message: errorMsg)
                }
                let _ = databaseController?.updateWishlistItem(item: wishlistItem!)
            }
            navigationController?.popViewController(animated: true)
            return
        } else {
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if name.text == "" {
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
