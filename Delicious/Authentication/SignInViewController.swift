//
//  SignInViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 1/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener( { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        })
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let password = passwordTextField.text else {
            displayErrorMessage("Please enter a password")
            return
        }
        guard let email = emailTextField.text else {
            displayErrorMessage("Please enter an email address")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.displayErrorMessage(error.localizedDescription)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    func displayErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
