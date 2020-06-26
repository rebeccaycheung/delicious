//
//  EditUIPickerViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 31/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditUIPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DatabaseListener, AddToRecipeDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var selectedLabel: String?
    var pickerData: [String] = []
    var recipeList: [Recipe] = []
    
    weak var recipeDelegate: AddToRecipeDelegate?
    weak var menuDelegate: AddRecipeToMenuDelegate?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .tag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = "Edit \(selectedLabel!)"
        
        label.text = "Add \(selectedLabel!)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if selectedLabel == "Recipe" {
            button.isHidden = true
        }
        button.setTitle("Add new \(selectedLabel!)", for: .normal)
        
        button.layer.cornerRadius = 23
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
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
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        for i in recipe {
            if !pickerData.contains(i.name) {
                pickerData.append(i.name)
                recipeList.append(i)
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        for i in tag {
            if !pickerData.contains(i.name) {
                pickerData.append(i.name)
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewItemSegue" {
            let destination = segue.destination as! EditTextFieldViewController
            destination.labelTitle = "New \(selectedLabel!)"
            destination.recipeDelegate = self
        }
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        switch selectedLabel {
        case "Tag":
            performSegue(withIdentifier: "addNewItemSegue", sender: self)
            break
        default:
            break
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let item = pickerData[pickerView.selectedRow(inComponent: 0)]
        switch selectedLabel {
        case "Tag":
            recipeDelegate?.addToRecipe(type: selectedLabel!, value: item)
            break
        case "Recipe":
            menuDelegate?.addRecipeToMenu(recipe: recipeList[pickerView.selectedRow(inComponent: 0)])
        default:
            break
        }
        navigationController?.popViewController(animated: true)
        return
    }
    
    func addToRecipe(type: String, value: String) {
        switch type {
        case "New Tag":
            databaseController?.addTag(name: value)
            break
        default:
            break
        }
    }
}
