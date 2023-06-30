//
//  Guest.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/27/23.
//

import Foundation

class User {
    var id: String
    var name: String
    var type: UserType
    var pin: String?
    var email: String?
    var phone: String?
    var visits: [Visit]?
    
    
    func getTotalSum() -> Double {
        guard let visits = visits else { return 0 }
        var total: Double = 0.0
        for visit in visits {
            if let bill = visit.bill {
                total += bill.total
            }
        }
        return total
    }
    
    func getMonthlySum(month: Int, year: Int) -> Double {
        let monthlyVisits = getAllVisitsForMonthAboveMin(month: month, year: year)
        var total: Double = 0.0
        for visit in monthlyVisits {
            if let bill = visit.bill {
                total += bill.total
            }
        }
        return total
    }
    
    func populateVisits() {
        visits?.removeAll()
        switch type {
        case .guest: populateVisitsForGuest()
        case .promo: populateVisitsForPromo()
        default: break
        }
    }
    
    func pinFormatted() -> String? {
        guard let pin = pin else { return nil }
        var formattedString: String = ""
        for (index, char) in pin.enumerated() {
            formattedString += "\(char)"
            if index < pin.count - 1 {
                formattedString += " "
            }
        }
        return formattedString
    }
    
    private func populateVisitsForGuest() {
        guard let allVisits = LocalData.shared.allVisits else { return }
        for visit in allVisits {
            if let guestId = visit.guest?.id {
                if guestId == self.id {
                    if visits == nil { visits = [] }
                    visits?.append(visit)
                }
            }
        }
    }
    
    private func populateVisitsForPromo() {
        guard let allVisits = LocalData.shared.allVisits else { return }
        for visit in allVisits {
            if let guestId = visit.promo?.id {
                if guestId == self.id {
                    if visits == nil { visits = [] }
                    visits?.append(visit)
                }
            }
        }
    }
    
    init(id: String, name: String, type: UserType) {
        self.id = id
        self.name = name
        self.type = type
    }

    init?(id: String, data: [String: Any]) {
        // Mandatory Fields
        self.id = id
        guard let name = data["name"] as? String,
              let type = data["type"] as? String,
              let userType = UserType(rawValue: type)
        else { return nil }

        self.name = name
        self.type = userType
        
        // Optional Fields
        if userType == .promo || userType == .master,
           let pin = data["pin"] as? String {
            self.pin = pin
        }
        if let email = data["email"] as? String {
            self.email = email
        }
        if let phone = data["phone"] as? String {
            self.phone = phone
        }
    }
    
    func getAllVisitDates() -> [Date] {
        guard let visits = visits else { return [] }
        var visitDates: [Date] = []
        for visit in visits {
            if let date = visit.date.toDate(), !visitDates.contains(date) {
                visitDates.append(date)
            }
        }
        return visitDates.sorted(by: { $0 < $1 })
    }
    
    func getVisitsForDate(date: Date) -> [Visit] {
        guard let visits = visits else { return [] }
        var visitsForDate: [Visit] = []
        for visit in visits where date.stringDate() == visit.date {
            visitsForDate.append(visit)
        }
        return visitsForDate
    }
    
    func getVisitMonths() -> [(month: Int, year: Int)] {
        guard let visits = visits else { return [] }
        var visitMonths: [(month: Int, year: Int)] = []
        for visit in visits {
            if let date = visit.date.toDate() {
                let dateComponents = Calendar.current.dateComponents([.month, .year], from: date)
                if let month = dateComponents.month, let year = dateComponents.year {
                    let visitDate: (Int, Int) = (month, year)
                    var alreadyAdded: Bool = false
                    for visitMonth in visitMonths {
                        if visitMonth.month == month && visitMonth.year == year {
                            alreadyAdded = true
                        }
                    }
                    if !alreadyAdded {
                        visitMonths.append(visitDate)
                    }
                }
            }
        }
        // TODO: Sort by YEARS
        return visitMonths.sorted(by: {$0.month < $1.month})
    }
    
    func getAllVisitsForMonthAboveMin(month: Int, year: Int) -> [Visit] {
        guard let visits = visits else { return [] }
        var monthlyVisits: [Visit] = []
        for visit in visits {
            if let visitDate = visit.date.toDate() {
                let visitDateComponents = Calendar.current.dateComponents([.month, .year], from: visitDate)
                if visitDateComponents.month == month && visitDateComponents.year == year,
                   let total = visit.bill?.total,
                   total > LocalData.shared.promoMin {
                    monthlyVisits.append(visit)
                }
            }
        }
        return monthlyVisits
    }
}

enum UserType: String {
    case guest
    case promo
    case master
    
    func getFirebaseCollectionName() -> String {
        switch self {
        case .guest: return "gosti"
        case .promo: return "promoteri"
        case .master: return "master"
        }
    }
    
    func getHeaderName() -> String {
        switch self {
        case .guest: return "Guest"
        case .promo: return "Promo"
        case .master: return "Master"
        }
    }
    
    func getButtonName() -> String {
        switch self {
        case .guest: return "Guest"
        case .promo: return "Promo"
        case .master: return "Master"
        }
    }
}
