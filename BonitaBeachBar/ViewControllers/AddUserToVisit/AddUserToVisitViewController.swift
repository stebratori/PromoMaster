//
//  AddUserToVisitViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

class AddUserToVisitViewController: UIViewController {
    @IBOutlet weak var lblSelectYourUser: UILabel!
    @IBOutlet weak var lblCantFindYourUser: UILabel!
    @IBOutlet weak var btnAddNewUser: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userType: UserType = .guest
    var dataSource: [User] = []
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var selectedUser: User?
    var unwindSegueName: String = "unwindToAddVisit"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
    }
    
    private func setDataSource() {
        switch userType {
        case .guest:
            if let users = LocalData.shared.allGuests {
                dataSource = users
            }
        case .promo:
            if let users = LocalData.shared.allPromo {
                dataSource = users
            }
        case .master:
            if let users = LocalData.shared.allMaster {
                dataSource = users
            }
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDataSource()
    }
    
    @IBAction func addNewGuest(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddNewUserViewController") as? UserViewController {
            vc.type = userType
            vc.backToHomeScreen = false
            vc.unwindDestinationVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupView() {
        switch userType {
        case .guest:
            lblSelectYourUser.text = "Select your guest from the table below"
            btnAddNewUser.setTitle("Add Guest", for: .normal)
        case .promo:
            lblSelectYourUser.text = "Select your promo from the table below"
            btnAddNewUser.setTitle("Add Promo", for: .normal)
        default: break
        }
        if UserService.shared.currentUserIsPromo(), userType == .promo {
            btnAddNewUser.isHidden = true
            lblCantFindYourUser.isHidden = true
        }
        btnAddNewUser.cornerRadius()
        tableView.register(UINib.init(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersTableViewCell")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewVisitViewController {
            switch userType {
            case .guest:
                if let user = selectedUser {
                    vc.setGuest(guest: user)
                }
            case .promo:
                if let user = selectedUser {
                    vc.setPromo(promo: user)
                }
            default: break
            }
        }
        else if let vc = segue.destination as? ReservationViewController {
            switch userType {
            case .guest:
                if let user = selectedUser {
                    vc.setGuest(guest: user)
                }
            case .promo:
                if let user = selectedUser {
                    vc.setPromo(promo: user)
                }
            default: break
            }
        }
    }
    
    @IBAction func unwindToAddUserToVisit(segue: UIStoryboardSegue) { }
}
