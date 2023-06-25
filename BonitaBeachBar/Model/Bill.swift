//
//  Bill.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/27/23.
//

import Foundation

struct Bill {
    var id: String = ""
    var date: String = ""
    var billItems: [StavkaRacuna] = []
    var total: Double = 0.0
    
    init(id: String, date: String, billItems: [StavkaRacuna], total: Double) {
        self.id = id
        self.date = date
        self.billItems = billItems
        self.total = total
    }
    
    init?(id: String, data: [String: Any]) {
        guard
            let date = data["date"] as? String,
            let total = data["total"] as? Double,
            let billItemsData = data["billItems"] as? [[String: Any]]
        else { return nil }
        
        self.id = id
        self.date = date
        self.total = total
        for billItemData in billItemsData {
            if let billItem = StavkaRacuna(data: billItemData) {
                billItems.append(billItem)
            }
        }
    }
}

struct StavkaRacuna {
    var price: Double
    var count: Int
    var name: String
    
    init?(data: [String: Any]) {
        guard
            let price = data["price"] as? Double,
            let count = data["count"] as? Int,
            let name = data["name"] as? String
        else { return nil }
        self.price = price
        self.name = name
        self.count = count
    }
    
    init(name: String, price: Double, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
}
