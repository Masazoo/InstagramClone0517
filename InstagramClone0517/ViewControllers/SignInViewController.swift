//
//  SignInViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Api.User.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "signInToTabbarSegue", sender: nil)
        }
    }
    
    @IBAction func signInBtn_TouchUpInside(_ sender: Any) {
        AuthService.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signInToTabbarSegue", sender: nil)
            ProgressHUD.showSuccess("サインインに成功しました")
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
}
