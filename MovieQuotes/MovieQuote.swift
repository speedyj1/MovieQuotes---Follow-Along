//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/12/21.
//

import Foundation
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var id: String?
    var author: String
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
        self.author = data["author"] as! String
    }
}
