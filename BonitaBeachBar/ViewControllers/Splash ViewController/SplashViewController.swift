//
//  SplashViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import UIKit

class SplashViewController: UIViewController {
    private let firebaseService: FirebaseService = FirebaseService()
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var pushUserToLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !pushUserToLogin {
            FirebaseService().firebaseAuthenticateAndFetchAllData { success, error in
                if success {
                    self.firebaseDataFetched()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController, pushUserToLogin {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    private func firebaseDataFetched() {
        if UserService.shared.setUserIfPinExists() {
            if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        } else {
            if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
}
