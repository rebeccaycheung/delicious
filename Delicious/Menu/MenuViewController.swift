//
//  MenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var servingSize: UILabel!
    @IBOutlet var liveModeButton: UIButton!
    
    var menu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = menu?.name
        
        liveModeButton.layer.cornerRadius = 23
        liveModeButton.layer.borderWidth = 1
        liveModeButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        if let cookTime = menu?.cookTime {
            self.cookTime.text = String(cookTime)
        } else {
            self.cookTime.text = "0"
        }
        
        if let servingSize = menu?.servingSize {
            self.servingSize.text = String(servingSize)
        } else {
            self.servingSize.text = "0"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuSegue" {
            let destination = segue.destination as? EditMenuTableViewController
            destination?.menu = menu
        }
    }
    
    @IBAction func liveModeButton(_ sender: Any) {
    }
    
}
