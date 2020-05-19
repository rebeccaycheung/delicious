//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "embedRecipeCollectionSegue" {
        if let childVC = segue.destination as? RecipeCollectionViewController {
          //Some property on ChildVC that needs to be set
        }
      }
    }
}
