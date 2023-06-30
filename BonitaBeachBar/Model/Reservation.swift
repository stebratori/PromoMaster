//
//  Reservation.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/17/23.
//

import Foundation

struct Reservation {
    let id: String
    var date: String
    var guest: User
    var promo: User?
    var table: String?
    var comment: String?
    
    init(id: String, date: String, guest: User, promo: User?, table: String?, comment: String?) {
        self.id = id
        self.date = date
        self.guest = guest
        self.promo = promo
        self.table = table
        self.comment = comment
    }
    
    func isForDate(date: Date) -> Bool {
        return date.stringDate() == self.date
    }
    
    func inThePast() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: self.date),
           let today = dateFormatter.date(from: Date().stringDate()) {
            return date < today
        } else {
            return false
        }
    }
    
    init?(id: String, data: [String: Any]) {
        // Mandatory Fields
        self.id = id
        guard let date = data["date"] as? String,
              let guestID = data["guestID"] as? String,
              let guest = LocalData.shared.getGuest(byId: guestID)
        else { return nil }
        self.date = date
        self.guest = guest
        
        // Optional Fields
        if let table = data["table"] as? String {
            self.table = table
        }
        if let comment = data["comment"] as? String {
            self.comment = comment
        }
        if let promoID = data["promoID"] as? String,
           let promo = LocalData.shared.getPromo(byId: promoID) {
            self.promo = promo
        }
    }
}
