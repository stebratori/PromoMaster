//
//  Firebase+RealtimeDatabase.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/30/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

extension FirebaseService {
    func setupListeners() {
        realtimeDatabase.child("billVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.billVersion = version
                print("[FireStore] billVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("guestsVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.guestsVersion = version
                print("[FireStore] guestsVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("masterVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.masterVersion = version
                print("[FireStore] masterVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("menuVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.menuVersion = version
                print("[FireStore] menuVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("promoVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.promoVersion = version
                print("[FireStore] promoVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("reservationsVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.reservationsVersion = version
                print("[FireStore] reservationsVersion updated to: \(version)")
            }
        })
        realtimeDatabase.child("visitVersion").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.visitVersion = version
            }
        })
        realtimeDatabase.child("promoMin").observe(.value, with: { snapshot in
            if let version = snapshot.value as? Int {
                LocalData.shared.realtimeDB.promoMin = version
            }
        })
    }
    
    func realtimeAddUser(user: User) {
        switch user.type {
        case .guest: realtimeGuestIncrease()
        case .promo: realtimePromoIncrease()
        case .master: realtimeMasterIncrease()
        }
    }
    
    func realtimeReservationChange() {
        realtimeDatabase.updateChildValues(["reservationsVersion": ServerValue.increment(1)])
    }
    
    func realtimeGuestIncrease() {
        realtimeDatabase.updateChildValues(["guestsVersion": ServerValue.increment(1)])
    }
    
    func realtimeMasterIncrease() {
        realtimeDatabase.updateChildValues(["masterVersion": ServerValue.increment(1)])
    }
    
    func realtimeMenuIncrease() {
        realtimeDatabase.updateChildValues(["menuVersion": ServerValue.increment(1)])
    }
    
    func realtimePromoIncrease() {
        realtimeDatabase.updateChildValues(["promoVersion": ServerValue.increment(1)])
    }
    
    func realtimeVisitIncrease() {
        realtimeDatabase.updateChildValues(["visitVersion": ServerValue.increment(1)])
    }

    func realtimeBillIncrease() {
        realtimeDatabase.updateChildValues(["billVersion": ServerValue.increment(1)])
    }
    
    func realtimePromoMinIncrease() {
        realtimeDatabase.updateChildValues(["promoMin": ServerValue.increment(1)])
    }
}
