//
//  MenuViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var menu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuSegue" {
            let destination = segue.destination as? EditMenuTableViewController
            destination?.menu = menu
        }
    }
}
