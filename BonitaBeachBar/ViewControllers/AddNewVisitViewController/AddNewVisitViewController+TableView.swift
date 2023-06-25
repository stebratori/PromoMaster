//
//  AddNewVisitViewController+TableView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import UIKit

extension AddNewVisitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            guard let billitems = self.billItems else { return 0 }
            return billitems.count
        } else {
            return tableViewSuggestionsDataSourceFiltered.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
            if let item = billItems?[indexPath.row] {
                cell.setupCell(item: item, row: indexPath.row)
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.backgroundColor = .black
            cell.textLabel?.textColor = Constants.yellowMid
            if tableViewSuggestionsType == .guest || tableViewSuggestionsType == .promo,
               let user = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? User {
                cell.textLabel?.text = user.name
            }
            else if tableViewSuggestionsType == .table,
                    let table = tableViewSuggestionsDataSourceFiltered[indexPath.row] as? Table {
                cell.textLabel?.text = "\(table.number))"
            }
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView != self.tableView, let type = tableViewSuggestionsType else { return }
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
        if tableView == self.tableView {
            return 60
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !readOnly
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, !readOnly {
            billItems?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
