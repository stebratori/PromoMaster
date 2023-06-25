//
//  UserService.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/7/23.
//

import UIKit

class UserService {
    static let shared: UserService = UserService()
    var currentUser: User?
    
    func currentUserID() -> String {
        return currentUser?.id ?? ""
    }
    
    func currentUserIsPromo() -> Bool {
        guard let currentUser = currentUser else { return false }
        return currentUser.type == .promo
    }
    
    func isCurrentUser(thisUser user: User?) -> Bool {
        guard
            let currentUser = currentUser,
            let user = user
        else { return false }
        return currentUser.id == user.id
    }
    
    func setUserIfPinExists() -> Bool {
        guard let pin = PersistenceService.shared.getPin() else { return false }
        if let allPromo = LocalData.shared.allPromo {
            for promo in allPromo {
                if promo.pin == pin {
                    promo.type = .promo
                    currentUser = promo
                    return true
                }
            }
        }
        if let allMaster = LocalData.shared.allMaster {
            for master in allMaster {
                if master.pin == pin {
                    master.type = .master
                    currentUser = master
                    return true
                }
            }
        }
        return false
    }
    
    func logOut(viewController: UIViewController) {
        UserService.shared.currentUser = nil
        PersistenceService.shared.deletePin()
        if let navigationStack = viewController.navigationController?.viewControllers {
            for vc in navigationStack {
                if let splashViewController = vc as? SplashViewController {
                    splashViewController.pushUserToLogin = true
                    viewController.navigationController?.popToViewController(splashViewController, animated: true)
                }
            }
        }
    }
}
