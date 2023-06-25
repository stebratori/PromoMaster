//
//  Firebase+AllUsers.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchAllUsersFromFirebase(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        fetchAllUsersFromFirebase() { guests, promos, masters, error in
            guard
                let guests = guests,
                let promos = promos,
                let masters = masters
            else {
                completion(false, nil)
                return
            }
            LocalData.shared.allGuests = guests
            LocalData.shared.allMaster = masters
            LocalData.shared.allPromo = promos
            MyNotification.postNotification(name: .firebaseAllUsersFetched)
            completion(true, nil)
        }
    }
    
    func addUser(user: User, completion: @escaping(_ success: Bool) -> Void) {
        let collectionName: String = user.type.getFirebaseCollectionName()
        
        var data: [String: Any] = [
            "name": user.name,
            "type": user.type.rawValue
        ]
        if let email = user.email {
            data["email"] = email
        }
        if let phone = user.phone {
            data["phone"] = phone
        }
        if let pin = user.pin {
            data["pin"] = pin
        }
        firestore
            .collection(collectionName)
            .document(user.id)
            .setData(data) { error in
            if let error = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
