//
//  Firebase+Menu.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/16/23.
//

import Foundation
import FirebaseDatabase

extension FirebaseService {
    func fetchMenuFromFirebase(completion: @escaping (_ menu: [MenuItem]?, _ error: Error?) -> Void) {
        var menu: [MenuItem] = []
        self.firestore
            .collection("menu")
            .getDocuments { (query, error) in
                if let documents = query?.documents {
                    for document in documents {
                        if let menuItem = MenuItem(data: document.data()) {
                            menu.append(menuItem)
                        }
                    }
                    completion(menu, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, error)
                }
        }
    }
    
    func addNewMenuItem(menuItem: MenuItem, completion: @escaping(_ success: Bool) -> Void) {
        let collectionName: String = "menu"
        let data: [String: Any] = [
            "name": menuItem.name,
            "price": menuItem.price
        ]
        
        firestore
            .collection(collectionName)
            .document(UUID().uuidString.lowercased())
            .setData(data) { error in
            if error != nil {
                MyNotification.postNotification(name: .firebaseAddMenuItemError)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
