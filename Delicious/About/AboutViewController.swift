//
//  AboutViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 31/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
