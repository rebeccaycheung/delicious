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
    func onMenuChange(change: DatabaseChange, menuRecipes: [Recipe]) {
        //
    }
    
    
    private let reuseIdentifier = "recipeCell"
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    var selectedControl: String?
    
    var dataList: [Recipe] = []
    var imageList: [UIImage] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    var usersReference = Firestore.firestore().collection("users")
    var storageReference = Storage.storage()
    var snapshotListener: ListenerRegistration?
    
    weak var showRecipeDelegate: ShowRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if selectedControl == "Recipe" {
            dataList = [Recipe]()
        } else if selectedControl == "Menu" {
            dataList = []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        if let imageReference = dataList[0].imageReference {
            let ref = self.storageReference.reference(forURL: imageReference)
            ref.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageList.append(image)
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        dataList = recipe
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
        return dataList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = dataList[indexPath.row]
        cell.recipeNameLabel.text = recipe.name
        if imageList.count > 0 {
            let image = imageList[indexPath.row]
            cell.recipeImage.image = image
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
        let _ = showRecipeDelegate?.showRecipe(recipe: dataList[indexPath.row])
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
