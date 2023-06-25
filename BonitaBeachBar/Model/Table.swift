//
//  Table.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/22/23.
//

import Foundation

struct Table {
    var number: String
    var type: TableType
    
    init(number: String, type: TableType) {
        self.number = number
        self.type = type
    }
    
    init?(data: [String: Any]) {
        guard
            let number = data["number"] as? String,
            let type = data["type"] as? String,
            let tableType = TableType(rawValue: type)
        else { return nil }
        self.number = number
        self.type = tableType
    }
}

enum TableType: String {
    case booth
    case table
    case bar
}
