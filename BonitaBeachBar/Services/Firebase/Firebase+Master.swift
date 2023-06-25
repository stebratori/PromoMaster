//
//  Firebase+Service.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchAllMastersFromFirebase(completion: @escaping(_ success: Bool) -> Void) {
        fetchUsersFromFirebase(userType: .master) { masters, error in
            if let masters = masters {
                LocalData.shared.allMaster = masters
                completion(true)
            }
        }
    }
}
