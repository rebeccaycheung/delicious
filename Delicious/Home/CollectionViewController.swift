//
//  CollectionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 19/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// Collection View that is embedded in the container view
class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DatabaseListener {
    
    // Constants used for the Collection View
    private let reuseIdentifier = "recipeCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    // Check which segment control the user was on
    var selectedControl: String?
    
    var recipeDataList: [Recipe]?
    var menuDataList: [Menu]?
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    var storageReference = Storage.storage()
    
    weak var showRecipeDelegate: ShowRecipeDelegate?
    weak var showMenuDelegate: ShowMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check which segment control the user was on and change the database listener based on which segment the user was on
        if selectedControl == "Recipe" {
            listenerType = .recipe
        } else if selectedControl == "Menu" {
            listenerType = .menu
        }
        
        // Add the listener
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the listener
        databaseController?.removeListener(listener: self)
    }
    
    // When a menu changes, reload the collection
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        menuDataList = menu
        collectionView.reloadData()
    }
    
    // When a recipe changes, reload the collection
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        recipeDataList = recipe
        collectionView.reloadData()
    }
    
    // Only 1 section for the collection
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of items in the collection is based on how many items are in the recipe/menu list
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedControl == "Recipe" {
            return recipeDataList!.count
        }
        return menuDataList!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Use the Recipe Collection view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! CollectionViewCell
        
        // Check if the recipe list is not nil
        if let collectionRecipe = recipeDataList {
            // Check which segment control the user was on
            if selectedControl == "Recipe" {
                let recipe = collectionRecipe[indexPath.row]
                
                // For each recipe, assign the name label to the recipe's name
                cell.recipeNameLabel.text = recipe.name
                
                // Load the image for each recipe
                if let imageRef = recipe.imageReference {
                    // Load the No Image from Assests initally, while the images load
                    let image = UIImage(named: "noImage")
                    cell.recipeImage.image = image
                    cell.recipeImage.contentMode = .center
                    
                    // Check what the image reference's prefix is
                    if imageRef.hasPrefix("gs://") {
                        // Load the image from Firestore
                        let ref = self.storageReference.reference(forURL: imageRef)
                        let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            do {
                                if let error = error {
                                    print(error)
                                } else {
                                    let image = UIImage(data: data!)
                                    cell.recipeImage.image = image
                                    cell.recipeImage.contentMode = .scaleAspectFill
                                }
                            }
                        }
                    } else if imageRef.hasPrefix("https://") {
                        // Load the image from the URL
                        let url = URL(string: imageRef)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        cell.recipeImage.image = image
                        cell.recipeImage.contentMode = .scaleAspectFill
                    }
                } else {
                    let image = UIImage(named: "noImage")
                    cell.recipeImage.image = image
                    cell.recipeImage.contentMode = .center
                }
                
                // Image style
                cell.recipeImage.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                cell.recipeImage.layer.cornerRadius = 12
                cell.recipeImage.clipsToBounds = true
            }
        }
        // Check if menu list is not nil
        if let collectionMenu = menuDataList {
            // Check which segment control the user was on
            if selectedControl == "Menu" {
                // For each menu, assign the name label to the menu's name and let the image be the no image from Assets
                let menu = collectionMenu[indexPath.row]
                cell.recipeNameLabel.text = menu.name
                let image = UIImage(named: "noImage")
                cell.recipeImage.image = image
                cell.recipeImage.contentMode = .center
            }
        }
        
        // Cell style
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    // Layout of the Collection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Padding for the Collection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Padding between items in the Collection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // Check which item was selected and pass the item to the Collection's delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedControl == "Recipe" {
            let _ = showRecipeDelegate?.showRecipe(recipe: recipeDataList![indexPath.row])
        } else {
            let _ = showMenuDelegate?.showMenu(menu: menuDataList![indexPath.row])
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
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
}
