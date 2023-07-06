//
//  AddUserToVisitViewController+TableView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

extension AddUserToVisitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        let user = dataSource[indexPath.row]
        cell.setupView(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = dataSource[indexPath.row]
        performSegue(withIdentifier: unwindSegueName, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        81
    }
}
