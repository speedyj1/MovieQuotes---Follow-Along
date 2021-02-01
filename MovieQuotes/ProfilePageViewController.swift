//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfilePageViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserManager.shared.stopListening()
    }
    
    @objc func handleNameEdit() {
        if let name = displayNameTextField.text {
            print("Name \(name)")
            UserManager.shared.updateName(name: name)
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            profilePhotoImageView.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            profilePhotoImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
