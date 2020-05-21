//
//  HomeViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var recipeCollection: UICollectionView!
    
    let reuseIdentifier = "recipeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        recipeCollection.delegate = self
        recipeCollection.dataSource = self
        
        //self.recipeCollection?.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! RecipeCollectionViewCell
        cell.recipeLabel.text = "recipe"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showRecipeSegue" {
        //
      } else if segue.identifier == "addRecipeSegue" {
        
        }
    }
}

