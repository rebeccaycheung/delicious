//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

// Collection screen
class HomeViewController: UIViewController, ShowRecipeDelegate, ShowMenuDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var searchRecipeButton: UIButton!
    
    // Segment control currently on Recipes
    var selectedView = "Recipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make all navigation titles large
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Button style
        searchRecipeButton.layer.cornerRadius = 23
        searchRecipeButton.layer.borderWidth = 1
        searchRecipeButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        // Make sure the user has logged in
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
    }
    
    // Check which segment control has been pressed and load the correct collection view. Hide the Search Recipe button if the Menu segment has been pressed
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        //Reference - https://stackoverflow.com/questions/30484268/refresh-container-view-holding-uitableview-swift/30485630
        var collection: CollectionViewController = self.children[0] as! CollectionViewController
        switch segment.selectedSegmentIndex {
        case 0:
            selectedView = "Recipe"
            searchRecipeButton.isHidden = false
            collection.selectedControl = selectedView
            collection.viewWillAppear(true)
            break
        case 1:
            selectedView = "Menu"
            searchRecipeButton.isHidden = true
            collection.selectedControl = selectedView
            collection.viewWillAppear(true)
            break
        default:
            break
        }
    }
    
    // Check which segment has been pressed. Add a new item based on which segment the user is on
    @IBAction func addItemButton(_ sender: Any) {
        if selectedView == "Recipe" {
            performSegue(withIdentifier: "addRecipeSegue", sender: self)
        } else if selectedView == "Menu" {
            performSegue(withIdentifier: "addMenuSegue", sender: self)
        }
    }
    
    // Prepare segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Embed the collection view in the container view
        if segue.identifier == "embedRecipeCollectionSegue" {
            let destination = segue.destination as? CollectionViewController
            destination?.selectedControl = selectedView
            destination?.showRecipeDelegate = self
            destination?.showMenuDelegate = self
        } else if segue.identifier == "addRecipeSegue", selectedView == "Recipe" {
            _ = segue.destination as? EditRecipeTableViewController
        } else if segue.identifier == "addMenuSegue", selectedView == "Menu" {
            _ = segue.destination as? AddNewMenuViewController
        }
    }
    
    // Delegate to pass the recipe that the user has pressed in the collection to view the recipe
    func showRecipe(recipe: Recipe) {
        let chosenRecipe = recipe
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        destination?.recipe = chosenRecipe
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    // Delegate to pass the menu that the user has pressed in the collection to view the menu
    func showMenu(menu: Menu) {
        let chosenMenu = menu
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        destination?.menu = chosenMenu
        self.navigationController?.pushViewController(destination!, animated: true)
    }
}

