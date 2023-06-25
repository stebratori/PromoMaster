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
            cell.textLabel?.text = "\(table.number)"
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
    
    
}

enum TableViewSuggestionsType {
    case guest
    case promo
    case table
}
