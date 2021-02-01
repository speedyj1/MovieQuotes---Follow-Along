//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/12/21.
//

import UIKit
import Firebase
import FirebaseAuth

class MovieQuoteDetailViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var authorBox: UIStackView!
    @IBOutlet weak var authorProfilePhotoImageView: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorBox.isHidden = true
//        updateView()
        movieQuoteListener = movieQuoteRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error getting movie quote \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("Might go back since someone else deleted document")
                return
            }
            self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
            if Auth.auth().currentUser!.uid == self.movieQuote?.author {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditDialog))
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            UserManager.shared.beginListening(uid: self.movieQuote!.author, changeListener: self.updateAuthorBox)
            self.updateView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit this movie quote", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote?.quote
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote?.movie
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            self.movieQuote?.quote = quoteTextField.text!
//            self.movieQuote?.movie = movieTextField.text!
//            self.updateView()
            self.movieQuoteRef.updateData([
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!])
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
    
    func updateAuthorBox() {
        print("Update author box for \(UserManager.shared.name)")
        authorBox.isHidden = !(UserManager.shared.name.count > 0 || UserManager.shared.photoUrl.count > 0)
        if UserManager.shared.name.count > 0 {
            authorName.text = UserManager.shared.name
        }
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: authorProfilePhotoImageView, from: UserManager.shared.photoUrl)
        }
    }
}
