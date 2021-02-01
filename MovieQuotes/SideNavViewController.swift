//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import UIKit

class SideNavViewController: UIViewController {
    
    @IBAction func pressedGoToProfile(_ sender: Any) {
        print("Make profile page")
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
        print("Delete")
    }
    @IBAction func pressedSignOut(_ sender: Any) {
        print("Sign out")
    }
    
    var tableViewController: MovieQuotesTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
}
