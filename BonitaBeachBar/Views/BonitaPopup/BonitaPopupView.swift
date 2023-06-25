//
//  BonitaPopupView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/10/23.
//

import UIKit

class BonitaPopupView: UIView {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var type: BonitaPopupType = .none
    var delegate: BonitaPopupDelegate?
    
    func setupView(for type: BonitaPopupType) {
        self.type = type
        btnAction.cornerRadius()
        btnCancel.cornerRadius()
        viewPopup.cornerRadius()
        btnAction.setTitle(type.getButtonText(), for: .normal)
        btnAction.backgroundColor = type.getButtonColor()
        lblText.text = type.getText()
    }
    
    @IBAction func performAction() {
        switch type {
        case .deleteUser: deleteUser()
        case .logout: logout()
        default: break
        }
    }
    
    @IBAction func cancel() {
        closePopup()
    }
    
    @objc
    func closePopup() {
        removeFromSuperview()
    }
    
    private func deleteUser() {
        delegate?.deleteUser()
        closePopup()
    }
    
    private func logout() {
        delegate?.logout()
        closePopup()
    }
}

enum BonitaPopupType {
    case deleteUser
    case logout
    case none
    
    func getButtonColor() -> UIColor {
        switch self {
        case .deleteUser: return Constants.bonitaRed
        case .logout: return Constants.logoutYellow
        default: return UIColor.white
        }
    }
    
    func getButtonText() -> String {
        switch self {
        case .deleteUser: return "Delete"
        case .logout: return "Log Out"
        default: return ""
        }
    }
    func getText() -> String {
        switch self {
        case .deleteUser: return "Are you sure you want to Delete this user?\n\nThis action cannot be reverted."
        case .logout: return "Are you sure you want to Log Out?"
        default: return ""
        }
    }
}

protocol BonitaPopupDelegate {
    func logout()
    func deleteUser()
}
