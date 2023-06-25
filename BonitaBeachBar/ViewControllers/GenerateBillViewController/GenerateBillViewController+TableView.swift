//
//  GenerateBillViewController+TableView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import UIKit

extension GenerateBillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return billItems.count
        } else {
            return filteredMenuItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
            let item = billItems[indexPath.row]
            cell.setupCell(item: item, row: indexPath.row)
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = filteredMenuItems[indexPath.row].name
            cell.backgroundColor = .black
            cell.textLabel?.textColor = Constants.yellowLight
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 60
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == self.tableView {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView, editingStyle == .delete {
            billItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == menuItemTableView else { return }
        let menuItem = filteredMenuItems[indexPath.row]
        txtName.text = menuItem.name
        txtPrice.text = String(menuItem.price)
        menuItemTableView.isHidden = true
        txtCount.becomeFirstResponder()
        menuItemTableView.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        txtName.resignFirstResponder()
        txtPrice.resignFirstResponder()
        txtCount.resignFirstResponder()
    }
}
