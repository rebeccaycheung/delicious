//
//  EditUIPickerViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 31/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditUIPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DatabaseListener {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var selectedLabel: String?
    var pickerData: [String] = []
    
    weak var recipeDelegate: AddToRecipeDelegate?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .tag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = selectedLabel
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        for i in tag {
            pickerData.append(i.name)
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
    
    @IBAction func save(_ sender: Any) {
        let tag = pickerData[pickerView.selectedRow(inComponent: 0)]
        recipeDelegate?.addToRecipe(type: "Tag", value: tag)
        navigationController?.popViewController(animated: true)
        return
    }
}
