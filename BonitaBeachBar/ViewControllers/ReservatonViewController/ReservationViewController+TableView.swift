//
//  ReservationViewController+TextField.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/21/23.
//

import UIKit

extension ReservationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewSuggestionsDataSourceFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .black
        cell.textLabel?.textColor = Constants.yellowMid
        if tableViewSuggestionsType == .guest || tableViewSuggestionsType == .promo,
           let user = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? User {
            cell.textLabel?.text = user.name
        }
        else if tableViewSuggestionsType == .table,
                let table = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? Table {
            cell.textLabel?.text = "\(table.number) | (\(table.type.rawValue))"
        }
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = tableViewSuggestionsType else { return }
        switch type {
        case .guest:
            if let guest = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? User {
                setGuest(guest: guest)
            }
        case .promo:
            if let promo = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? User {
                setPromo(promo: promo)
            }
        case .table:
            if let table = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? Table {
                setTable(table: table)
            }
        }
        removeSuggestionsTableView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
        else if textField == txtTableNumber {
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
    
    func removeSuggestionsTableView() {
        tableViewSuggestions?.removeFromSuperview()
        tableViewSuggestions = nil
        tableViewSuggestionsDataSource = []
        tableViewSuggestionsDataSourceFiltered = []
    }
}

enum TableViewSuggestionsType {
    case guest
    case promo
    case table
}
