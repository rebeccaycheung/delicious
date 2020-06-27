//
//  SignInViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 1/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseAuth

// Sign in screen
class SignInViewController: UIViewController, UITextFieldDelegate {

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
                // Check if user has logged in previously
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
    
    // When user presses the login button, make sure an email and password is provided. Sign in the user
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
    
    // If the user presses the sign up button, go to the sign in screen
    @IBAction func signUp(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
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
