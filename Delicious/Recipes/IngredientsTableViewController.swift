//
//  IngredientsTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 24/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    var ingredientsList: [String] = []
    var measurementsList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsTableViewCell
        for ingredient in ingredientsList {
            cell.ingredientLabel.text = ingredient
        }
        for measurement in measurementsList {
            cell.measurementLabel.text = measurement
        }
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
