//
//  Firebase+Constants.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension FirebaseService {
    func fetchPromoMin(completion: @escaping (_ promoMin: Double?, _ error: Error?) -> Void) {
        self.firestore
            .collection("promo_min")
            .getDocuments { (query, error) in
                if let documents = query?.documents {
                    for document in documents {
                        let data = document.data()
                        if let promoMin = data["value"] as? Double {
                            completion(promoMin, nil)
                        } else {
                            completion(nil, error)
                        }
                    }
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseError)
                    completion(nil, error)
                }
        }
    }
    
    func setPromoMin(promoMin: Double, completion: @escaping(_ success: Bool) -> Void) {
        var data: [String: Any] = [ "value": promoMin ]
        firestore
            .collection("promo_min")
            .document("promo_min")
            .setData(data) { error in
            if error != nil {
                MyNotification.postNotification(name: .firebaseError)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
