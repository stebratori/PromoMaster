//
//  LocalData+Bill.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension LocalData {
    func getBill(byId id: String) -> Bill? {
        guard let allBills = LocalData.shared.allBills else { return nil }
        for myBill in allBills where myBill.id == id {
            return myBill
        }
        return nil
    }
}
