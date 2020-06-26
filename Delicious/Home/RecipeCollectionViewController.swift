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
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    var storageReference = Storage.storage()
    
    weak var showRecipeDelegate: ShowRecipeDelegate?
    weak var showMenuDelegate: ShowMenuDelegate?
    
    var imageList = [UIImage]()
    var imagePathList = [String]()
    
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
        
        if let collectionRecipe = recipeDataList {
            if selectedControl == "Recipe" {
                let recipe = collectionRecipe[indexPath.row]
                cell.recipeNameLabel.text = recipe.name
                
//                let imageRef = recipe.imageReference ?? ""
                
//                if self.imagePathList.contains(imageRef) == false {
//                    if let image = self.loadImageData(filename: imageRef) {
//                        self.imageList.append(image)
//                        self.imagePathList.append(imageRef)
//                    } else {
                        if let imageRef = recipe.imageReference {
                            let image = UIImage(named: "noImage")
                            cell.recipeImage.image = image
                            
                            if imageRef.hasPrefix("gs://") {
                                let ref = self.storageReference.reference(forURL: imageRef)
                                let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                    do {
                                        if let error = error {
                                            print(error)
                                        } else {
                                            let image = UIImage(data: data!)
//                                            self.imageList.append(image!)
//                                            self.imagePathList.removeLast()
//                                            self.imagePathList.append(imageRef)
                                            cell.recipeImage.image = image
                                            //self.saveImageData(filename: imageRef, imageData: data!)
                                        }
                                    }
                                }
                            } else if imageRef.hasPrefix("https://") {
                                let url = URL(string: imageRef)
                                let data = try? Data(contentsOf: url!)
                                let image = UIImage(data: data!)
//                                self.imageList.append(image!)
//                                self.imagePathList.append(imageRef)
                                cell.recipeImage.image = image
                                //self.saveImageData(filename: imageRef, imageData: data!)
                            } else {
                                let image = UIImage(named: "noImage")
                                cell.recipeImage.image = image
                            }
                        } else {
                            let image = UIImage(named: "noImage")
                            cell.recipeImage.image = image
                        }
                    //}
                //}
                
                cell.recipeImage.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                cell.recipeImage.contentMode = .scaleAspectFill
                cell.recipeImage.layer.cornerRadius = 12
                cell.recipeImage.clipsToBounds = true
            }
        }
        if let collectionMenu = menuDataList {
            if selectedControl == "Menu" {
                let menu = collectionMenu[indexPath.row]
                cell.recipeNameLabel.text = menu.name
                let image = UIImage(named: "noImage")
                cell.recipeImage.image = image
            }
        }
        
        cell.layer.cornerRadius = 12
        
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
    
    func loadImageData(filename: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        
        return image
    }
    
    func saveImageData(filename: String, imageData: Data) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        print(fileURL)
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }
    }
}
