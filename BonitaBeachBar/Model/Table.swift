//
//  Table.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/22/23.
//

import Foundation

struct Table {
    var number: String
    
    init(number: String) {
        self.number = number
    }
    
    init?(data: [String: Any]) {
        guard let number = data["number"] as? String else { return nil }
        self.number = number
    }
}
