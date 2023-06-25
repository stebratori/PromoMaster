//
//  Visit.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/27/23.
//

import Foundation

struct Visit {
    var id: String
    var date: String
    var comment: String?
    var table: String?
    var guest: User?
    var promo: User?
    var bill: Bill?
    
    init(id: String, date: String, guest: User, promo: User?, bill: Bill) {
        self.id = id
        self.date = date
        self.guest = guest
        self.promo = promo
        self.bill = bill
    }
    
    init?(id: String, data: [String: Any]) {
        self.id = id
        if let date = data["date"] as? String {
            self.date = date
        } else { return nil }
        if let guestID = data["guestID"] as? String {
            self.guest = LocalData.shared.getGuest(byId: guestID)
        }
        if let promoID = data["promoID"] as? String {
            self.promo = LocalData.shared.getPromo(byId: promoID)
        }
        if let billID = data["billID"] as? String {
            self.bill = LocalData.shared.getBill(byId: billID)
        }
        if let table = data["table"] as? String {
            self.table = table
        }
        if let comment = data["comment"] as? String {
            self.comment = comment
        }
    }
}
