//
//  AboutViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 31/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Log out error: \(error.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
