//
//  Firebase+Reservations.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/16/23.
//

import Foundation

extension FirebaseService {
    func fetchReservationsFromFirebase(completion: @escaping (_ reservations: [Reservation]?, _ error: Error?) -> Void) {
        var reservations: [Reservation] = []
        self.firestore
            .collection("reservations")
            .getDocuments { (query, error) in
                if let documents = query?.documents {
                    for document in documents {
                        if let reservation = Reservation(id: document.documentID, data: document.data()) {
                            reservations.append(reservation)
                        }
                    }
                    completion(reservations, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, error)
                }
            }
    }
    
    func addReservation(reservation: Reservation, completion: @escaping(_ success: Bool) -> Void) {
        let collectionName: String = "reservations"
        var data: [String: Any] = [
            "date": reservation.date,
            "guestID": reservation.guest.id
        ]
        if let promoID = reservation.promo?.id {
            data["promoID"] = promoID
        }
        if let table = reservation.table {
            data["table"] = table
        }
        if let comment = reservation.comment {
            data["comment"] = comment
        }
        
        firestore
            .collection(collectionName)
            .document(reservation.id)
            .setData(data) { error in
            if error != nil {
                MyNotification.postNotification(name: .firebaseAddReservationError)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
