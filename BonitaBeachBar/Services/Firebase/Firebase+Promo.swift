//
//  Firebase+Promo.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchAllPromosFromFirebase(completion: @escaping(_ success: Bool) -> Void) {
        fetchUsersFromFirebase(userType: .promo) { promo, error in
            if let promo = promo {
                LocalData.shared.allPromo = promo
                completion(true)
            }
        }
    }
}
