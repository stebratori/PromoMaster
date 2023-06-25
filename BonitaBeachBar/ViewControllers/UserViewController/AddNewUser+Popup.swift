//
//  AddNewUser+Popup.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/10/23.
//

import Foundation

extension AddNewUserViewController: BonitaPopupDelegate {
    func logout() {
        UserService.shared.logOut(viewController: self)
    }
    
    func deleteUser() {
        guard let user = user else { return }
        loader.isHidden = false
        FirebaseService().deleteUser(user: user) { success in
            LocalData.shared.removeUser(user: user)
            self.backToHomeScreen ?
            self.performSegue(withIdentifier: "addNewUserToHome", sender: self) :
            self.performSegue(withIdentifier: "unwindToVisit", sender: self)
        }
    }
    
    func showPopup(type: BonitaPopupType) {
        if let popup = Bundle.main.loadNibNamed("BonitaPopupView", owner: self)?.first as? BonitaPopupView {
            popup.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            popup.setupView(for: type)
            popup.delegate = self
            view.addSubview(popup)
        }
    }
    
    
}
