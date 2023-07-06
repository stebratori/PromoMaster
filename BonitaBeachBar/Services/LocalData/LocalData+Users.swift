//
//  LocalData+Users.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension LocalData {
    func removeUser(user: User?) {
        guard let user = user else { return }
        if user.type == .promo {
            allPromo?.removeAll(where: { User in
                User.id == user.id
            })
        }
        else if user.type == .master {
            allMaster?.removeAll(where: { User in
                User.id == user.id
            })
        }
        else if user.type == .guest {
            allGuests?.removeAll(where: { User in
                User.id == user.id
            })
        }
    }
    
    func updateUser(user: User) {
        switch user.type {
        case .guest:
            if let allGuests = allGuests {
                for (index, guest) in allGuests.enumerated() {
                    if guest.id == user.id {
                        self.allGuests?.remove(at: index)
                        self.allGuests?.insert(user, at: index)
                    }
                }
            }
        case .promo:
            if let allPromo = allPromo {
                for (index, promo) in allPromo.enumerated() {
                    if promo.id == user.id {
                        self.allPromo?.remove(at: index)
                        self.allPromo?.insert(user, at: index)
                    }
                }
            }
        case .master:
            if let allMaster = allMaster {
                for (index, master) in allMaster.enumerated() {
                    if master.id == user.id {
                        self.allMaster?.remove(at: index)
                        self.allMaster?.insert(user, at: index)
                    }
                }
            }
        }
    }
    
    func addUser(user: User) {
        switch user.type {
        case .guest: LocalData.shared.allGuests?.insert(user, at: 0)
        case .promo: LocalData.shared.allPromo?.append(user)
        case .master: LocalData.shared.allMaster?.append(user)
        }
    }
    
    func getGuest(byId id: String) -> User? {
        guard let allGuests = LocalData.shared.allGuests else { return nil }
        for myGuest in allGuests where myGuest.id == id {
            return myGuest
        }
        return nil
    }
    
    func getGuest(byName name: String?) -> User? {
        guard let name = name, let allGuests = LocalData.shared.allGuests else { return nil }
        for myGuest in allGuests where myGuest.name == name {
            return myGuest
        }
        return nil
    }
    
    func getPromo(byId id: String) -> User? {
        guard let allPromo = LocalData.shared.allPromo else { return nil }
        for myPromo in allPromo where myPromo.id == id {
            return myPromo
        }
        return nil
    }
}

