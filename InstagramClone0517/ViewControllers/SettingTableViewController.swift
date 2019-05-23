//
//  SettingTableViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/23.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
protocol SettingTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handoleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        fetchUser()
    }

    func fetchUser() {
        Api.User.fetchCurrentUser { (user) in
            self.nameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrlString = user.profileImageUrl {
                let profileImageUrl = URL(string: profileUrlString)
                self.profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
            }
        }
    }
    
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.updateUserInfo(email: self.emailTextField.text!, username: self.nameTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("保存が成功しました")
                self.delegate?.updateUserInfo()
            }) { (error) in
                ProgressHUD.showError(error)
            }
        }
        
    }
    

    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let stroyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = stroyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    func handoleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finidh Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
