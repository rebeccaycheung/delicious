//
//  EditIngredientViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditIngredientViewController: UIViewController {

    @IBOutlet weak var ingredient: UITextField!
    @IBOutlet weak var measurement: UITextField!
    
    var selectedIngredient: String?
    var selectedMeasurement: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredient.text = selectedIngredient ?? ""
        measurement.text = selectedMeasurement ?? ""
    }
}
