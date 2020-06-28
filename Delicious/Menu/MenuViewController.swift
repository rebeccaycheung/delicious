//
//  MenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseStorage
import TagListView

// Menu screen
class MenuViewController: UIViewController, DatabaseListener {
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var servingSize: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // TagListView is an imported library that shows the tags of a recipe in a tag formation
    @IBOutlet weak var tagsListView: TagListView!
    
    var menu: Menu?
    var recipeList: [String] = []
    var ingredientsName: [String] = []
    var ingredientsMeasurement: [String] = []
    var instructions: [String] = []
    var notes: [String] = []
    
    // Set up database controller and listener
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .menu
    
    // Storage reference
    var storageReference = Storage.storage()
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.imageView.center
        self.view.addSubview(indicator)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Set the tag list to font size 17
        tagsListView.textFont = UIFont.systemFont(ofSize: 17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        // When the screen appears, set the navigation title to the menu name
        navigationItem.title = menu?.name
        
        // When the screen appears, set the labels
        if let cookTime = menu?.cookTime {
            self.cookTime.text = "Cook time: \(cookTime)"
        } else {
            self.cookTime.text = "Cook time: 0"
        }
        
        if let servingSize = menu?.servingSize {
            self.servingSize.text = "Serving size: \(servingSize)"
        } else {
            self.servingSize.text = "Serving size: 0"
        }
        
        loadImage()
        
        // Remove all the existing tags
        tagsListView.removeAllTags()
        
        loadMenuItems()
    }
    
    // Load menu items
    func loadMenuItems() {
        // Empty all the lists
        self.recipeList = []
        self.ingredientsName = []
        self.ingredientsMeasurement = []
        self.instructions = []
        self.notes = []
        
        // If recipes exist in the menu, then append the details of the recipes to the lists above
        if let recipes = menu?.recipes {
            if recipes.count > 0 {
                for recipe in recipes {
                    recipeList.append(recipe.name)
                    if let tags = recipe.tagsList {
                        tagsListView.addTags(tags)
                    }
                    if let ingredientsName = recipe.ingredientNamesList {
                        if ingredientsName.count > 0 {
                            for i in ingredientsName {
                                self.ingredientsName.append(i)
                            }
                        }
                    }
                    if let ingredientsMeasurement = recipe.ingredientMeasurementsList {
                        if ingredientsMeasurement.count > 0 {
                            for i in ingredientsMeasurement {
                                self.ingredientsMeasurement.append(i)
                            }
                        }
                    }
                    if let instructions = recipe.instructionsList {
                        if instructions.count > 0 {
                            for i in instructions {
                                self.instructions.append(i)
                            }
                        }
                    }
                    if let notes = recipe.notesList {
                        if notes.count > 0 {
                            for i in notes {
                                self.notes.append(i)
                            }
                        }
                    }
                }
            }
        }
        
        // Append any extra menu items to the lists above
        if let extraIngredients = menu?.extraIngredientsName {
            for i in extraIngredients {
                self.ingredientsName.append(i)
            }
        }
        if let extraIngredientsMeasurement = menu?.extraIngredientsMeasurement {
            for i in extraIngredientsMeasurement {
                self.ingredientsMeasurement.append(i)
            }
        }
        if let extraInstructions = menu?.extraInstructions {
            for i in extraInstructions {
                self.instructions.append(i)
            }
        }
        if let notesList = menu?.notesList {
            for i in notesList {
                self.notes.append(i)
            }
        }
    }
    
    // Load menu's image
    func loadImage() {
        let blankImage = UIImage()
        self.imageView.image = blankImage
        // Load the image of the recipe
        if let image = menu?.imageReference {
            // Start the indicator
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.clear
            
            // Set the image layout
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.layer.cornerRadius = 12
            self.imageView.clipsToBounds = true
            
            // Check what prefix the image reference is
            // If it is from cloud storage
            if image.hasPrefix("gs://") || image.hasPrefix("https://firebasestorage") {
                // Load the image from cloud storage
                let ref = self.storageReference.reference(forURL: image)
                let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    do {
                        if let error = error {
                            print(error)
                        } else {
                            let image = UIImage(data: data!)
                            // Set the recipe image
                            self.imageView.image = image
                            // Stop the indicator once it loads the image
                            self.indicator.stopAnimating()
                            self.indicator.hidesWhenStopped = true
                        }
                    }
                }
            } else if image.hasPrefix("https://") {
                // If it is a URL
                let url = URL(string: image)
                // Load the URL and retrieve the data
                let data = try? Data(contentsOf: url!)
                // Set the recipe image
                self.imageView.image = UIImage(data: data!)
                // Stop the indicator once it loads the image
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        } else {
            self.imageView.contentMode = .center
            let image = UIImage(named: "noImage")
            self.imageView.image = image
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       databaseController?.removeListener(listener: self)
    }
    
    // When the menu changes, reload the elements on the screen
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        self.view.setNeedsDisplay()
    }
    
    // Prepare the segues to the different screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuSegue" {
            let destination = segue.destination as? EditMenuTableViewController
            destination?.menu = menu
        } else if segue.identifier == "viewIngredientsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "ingredients"
            if ingredientsName.count > 0 {
                destination?.titleDataList = ingredientsName
                if ingredientsMeasurement.count > 0 {
                    destination?.detailDataList = ingredientsMeasurement
                }
            } else {
                destination?.titleDataList = ["No ingredients"]
            }
        } else if segue.identifier == "viewInstructionsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "instructions"
            if instructions.count > 0 {
                destination?.titleDataList = instructions
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "viewNotesSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "notes"
            if notes.count > 0 {
                destination?.titleDataList = notes
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "viewRecipeSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "recipe"
            if recipeList.count > 0 {
                destination?.titleDataList = recipeList
            } else {
                destination?.titleDataList = ["No recipes"]
            }
        }
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
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
}
