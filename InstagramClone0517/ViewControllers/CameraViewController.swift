//
//  CameraViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handoleSelectProfileImageView))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func handoleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            HelperService.uploadDataToServe(captionText: self.captionTextView.text!, imageData: imageData, onSuccess: {
                self.clean()
                self.tabBarController?.selectedIndex = 0
            }) { (error) in
                ProgressHUD.showError(error)
            }
        }else{
            ProgressHUD.showError("画像を選択してください")
        }
    }
    
    func clean() {
        self.photoImageView.image = UIImage(named: "Placeholder-image")
        self.captionTextView.text = ""
        self.selectedImage = nil
    }
    
    
}
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finidh Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            photoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
