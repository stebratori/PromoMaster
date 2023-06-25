//
//  Firebase+Tables.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/22/23.
//

import Foundation

extension FirebaseService {
    func fetchAllTables(completion: @escaping (_ tables: [Table]?, _ error: Error?) -> Void) {
        var tables: [Table] = []
        self.firestore
            .collection("tables")
            .getDocuments { (query, error) in
                if let documents = query?.documents {
                    for document in documents {
                        if let table = Table(data: document.data()) {
                            tables.append(table)
                        }
                    }
                    completion(tables, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseTablesFetchingError)
                    completion(nil, error)
                }
        }
    }
}
