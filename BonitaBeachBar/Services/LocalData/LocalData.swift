//
//  LocalData.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation

class LocalData {
    static let shared: LocalData = LocalData()
    var allGuests: [User]?
    var allPromo: [User]?
    var allMaster: [User]?
    var allBills: [Bill]?
    var allVisits: [Visit]?
    var menu: [MenuItem]?
    var reservations: [Reservation]?
    var tables: [Table]?
    var promoMin: Double = 20000
    var realtimeDB = RealtimeDB()
    
    struct RealtimeDB {
        var guestsVersion = 0 {
            didSet {
                FirebaseService().fetchAllGuestsFromFirebase { success in
                    MyNotification.postNotification(name: .realtimeChangeReloadData)
                }
            }
        }
        
        var masterVersion = 0 {
            didSet {
                FirebaseService().fetchAllMastersFromFirebase { success in
                    MyNotification.postNotification(name: .realtimeChangeReloadData)
                }
            }
        }

        var promoVersion = 0 {
            didSet {
                FirebaseService().fetchAllPromosFromFirebase { success in
                    MyNotification.postNotification(name: .realtimeChangeReloadData)
                }
            }
        }
        
        var reservationsVersion = 0 {
            didSet {
                FirebaseService().fetchReservationsFromFirebase(completion: { reservations, error in
                    if let error = error {
                        print("[LocalData.RealtimeDB.reservationsVersion error \(error)]")
                    } else {
                        LocalData.shared.reservations = reservations
                        MyNotification.postNotification(name: .realtimeChangeReservation)
                    }
                })
            }
        }
        var visitVersion = 0 {
            didSet {
                FirebaseService().fetchAllBillsAndVisits { success, error in
                    MyNotification.postNotification(name: .realtimeChangeVisit)
                }
            }
        }
        
        // No Need for standalone listeners
        var menuVersion = 0
        var billVersion = 0
    }
}
