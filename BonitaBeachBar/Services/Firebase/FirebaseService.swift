//
//  FirebaseService.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/27/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
//https://bonitabeachbar-29148-default-rtdb.europe-west1.firebasedatabase.app/

class FirebaseService {
    let firestore: Firestore = Firestore.firestore()
    let realtimeDatabase: DatabaseReference = Database.database(url: realtimeDatabaseUrl).reference()
    private static let realtimeDatabaseUrl = "https://bonitabeachbar-29148-default-rtdb.europe-west1.firebasedatabase.app/"

    func firebaseAuthenticateAndFetchAllData(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signInAnonymously { (authDataResult, error) in
            self.fetchAllData { success, error in
                completion(success, error)
            }
        }
    }

    internal func fetchUsersFromFirebase(userType: UserType, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        var users: [User] = []
        self.firestore
            .collection(userType.getFirebaseCollectionName())
            .getDocuments { (query, error) in
                if let firebaseUsers = query?.documents {
                    for document in firebaseUsers {
                        if let user = User(id: document.documentID, data: document.data()) {
                            users.append(user)
                        }
                    }
                    completion(users, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, error)
                }
            }
    }
    
    internal func fetchAllUsersFromFirebase(completion: @escaping (_ guests: [User]?,
                                                                   _ promos: [User]?,
                                                                   _ masters: [User]?,
                                                                   _ error: Error?) -> Void) {
        var guests: [User] = []
        var promos: [User] = []
        var masters: [User] = []
        
        // FETCH GUESTS
        self.firestore
            .collection(UserType.guest.getFirebaseCollectionName())
            .getDocuments { (query, error) in
                if let firebaseUsers = query?.documents {
                    for document in firebaseUsers {
                        if let user = User(id: document.documentID, data: document.data()) {
                            guests.append(user)
                        }
                    }
                    // FETCH PROMO
                    self.firestore
                        .collection(UserType.promo.getFirebaseCollectionName())
                        .getDocuments { (query, error) in
                            if let firebaseUsers = query?.documents {
                                for document in firebaseUsers {
                                    if let user = User(id: document.documentID, data: document.data()) {
                                        promos.append(user)
                                    }
                                }
                                // FETCH Master
                                self.firestore
                                    .collection(UserType.master.getFirebaseCollectionName())
                                    .getDocuments { (query, error) in
                                        if let firebaseUsers = query?.documents {
                                            for document in firebaseUsers {
                                                if let user = User(id: document.documentID, data: document.data()) {
                                                    masters.append(user)
                                                }
                                            }
                                            
                                            // ALL USERS FETCHED HERE
                                            completion(guests, promos, masters, nil)
                                            MyNotification.postNotification(name: .firebaseAllUsersFetched)
                                            
                                        } else if let error = error {
                                            MyNotification.postNotification(name: .firebaseFetchingError)
                                            completion(nil, nil, nil, error)
                                        }
                                    }
                            } else if let error = error {
                                MyNotification.postNotification(name: .firebaseFetchingError)
                                completion(nil, nil, nil, error)
                            }
                        }
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, nil, nil, error)
                }
            }
    }
}
