//
//  EditUIPickerViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 31/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Picker common class
class EditUIPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DatabaseListener, AddToRecipeDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // Pass in optional data
    var selectedLabel: String?
    
    // Set up lists
    var pickerData: [String] = []
    var recipeList: [Recipe] = []
    
    // Set up delegates
    weak var recipeDelegate: AddToRecipeDelegate?
    weak var menuDelegate: AddRecipeToMenuDelegate?
    
    // Set up database and listener
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .tag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Set navigation title to the passed in data
        navigationItem.title = "Edit \(selectedLabel!)"
        
        // Set the label with the passed in data
        label.text = "Add \(selectedLabel!)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Check if the user is selecting a recipe to add to the menu, hide the button to add new items
        if selectedLabel == "Recipe" {
            button.isHidden = true
        }
        
        // Set the title of the button
        button.setTitle("Add new \(selectedLabel!)", for: .normal)
        
        // Button style
        button.layer.cornerRadius = 23
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        // Picker view delegates
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    // Check what the user is picking and change the listener to the appropriate one
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch selectedLabel {
        case "Tag":
            listenerType = .tag
            break
        case "Recipe":
            listenerType = .recipe
            break
        default:
            break
        }
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // When recipes change, update the recipe picker data and the picker data the picker reads from
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        for i in recipe {
            if !pickerData.contains(i.name) {
                pickerData.append(i.name)
                recipeList.append(i)
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    // When tags change, update the picker data the picker reads from
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        for i in tag {
            if !pickerData.contains(i.name) {
                pickerData.append(i.name)
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    // Number of pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Title for each selection
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // When the button is pressed, prepare the segue
    @IBAction func addNewItem(_ sender: Any) {
       switch selectedLabel {
       case "Tag":
           performSegue(withIdentifier: "addNewItemSegue", sender: self)
           break
       default:
           break
       }
    }
    
    // Prepare the segue to the edit text field controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewItemSegue" {
            let destination = segue.destination as! EditTextFieldViewController
            destination.labelTitle = "New \(selectedLabel!)"
            destination.recipeDelegate = self
        }
    }
    
    // On save, if the a tag has been selected, send it back to the previous controller its the delegate
    // If a recipe has been selected, send it back to the previous controller via its delegate
    @IBAction func save(_ sender: Any) {
        let item = pickerData[pickerView.selectedRow(inComponent: 0)]
        switch selectedLabel {
        case "Tag":
            recipeDelegate?.addToRecipe(type: selectedLabel!, value: item, oldText: nil)
            break
        case "Recipe":
            menuDelegate?.addRecipeToMenu(recipe: recipeList[pickerView.selectedRow(inComponent: 0)])
        default:
            break
        }
        navigationController?.popViewController(animated: true)
        return
    }
    
    // Delegate to add a new tag to the database
    func addToRecipe(type: String, value: String, oldText: String?) {
        switch type {
        case "New Tag":
            databaseController?.addTag(name: value)
            break
        default:
            break
        }
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
}

