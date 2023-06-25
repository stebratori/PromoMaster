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
