//
//  Firebase+Guests.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchAllGuestsFromFirebase(completion: @escaping(_ success: Bool) -> Void) {
        fetchUsersFromFirebase(userType: .guest) { users, error in
            if let users = users {
                LocalData.shared.allGuests = users
                completion(true)
            }
        }
    }
    
    func deleteUser(user: User, completion: @escaping(_ success: Bool) -> Void) {
        firestore
            .collection(user.type.getFirebaseCollectionName())
            .document(user.id)
            .delete() { err in
            if let err = err {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
