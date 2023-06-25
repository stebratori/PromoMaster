//
//  HomeViewController+MyNotifications.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import Foundation
import UIKit

extension HomeViewController {
    func subscribeToMyNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}
