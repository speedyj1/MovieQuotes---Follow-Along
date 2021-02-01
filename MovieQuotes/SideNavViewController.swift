//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SideNavViewController: UIViewController {
    
    @IBAction func pressedGoToProfile(_ sender: Any) {
        dismiss(animated: false)
        tableViewController.performSegue(withIdentifier: kProfilePageSegue, sender: tableViewController)
    }
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        tableViewController.setEditing(!tableViewController.isEditing, animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedSignOut(_ sender: Any) {
        dismiss(animated: false)
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    var tableViewController: MovieQuotesTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
}
