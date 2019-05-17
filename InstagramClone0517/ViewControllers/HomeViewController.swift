//
//  HomeViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func signOutBtn_TouchUpInside(_ sender: Any) {
        AuthService.signOut(onSuccess: {
            let stroyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = stroyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    

}
