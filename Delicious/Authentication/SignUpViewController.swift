//
//  SignUpViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 1/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

// Sign up screen
class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add the authentication listener
        handle = Auth.auth().addStateDidChangeListener( { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
        })
        
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Button style
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the authentication listener
        Auth.auth().removeStateDidChangeListener(handle!)
        
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // When user presses the sign up button, make sure an email and password is provided. Create a new user
    @IBAction func login(_ sender: Any) {
        guard let password = passwordTextField.text else {
            displayErrorMessage("Please enter a password")
            return
        }
        guard let email = emailTextField.text else {
            displayErrorMessage("Please enter an email address")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.displayErrorMessage(error.localizedDescription)
            }
        }
    }
    
    // If the user presses the login button, go to the login screen
    @IBAction func moveToLogin(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    // Display error message method
    func displayErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // When user presses return on the soft keyboard, the keyboard will disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
