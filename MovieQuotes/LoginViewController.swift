//
//  LogInViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/26/21.
//

import UIKit
import Firebase
import FirebaseAuth
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    let showListSegueIdentifier = "ShowListSegue"
    let REGISTRY_TOKEN = "c8c403c0-b1fb-4573-89dc-54096e00c2ad"
    var rosefireName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signInButton.style = .wide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("Someone is already signed in")
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
        rosefireName = nil
    }
    
    @IBAction func pressedSignInNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating new user for email/password \(error)")
                return
            }
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedLoginExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error loggin in existing user for email/password \(error)")
                return
            }
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    @IBAction func pressedRosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate()?.uiDelegate = self
        Rosefire.sharedDelegate()?.signIn(registryToken: REGISTRY_TOKEN, withClosure: { (err, result) in
            if let err = err {
                print("Rosefire sign in error \(err)")
                return
            }
            self.rosefireName = result!.name!
            Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
                if let error = error {
                    print("Firebase sign in error \(error)")
                    return
                }
                self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showListSegueIdentifier {
            print("Checking for user \(Auth.auth().currentUser!.uid)")
            UserManager.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid, name: rosefireName ?? "", photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
        }
    }
}
