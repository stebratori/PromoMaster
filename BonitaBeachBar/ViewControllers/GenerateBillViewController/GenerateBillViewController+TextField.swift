//
//  GenerateBillViewController+TextField.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import UIKit

extension GenerateBillViewController: UITextFieldDelegate {
    func billItemDataComplete() -> Bool {
        var name: Bool = true
        var price: Bool = true
        var count: Bool = true
        
        if txtName.text?.count == 0 {
            txtName.layer.borderColor = UIColor.red.cgColor
            name = false
        }
        
        if txtPrice.text?.count == 0 {
            txtPrice.layer.borderColor = UIColor.red.cgColor
            price = false
        }
        
        if txtCount.text?.count == 0 {
            txtCount.layer.borderColor = UIColor.red.cgColor
            count = false
        }
        
        return name && price && count
    }
    
    func addnewBillItem() {
        if let name = txtName.text,
           let priceText = txtPrice.text,
           let countText = txtCount.text,
           let price = Double(priceText),
           let count = Int(countText)
        {
            let billItem = StavkaRacuna(name: name, price: price, count: count)
            billItems.append(billItem)
            tableView.reloadData()
            txtName.text = ""
            txtCount.text = ""
            txtPrice.text = ""
            txtName.resignFirstResponder()
            txtPrice.resignFirstResponder()
            txtCount.resignFirstResponder()
            calculateTotalPrice()
        }
    }
    
    private func calculateTotalPrice() {
        var total: Double = 0
        for billItem in billItems {
            total += billItem.price * Double(billItem.count)
        }
        lblTotal.text = "Total: \(total.formatted()) rsd"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let menu = LocalData.shared.menu {
            filteredMenuItems = menu
        }
        menuItemTableView.reloadData()
        menuItemTableView.isHidden = false
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let textCount = textField.text?.count else {
            menuItemTableView.isHidden = true
            return
        }
        if textCount > 0 {
            menuItemTableView.isHidden = false
            sortMenuSearchResults(searchText: textField.text)
        } else {
            menuItemTableView.isHidden = true
        }
    }
    
    private func sortMenuSearchResults(searchText: String?) {
        guard let searchText = searchText else { return }
        filteredMenuItems.removeAll()
        for menuItem in menuItems where menuItem.name.contains(searchText) {
            filteredMenuItems.append(menuItem)
        }
        menuItemTableView.reloadData()
    }
}
