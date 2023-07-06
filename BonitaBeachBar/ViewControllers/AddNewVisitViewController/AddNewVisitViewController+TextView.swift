//
//  ReservationViewController+TextView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/21/23.
//

import Foundation
import UIKit

extension AddNewVisitViewController: UITextFieldDelegate {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let textCount = textField.text?.count else {
            removeSuggestionsTableView()
            return
        }
        if textCount > 0 {
            if tableViewSuggestions == nil {
                showTableViewSuggestions(below: textField)
            }
            sortMenuSearchResults(searchText: textField.text)
        }
        else {
            removeSuggestionsTableView()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeSuggestionsTableView()
        showTableViewSuggestions(below: textField)
        tableViewSuggestions?.reloadData()
    }
    
    private func sortMenuSearchResults(searchText: String?) {
        guard let searchText = searchText else { return }
        tableViewSuggestionsDataSourceFiltered.removeAll()
        for object in tableViewSuggestionsDataSource {
            if let user = object as? User, user.name.contains(searchText) {
                tableViewSuggestionsDataSourceFiltered.append(user)
            }
            else if let table = object as? Table, table.number.contains(searchText) {
                tableViewSuggestionsDataSourceFiltered.append(table)
            }
        }
        tableViewSuggestions?.reloadData()
        if tableViewSuggestionsDataSourceFiltered.count == 0 {
            removeSuggestionsTableView()
        }
    }
    
    func removeSuggestionsTableView() {
        tableViewSuggestions?.removeFromSuperview()
        tableViewSuggestions = nil
        tableViewSuggestionsDataSource = []
        tableViewSuggestionsDataSourceFiltered = []
    }
    
    func showTableViewSuggestions(below textField: UITextField) {
        guard
            let textViewOrigin = textField.superview?.convert(textField.frame.origin, to: nil),
            let allGuests = LocalData.shared.allGuests,
            let allPromo = LocalData.shared.allPromo,
            let allTables = LocalData.shared.tables
        else { return }
        let tableViewFrame = CGRect(x: textViewOrigin.x,
                                    y: textViewOrigin.y + textField.frame.size.height,
                                    width: textField.frame.size.width,
                                    height: 130)
        let tableView = UITableView(frame: tableViewFrame)
        tableView.delegate = self
        tableView.dataSource = self
        if textField == txtGuest {
            tableViewSuggestionsType = .guest
            tableViewSuggestionsDataSource = allGuests
            tableViewSuggestionsDataSourceFiltered = allGuests
        }
        else if textField == txtPromo {
            tableViewSuggestionsType = .promo
            tableViewSuggestionsDataSource = allPromo
            tableViewSuggestionsDataSourceFiltered = allPromo
        }
        else if textField == txtTable {
            tableViewSuggestionsType = .table
            tableViewSuggestionsDataSource = allTables
            tableViewSuggestionsDataSourceFiltered = allTables
        }
        tableView.layer.borderColor = Constants.yellowDark.cgColor
        tableView.layer.borderWidth = 1
        tableViewSuggestions = tableView
        view.addSubview(tableView)
        view.bringSubviewToFront(tableView)
        tableViewSuggestions?.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddNewVisitViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}
