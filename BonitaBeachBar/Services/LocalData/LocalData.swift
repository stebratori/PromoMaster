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
    
    func removeUser(user: User?) {
        guard let user = user else { return }
        if user.type == .promo {
            allPromo?.removeAll(where: { User in
                User.id == user.id
            })
        }
        else if user.type == .master {
            allMaster?.removeAll(where: { User in
                User.id == user.id
            })
        }
        else if user.type == .guest {
            allGuests?.removeAll(where: { User in
                User.id == user.id
            })
        }
    }
    
    func updateUser(user: User) {
        switch user.type {
        case .guest:
            if let allGuests = allGuests {
                for (index, guest) in allGuests.enumerated() {
                    if guest.id == user.id {
                        self.allGuests?.remove(at: index)
                        self.allGuests?.insert(user, at: index)
                    }
                }
            }
        case .promo:
            if let allPromo = allPromo {
                for (index, promo) in allPromo.enumerated() {
                    if promo.id == user.id {
                        self.allPromo?.remove(at: index)
                        self.allPromo?.insert(user, at: index)
                    }
                }
            }
        case .master:
            if let allMaster = allMaster {
                for (index, master) in allMaster.enumerated() {
                    if master.id == user.id {
                        self.allMaster?.remove(at: index)
                        self.allMaster?.insert(user, at: index)
                    }
                }
            }
        }
    }
    
    func addUser(user: User) {
        switch user.type {
        case .guest: LocalData.shared.allGuests?.insert(user, at: 0)
        case .promo: LocalData.shared.allPromo?.append(user)
        case .master: LocalData.shared.allMaster?.append(user)
        }
    }
    
    func getGuest(byId id: String) -> User? {
        guard let allGuests = LocalData.shared.allGuests else { return nil }
        for myGuest in allGuests where myGuest.id == id {
            return myGuest
        }
        return nil
    }
    
    func getPromo(byId id: String) -> User? {
        guard let allPromo = LocalData.shared.allPromo else { return nil }
        for myPromo in allPromo where myPromo.id == id {
            return myPromo
        }
        return nil
    }
    
    func getBill(byId id: String) -> Bill? {
        guard let allBills = LocalData.shared.allBills else { return nil }
        for myBill in allBills where myBill.id == id {
            return myBill
        }
        return nil
    }
    
    func getAvailableTables(forDate date: String?) -> [Table]? {
        guard let tables = tables, let date = date else { return nil }
        var availableTables: [Table] = []
        for table in tables {
            var booked: Bool = false
            if let reservations = reservations {
                for reservation in reservations {
                    if let reservationTable = reservation.table,
                       reservation.date == date,
                       reservationTable == table.number {
                        booked = true
                    }
                }
            }
            if !booked {
                availableTables.append(table)
            }
        }
        return availableTables
    }
    
    func getReservation(forTable table: String, date: String) -> Reservation? {
        guard let reservations = reservations else { return nil }
        for reservation in reservations {
            if let reservationTable = reservation.table,
               reservationTable == table,
               reservation.date == date {
                return reservation
            }
        }
        return nil
    }
    
    func getVisit(forTable table: String, date: String) -> Visit? {
        guard let visits = allVisits else { return nil }
        for visit in visits {
            if let visitTable = visit.table?.number,
               visitTable == table,
               visit.date == date {
                return visit
            }
        }
        return nil
    }
    
    func removeReservation(reservation: Reservation) {
        guard var reservations = reservations else { return }
        for (index, oldReservation) in reservations.enumerated() {
            if oldReservation.id == reservation.id {
                reservations.remove(at: index)
            }
        }
        LocalData.shared.reservations = reservations
    }
}
