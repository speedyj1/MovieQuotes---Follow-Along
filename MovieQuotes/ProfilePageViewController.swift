//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

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
    
    func uploadImage(_ image: UIImage) {
        if let imageData = ImageUtils.resize(image: image) {
            let storageRef = Storage.storage().reference().child(kCollectionUsers).child(Auth.auth().currentUser!.uid)
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image \(error)")
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Errror getting the download url \(error)")
                    }
                    if let downloadURL = url {
                        print("Download url \(downloadURL)")
                        UserManager.shared.updatePhotoUrl(photoUrl: downloadURL.absoluteString)
                    }
                }
            }
        } else {
            print("Error getting image data")
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
//            profilePhotoImageView.image = image
            uploadImage(image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
//            profilePhotoImageView.image = image
            uploadImage(image)
        }
        picker.dismiss(animated: true)
    }
}
