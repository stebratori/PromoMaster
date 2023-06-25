//
//  LoginViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/7/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtPin: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtPin.becomeFirstResponder()
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let pin = txtPin.text else { return }
        var userLoggedIn: Bool = false
        if let allPromo = LocalData.shared.allPromo {
            for promo in allPromo {
                if let promoPin = promo.pin, promoPin == pin {
                    UserService.shared.currentUser = promo
                    userLoggedIn = true
                }
            }
        }
        
        if let allMaster = LocalData.shared.allMaster {
            for master in allMaster {
                if let masterPin = master.pin, masterPin == pin {
                    UserService.shared.currentUser = master
                    userLoggedIn = true
                }
            }
        }
        
        if userLoggedIn {
            PersistenceService.shared.storePin(pin: pin)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            lblMessage.text = "Wrong PIN"
            lblMessage.textColor = .red
            txtPin.text = ""
        }
        
    }
    
    private func setupView() {
        viewBackground.cornerRadius()
        btnGo.cornerRadius()
        txtPin.cornerRadius()
        txtPin.attributedPlaceholder = NSAttributedString(
            string: "PIN",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
    }
}
