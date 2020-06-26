//
//  EditKitchenWishlistViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditKitchenWishlistViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var price: UITextField!
    
    var wishlistItem: Wishlist?
    var isAdd = false
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        brand.delegate = self
        price.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
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
    
    @IBAction func saveWishlistItem(_ sender: Any) {
        if name.text != "", brand.text != "", price.text != "" {
            if (isAdd) {
                let _ = databaseController?.addWishlistItem(name: name.text!, brand: brand.text!, price: Float(price.text!)!)
            } else {
                wishlistItem?.name = name.text!
                wishlistItem?.brand = brand.text!
                wishlistItem?.price = Float(price.text!)!
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
