//
//  EditKitchenWishlistViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditKitchenWishlistViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var price: UITextField!
    
    var wishlistItem: Wishlist?
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
    }
    
    @IBAction func saveWishlistItem(_ sender: Any) {
        if name.text != "", brand.text != "", price.text != "" {
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
}
