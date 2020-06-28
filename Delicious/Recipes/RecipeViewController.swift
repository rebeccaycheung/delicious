//
//  RecipeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseStorage
import TagListView

// Recipe screen
class RecipeViewController: UIViewController, DatabaseListener {

    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var sourceButton: UIButton!
    
    var recipe: Recipe?
    
    // Storage reference
    var storageReference = Storage.storage()
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    // Set up database controller and listener
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    var ingredients = [String]()
    var ingredientMeasurements = [String]()
    
    // TagListView is an imported library that shows the tags of a recipe in a tag formation
    @IBOutlet weak var tagsListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.recipeImage.center
        self.view.addSubview(indicator)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Set the tag list to font size 17
        tagsListView.textFont = UIFont.systemFont(ofSize: 17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        // When the screen appears, set the navigation title to the recipe name
        navigationItem.title = recipe?.name
        
        // When the screen appears, set the labels
        cookTimeLabel.text = "Cook time: \(recipe!.cookTime)"
        servingSizeLabel.text = "Serving size: \(recipe!.servingSize)"
        sourceButton.setTitle(recipe?.source, for: .normal)
        
        // Remove all the existing tags
        tagsListView.removeAllTags()
        // Add the tags list of the recipe to the view
        if let tags = recipe?.tagsList {
            tagsListView.addTags(tags)
        }
        
        // Add the ingredients if it exists to the ingredients list
        if let ingredientNamesList = recipe!.ingredientNamesList {
            if ingredientNamesList.count > 0 {
                self.ingredients = ingredientNamesList
                
                if let ingredientMeasurementsList = recipe!.ingredientMeasurementsList {
                    if ingredientMeasurementsList.count > 0 {
                        ingredientMeasurements = ingredientMeasurementsList
                    }
                }
            } else {
                self.ingredients = ["No ingredients"]
            }
        }
        
        let blankImage = UIImage()
        self.recipeImage.image = blankImage
        // Load the image of the recipe
        if let image = recipe?.imageReference {
            // Start the indicator
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.clear
            
            // Set the image layout
            self.recipeImage.contentMode = .scaleAspectFill
            self.recipeImage.layer.cornerRadius = 12
            self.recipeImage.clipsToBounds = true
            
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
                            self.recipeImage.image = image
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
                self.recipeImage.image = UIImage(data: data!)
                // Stop the indicator once it loads the image
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        } else {
            self.recipeImage.contentMode = .center
            let image = UIImage(named: "noImage")
            self.recipeImage.image = image
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       databaseController?.removeListener(listener: self)
    }
    
    // When the recipe changes, reload the elements on the screen
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        self.view.setNeedsDisplay()
    }
    
    // Prepare the segues to the different screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingredientsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.titleDataList = ingredients
            destination?.detailDataList = ingredientMeasurements
            destination?.type = "ingredients"
        } else if segue.identifier == "instructionsSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "instructions"
            if let instructionsList = recipe!.instructionsList {
                if instructionsList.count > 0 {
                    destination?.titleDataList = instructionsList
                } else {
                    destination?.titleDataList = ["No instructions"]
                }
            } else {
                destination?.titleDataList = ["No instructions"]
            }
        } else if segue.identifier == "notesSegue" {
            let destination = segue.destination as? ItemTableViewController
            destination?.type = "notes"
            if let notesList = recipe!.notesList {
                if notesList.count > 0 {
                    destination?.titleDataList = notesList
                } else {
                    destination?.titleDataList = ["No notes"]
                }
            } else {
                destination?.titleDataList = ["No notes"]
            }
        } else if segue.identifier == "editRecipeSegue" {
            let destination = segue.destination as? EditRecipeTableViewController
            destination?.recipe = recipe
        }
    }
    
    // When user taps on source
    @IBAction func sourceButton(_ sender: Any) {
        if let source = sourceButton.titleLabel?.text {
            // Make sure the source is an actual link
            if source.hasPrefix("http") {
                showActionSheet(item: source)
            } else {
                displayMessage("Source is not in the proper url format. Make sure it starts with 'http'", "Can't open in browser")
            }
        }
    }
    
    // Show action sheet function
    func showActionSheet(item: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let leaveApplicationAction = UIAlertAction(title: "Open recipe source in browser", style: .default) { action in
            // When the source has been pressed, open web browser with the url
            UIApplication.shared.open(URL(string: "\(item)")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(leaveApplicationAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Display alert message function
    func displayMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
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
