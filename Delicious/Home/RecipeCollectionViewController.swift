//
//  RecipeCollectionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 19/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RecipeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DatabaseListener {
    
    private let reuseIdentifier = "recipeCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    var selectedControl: String?
    
    var recipeDataList: [Recipe]?
    var menuDataList: [Menu]?
    var imageList: [UIImage] = []
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
        
        if selectedControl == "Recipe" {
            print("recipe")
            listenerType = .recipe
        } else if selectedControl == "Menu" {
            print("menu")
            listenerType = .menu
        }
        
        databaseController?.addListener(listener: self)
        
//        var imageReference = dataList[0].imageReference
//        let ref = self.storageReference.reference(forURL: imageReference!)
//        let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            do {
//                if let error = error {
//                    print(error)
//                } else {
//                    let image = UIImage(data: data!)
//                    self.imageList.append(image!)
//                    self.collectionView.reloadSections([0])
//                }
//            } catch let err {
//                print(err)
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        menuDataList = menu
        collectionView.reloadData()
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        recipeDataList = recipe
        collectionView.reloadData()
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedControl == "Recipe" {
            return recipeDataList!.count
        }
        return menuDataList!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        if selectedControl == "Recipe" {
            let recipe = recipeDataList![indexPath.row]
            cell.recipeNameLabel.text = recipe.name
        } else {
            let menu = menuDataList![indexPath.row]
            cell.recipeNameLabel.text = menu.name
        }
        cell.layer.cornerRadius = 12
        
        if imageList.count > 0 {
            let image = imageList[indexPath.row]
            cell.recipeImage.image = image
            cell.recipeImage.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedControl == "Recipe" {
            let _ = showRecipeDelegate?.showRecipe(recipe: recipeDataList![indexPath.row])
        } else {
            let _ = showMenuDelegate?.showMenu(menu: menuDataList![indexPath.row])
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
