//
//  LocalData+Visits.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension LocalData {
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
}
