//
//  StartViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 1/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInSegue" {
            let _ = segue.destination as? SignInViewController
        } else if segue.identifier == "signUpSegue" {
            let _ = segue.destination as? SignUpViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 30
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
