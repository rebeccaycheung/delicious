//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, ShowRecipeDelegate, ShowMenuDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var selectedView = "Recipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        //Reference - https://stackoverflow.com/questions/30484268/refresh-container-view-holding-uitableview-swift/30485630
        var collection: RecipeCollectionViewController = self.children[0] as! RecipeCollectionViewController
        switch segment.selectedSegmentIndex {
        case 0:
            selectedView = "Recipe"
            collection.selectedControl = selectedView
            collection.viewWillAppear(true)
            break
        case 1:
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

