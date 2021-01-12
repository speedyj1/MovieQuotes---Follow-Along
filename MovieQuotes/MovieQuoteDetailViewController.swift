//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/12/21.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    var movieQuote: MovieQuote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditDialog))
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
            self.movieQuote?.quote = quoteTextField.text!
            self.movieQuote?.movie = movieTextField.text!
            self.updateView()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
}
