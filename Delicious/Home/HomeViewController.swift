//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ShowRecipeDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var selectedView = "Recipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            selectedView = "Recipe"
            break
        case 1:
            selectedView = "Menu"
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRecipeCollectionSegue" {
            let destination = segue.destination as? RecipeCollectionViewController
            destination?.selectedControl = selectedView
            destination?.showRecipeDelegate = self
        }
    }
    
    func showRecipe(recipe: Recipe) {
        let chosenRecipe = recipe
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        destination?.recipe = chosenRecipe
        self.navigationController?.pushViewController(destination!, animated: true)
    }
}

