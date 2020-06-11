//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, ShowRecipeDelegate, ShowMenuDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var selectedView = "Recipe"
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    // Initalise the search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Use the search bar delegate
        searchController.searchBar.delegate = self
        // Do not obscure the view controller
        searchController.obscuresBackgroundDuringPresentation = false
        // Set the placeholder in the search bar
        searchController.searchBar.placeholder = "Search for recipe"
        // Set the navigation to the search controller
        navigationItem.searchController = searchController
        
        // Make sure search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
    }
    
    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return;
        }
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
//        var collection: RecipeCollectionViewController = self.children[0] as! RecipeCollectionViewController
//        collection.viewWillAppear(true)
        
        // Cancels all outstanding tasks and invalidates the session
        URLSession.shared.invalidateAndCancel()
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        //Reference - https://stackoverflow.com/questions/30484268/refresh-container-view-holding-uitableview-swift/30485630
        var collection: RecipeCollectionViewController = self.children[0] as! RecipeCollectionViewController
        switch segment.selectedSegmentIndex {
        case 0:
            searchController.searchBar.placeholder = "Search for recipe"
            selectedView = "Recipe"
            collection.selectedControl = selectedView
            collection.viewWillAppear(true)
            break
        case 1:
            searchController.searchBar.placeholder = "Search for menu"
            selectedView = "Menu"
            collection.selectedControl = selectedView
            collection.viewWillAppear(true)
            break
        default:
            break
        }
    }
    
    @IBAction func addItemButton(_ sender: Any) {
        if selectedView == "Recipe" {
            performSegue(withIdentifier: "addRecipeSegue", sender: self)
        } else if selectedView == "Menu" {
            performSegue(withIdentifier: "addMenuSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRecipeCollectionSegue" {
            let destination = segue.destination as? RecipeCollectionViewController
            destination?.selectedControl = selectedView
            destination?.showRecipeDelegate = self
            destination?.showMenuDelegate = self
        } else if segue.identifier == "addRecipeSegue", selectedView == "Recipe" {
            let destination = segue.destination as? EditRecipeTableViewController
        } else if segue.identifier == "addMenuSegue", selectedView == "Menu" {
            let destination = segue.destination as? AddNewMenuViewController
        }
    }
    
    func showRecipe(recipe: Recipe) {
        let chosenRecipe = recipe
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        destination?.recipe = chosenRecipe
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    func showMenu(menu: Menu) {
        let chosenMenu = menu
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        destination?.menu = chosenMenu
        self.navigationController?.pushViewController(destination!, animated: true)
    }
}

