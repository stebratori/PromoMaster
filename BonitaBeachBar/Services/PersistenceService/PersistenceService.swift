//
//  LocalStorage.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/7/23.
//

import Foundation

class PersistenceService {
    static let shared: PersistenceService = PersistenceService()
    
    func storePin(pin: String) {
        UserDefaults.standard.set(pin, forKey: LocalStorageKey.pin)
    }
    
    func getPin() -> String? {
        if let value = UserDefaults.standard.value(forKey: LocalStorageKey.pin) as? String {
            return value
        }
        return nil
    }
    
    func deletePin() {
        UserDefaults.standard.removeObject(forKey: LocalStorageKey.pin)
    }
}

struct LocalStorageKey {
    static let pin: String = "bonita_pin"
}
