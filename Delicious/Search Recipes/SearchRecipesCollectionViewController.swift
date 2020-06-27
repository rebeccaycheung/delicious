//
//  SearchRecipesCollectionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 14/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Search Recipe Collection screen
class SearchRecipesCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    // Constants for the collection
    private let reuseIdentifier = "searchRecipeCell"
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let itemsPerRow: CGFloat = 1
    
    var allSearchRecipes: [RecipeData] = []
    
    weak var editSearchRecipeDelegate: EditSearchRecipeDelegate?
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    var searched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initalise the search controller
        let searchController = UISearchController(searchResultsController: nil)
        // Use the search bar delegate
        searchController.searchBar.delegate = self
        // Do not obscure the view controller
        searchController.obscuresBackgroundDuringPresentation = false
        // Set the placeholder in the search bar
        searchController.searchBar.placeholder = "Search for recipes"
        // Set the navigation to the search controller
        navigationItem.searchController = searchController
        
        // Make sure search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.collectionView.center
        self.view.addSubview(indicator)
    }
    
    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return;
        }
        
        // Start animating the indicator
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
        // Remove any existing searched cocktails
        allSearchRecipes.removeAll()
        // Reload the table
        collectionView.reloadData()
        
        // Cancels all outstanding tasks and invalidates the session
        URLSession.shared.invalidateAndCancel()
        
        // Call the API
        loadRecipes(recipe: searchText)
    }
    
    // MARK: - Call API
    func loadRecipes(recipe: String) {
        // API
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(recipe)")
        
        // Start the API call
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Attempt to decode the data returned from the API call
                if let searchRecipeData = try? decoder.decode(SearchRecipeData.self, from: data!) {
                    if let recipes = searchRecipeData.recipes {
                        // Append the decoded recipes to the searched recipe list
                        self.allSearchRecipes.append(contentsOf: recipes)
                        DispatchQueue.main.sync {
                            // Reload the collection
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
            
            // Wait for the response from the API
            DispatchQueue.main.sync {
                // Check if the user has searched an item
                self.searched = true
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allSearchRecipes.count > 0 {
            return allSearchRecipes.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchRecipesCollectionViewCell
        cell.layer.cornerRadius = 12
        
        // If the user has not searched for an item yet
        if !searched {
            cell.recipeLabel.text = "Search for a recipe"
        }
        
        // If the user has searched for an item and there are results that have been returned
        if allSearchRecipes.count > 0 {
            let recipe = allSearchRecipes[indexPath.row]
            cell.recipeLabel.text = recipe.name
        }
        
        // If the user has searched for an item and no results are found
        if searched && allSearchRecipes.count == 0 {
            cell.recipeLabel.text = "No recipes found"
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if allSearchRecipes.count > 0 {
            // Create a Recipe for the item that was selected in the searched collection
            let recipe = Recipe()
            
            let selectedRecipe = allSearchRecipes[indexPath.row]
            
            recipe.name = selectedRecipe.name
            
            recipe.imageReference = selectedRecipe.image
            
            if let source = selectedRecipe.source {
                recipe.source = source
            }
            
            if let area = selectedRecipe.area, let category = selectedRecipe.category {
                recipe.tagsList = [String]()
                recipe.tagsList?.append(area)
                recipe.tagsList?.append(category)
            }
            
            recipe.instructionsList = [String]()
            
            recipe.ingredientNamesList = [String]()
            recipe.ingredientMeasurementsList = [String]()
            
            // Separate each sentence into an array - assuming that each sentence is an instruction
            let instructionsArray = selectedRecipe.instructions.components(separatedBy: ".")
            for instruction in instructionsArray {
                if instruction != "" {
                    // Process the instructions that are in the data returned of the recipe
                    // Remove the new lines and carriage returns from the string
                    var processInstruction = instruction.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range:nil)
                    processInstruction = processInstruction.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
                    recipe.instructionsList!.append(processInstruction)
                }
            }
            
            for ingredient in selectedRecipe.ingredients {
                if ingredient != "" {
                    recipe.ingredientNamesList?.append(ingredient)
                }
            }
            for measurement in selectedRecipe.measurements {
                if measurement != "" {
                    recipe.ingredientMeasurementsList?.append(measurement)
                }
            }
            
            // Go to the Edit Recipe screen, passing the newly created Recipe to it
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditRecipeTableViewController") as? EditRecipeTableViewController
            destination?.recipe = recipe
            self.navigationController?.pushViewController(destination!, animated: true)
        }
    }
}
