//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import UIKit

class ProfilePageViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    @objc func handleNameEdit() {
        if let name = displayNameTextField.text {
            print("Name \(name)")
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("Upload photo")
    }
}
