//
//  UserManager.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 1/31/21.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "Name"
let kKeyPhotoUrl = "photoUrl"

class UserManager {
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManager()
    
    private init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    //Create
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("Already User object for this auth")
                    return
                } else {
                    print("Creating user")
                    userRef.setData([kKeyName: name ?? "", kKeyPhotoUrl: photoUrl ?? ""])
                }
            }
        }
    }
    
    
    //Read
    func beginListening(uid: String, changeListener: (() -> Void)? ) {
        stopListening()
        let userRef = _collectionRef.document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    //Update
    func updateName(name: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([kKeyName: name])
        
    }
    
    func updatePhotoUrl(photoUrl: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([kKeyPhotoUrl: photoUrl])
    }
    
    //Delete - No delete
    
    
    //Getters
    var name: String {
        if let value = _document?.get(kKeyName) {
            return value as! String
        }
        return ""
    }
    
    var photoUrl: String {
        if let value = _document?.get(kKeyPhotoUrl) {
            return value as! String
        }
        return ""
    }
    
}
