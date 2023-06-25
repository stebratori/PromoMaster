//
//  Firebase+Bills.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchBillsFromFirebase(completion: @escaping (_ bills: [Bill]?, _ error: Error?) -> Void) {
        var bills: [Bill] = []
        self.firestore
            .collection("racuni")
            .getDocuments { (query, error) in
                if let firebaseBills = query?.documents {
                    for billFirebase in firebaseBills {
                        if let bill = Bill(id: billFirebase.documentID, data: billFirebase.data()) {
                            bills.append(bill)
                        }
                    }
                    completion(bills, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, error)
                }
            }
    }
    
    // ADD NEW BILL
    func addBill(bill: Bill, completion: @escaping(_ success: Bool) -> Void) {
        let collectionName: String = "racuni"
        var data: [String: Any] = [
            "date": bill.date,
            "total": bill.total
        ]
        var billItems: [[String: Any]] = []
        for item in bill.billItems {
            let billItem: [String: Any] = [
                "count": item.count,
                "name": item.name,
                "price": item.price
            ]
            billItems.append(billItem)
        }
        data["billItems"] = billItems
        
        firestore
            .collection(collectionName)
            .document(bill.id)
            .setData(data) { error in
            if error != nil {
                MyNotification.postNotification(name: .firebaseAddBillError)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
