//
//  AddNewUser+TableView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/9/23.
//

import UIKit

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch userStatisticsType {
        case .bookings:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsTableViewCell", for: indexPath) as! VisitsTableViewCell
            if let visit = tableViewDataSource[indexPath.row] as? Visit {
                cell.setupView(visit: visit)
            }
            return cell
            
        case .favorites:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
            if let item = tableViewDataSource[indexPath.row] as? StavkaRacuna {
                cell.setupCell(item: item, row: indexPath.row)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewVisitViewController") as? AddNewVisitViewController,
           let visit = tableViewDataSource[indexPath.row] as? Visit {
            vc.readOnly = true
            vc.visit = visit
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch userStatisticsType {
        case .bookings: return 135
        case .favorites: return 50
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    @objc
    func hideKeyboard() {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPhone.resignFirstResponder()
    }
    
    func reloadTableViewData(type: UserStatisticsType) {
        userStatisticsType = type
        switch type {
        case .bookings:
            tableViewDataSource = user?.visits ?? []
            viewFavoritesLegend.isHidden = true
        case .favorites:
            tableViewDataSource = user?.favorites() ?? []
            viewFavoritesLegend.isHidden = false
        }
        tableView.reloadData()
    }
}
