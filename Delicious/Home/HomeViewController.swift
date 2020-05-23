//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ShowRecipeDelegate {
    
    var chosenRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRecipeCollectionSegue" {
            let destination = segue.destination as? RecipeCollectionViewController
            destination?.showRecipeDelegate = self
        }
        
        if segue.identifier == "showRecipeSegue" {
            let destination = segue.destination as? RecipeViewController
            destination?.recipe = chosenRecipe
        }
    }
    
    func showRecipe(recipe: Recipe) {
        chosenRecipe = recipe
    }
}

