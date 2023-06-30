//
//  LocalData+Bill.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension LocalData {
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
}
