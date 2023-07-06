//
//  Firebase+Visits.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func fetchAllData(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        // FETCH ALL USERS FIRST
        self.fetchAllUsersFromFirebase { success, error in
            if success {
                
                // FETCH ALL BILLS
                self.fetchBillsFromFirebase { bills, error in
                    if let bills = bills {
                        LocalData.shared.allBills = bills
                        
                        // FETCH ALL VISITS
                        self.fetchVisitsFromFirebase { visits, error in
                            if let visits = visits {
                                LocalData.shared.allVisits = visits
                                
                                // FETCH MENU
                                self.fetchMenuFromFirebase { menu, error in
                                    LocalData.shared.menu = menu
                                    
                                    // FETCH RESERVATIONS
                                    self.fetchReservationsFromFirebase { reservations, error in
                                        LocalData.shared.reservations = reservations
                                        
                                        self.fetchAllTables { tables, error in
                                            LocalData.shared.tables = tables
                                            
                                            // SUCCESS
                                            MyNotification.postNotification(name: .firebaseAllBillsAndVisitsFetched)
                                            completion(true, nil)
                                        }
                                    }
                                }
                            } else {
                                MyNotification.postNotification(name: .firebaseFetchingError)
                                completion(false, error)
                            }
                        }
                    } else {
                        MyNotification.postNotification(name: .firebaseFetchingError)
                        completion(false, error)
                    }
                }
            } else {
                MyNotification.postNotification(name: .firebaseFetchingError)
                completion(false, error)
            }
        }
    }
    
    
    // FETCH ALL BILLS AND VISITS
    func fetchAllBillsAndVisits(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.fetchBillsFromFirebase { bills, error in
            if let bills = bills {
                LocalData.shared.allBills = bills
                
                // FETCH ALL VISITS
                self.fetchVisitsFromFirebase { visits, error in
                    if let visits = visits {
                        LocalData.shared.allVisits = visits
                        
                        // SUCCESS
                        MyNotification.postNotification(name: .firebaseAllBillsAndVisitsFetched)
                        completion(true, nil)
                        
                    } else {
                        MyNotification.postNotification(name: .firebaseFetchingError)
                        completion(false, error)
                    }
                }
            } else {
                MyNotification.postNotification(name: .firebaseFetchingError)
                completion(false, error)
            }
        }
    }
    
    // ADD NEW VISIT
    func addVisit(visit: Visit, completion: @escaping(_ success: Bool) -> Void) {
        let collectionName: String = "posete"
        guard
            let guestID = visit.guest?.id,
            let billID = visit.bill?.id
        else { return }
        var data: [String: Any] = [
            "billID": billID,
            "date": visit.date,
            "guestID": guestID
        ]
        if let promoID = visit.promo?.id {
            data["promoID"] = promoID
        }
        if let table = visit.table?.number {
            data["table"] = table
        }
        if let comment = visit.comment {
            data["comment"] = comment
        }
        firestore
            .collection(collectionName)
            .document(visit.id)
            .setData(data) { error in
            if error != nil {
                MyNotification.postNotification(name: .firebaseAddVisitError)
                completion(false)
            } else {
                guard let bill = visit.bill else {
                    completion(false)
                    return
                }
                self.addBill(bill: bill) { success in
                    completion(true)
                }
            }
        }
    }
    
    func fetchVisitsFromFirebase(completion: @escaping (_ visits: [Visit]?, _ error: Error?) -> Void) {
        var visits: [Visit] = []
        self.firestore
            .collection("posete")
            .getDocuments { (query, error) in
                if let firebaseBills = query?.documents {
                    for documentFirebase in firebaseBills {
                        if let visit = Visit(id: documentFirebase.documentID, data: documentFirebase.data()) {
                            visits.append(visit)
                        }
                    }
                    completion(visits, nil)
                } else if let error = error {
                    MyNotification.postNotification(name: .firebaseFetchingError)
                    completion(nil, error)
                }
            }
    }
    
    
}
