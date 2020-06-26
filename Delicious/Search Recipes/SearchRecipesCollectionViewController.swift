//
//  SearchRecipesCollectionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 14/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class SearchRecipesCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
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
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
        // Remove any existing searched cocktails
        allSearchRecipes.removeAll()
        // Reload the table
        collectionView.reloadData()
        
        // Cancels all outstanding tasks and invalidates the session
        URLSession.shared.invalidateAndCancel()
        
        loadRecipes(recipe: searchText)
    }
    
    // MARK: - Call API
    func loadRecipes(recipe: String) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(recipe)")

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
                if let searchRecipeData = try? decoder.decode(SearchRecipeData.self, from: data!) {
                    if let recipes = searchRecipeData.recipes {
                        self.allSearchRecipes.append(contentsOf: recipes)
                        DispatchQueue.main.sync {
                            self.collectionView.reloadData()
                        }
                    }
                }
            } catch let err {
                print(err)
            }
            
            // Wait for the response from the API
            DispatchQueue.main.sync {
                self.searched = true
                print(self.allSearchRecipes.count)
                print(self.searched)
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
        if !searched {
            cell.recipeLabel.text = "Search for a recipe"
        }
        
        if allSearchRecipes.count > 0 {
            let recipe = allSearchRecipes[indexPath.row]
            cell.recipeLabel.text = recipe.name
        }
        
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
            let recipe = Recipe()
            let selectedRecipe = allSearchRecipes[indexPath.row]
            recipe.name = selectedRecipe.name
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
            let instructionsArray = selectedRecipe.instructions.components(separatedBy: ".")
            for instruction in instructionsArray {
                if instruction != "" {
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
            
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditRecipeTableViewController") as? EditRecipeTableViewController
            destination?.recipe = recipe
            self.navigationController?.pushViewController(destination!, animated: true)
        }
    }
}
