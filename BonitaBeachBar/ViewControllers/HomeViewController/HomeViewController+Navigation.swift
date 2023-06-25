//
//  HomeViewController+Navigation.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

extension HomeViewController {
    func pushViewController(vc: BonitaViewControllers) {
        switch vc {
        case .addUser: pushAddUserVC()
        case .addMaster: pushAddMasterVC()
        case .addReservation: pushAddPromoVC()
        case .addVisit: pushAddVisitVC()
        default: break
        }
    }
    
    func showVisit(indexPath: IndexPath) {
        if let visit = bonitaDataSource[indexPath.row] as? Visit,
           let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewVisitViewController") as? AddNewVisitViewController {
            vc.readOnly = true
            vc.visit = visit
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showUser(indexPath: IndexPath) {
        if let user = bonitaDataSource[indexPath.row] as? User,
            let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewUserViewController") as? AddNewUserViewController {
            vc.user = user
            vc.readOnly = true
            vc.unwindDestinationVC = self
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func pushAddUserVC() {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewUserViewController") as? AddNewUserViewController {
            vc.type = .guest
            vc.unwindDestinationVC = self
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func pushAddPromoVC() {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController {
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func pushAddMasterVC() {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewUserViewController") as? AddNewUserViewController {
            vc.type = .master
            vc.unwindDestinationVC = self
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func pushAddVisitVC() {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewVisitViewController") as? AddNewVisitViewController {
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { }
}

enum BonitaViewControllers {
    case addUser
    case addMaster
    case addReservation
    case addVisit
    case addBill
}
