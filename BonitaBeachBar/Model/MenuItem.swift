//
//  Menu.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/16/23.
//

import Foundation

struct MenuItem {
    let name: String
    let price: Double
    
    init?(data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let price = data["price"] as? Double
        else { return nil }
        
        self.name = name
        self.price = price
    }
}
