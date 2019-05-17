//
//  AuthService.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signOut(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let error {
            onError(error.localizedDescription)
        }
    }
    
    
    static func signUp(email: String, username: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            let uid = AuthDataResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image")
            storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                if Error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (URL, Error) in
                    let profileImageUrl = URL?.absoluteString
                    setUserInfo(uid: uid!, username: username, email: email, profileImageUrl: profileImageUrl!, onSuccess: onSuccess)
                })
            })
        }
    }
    static func setUserInfo(uid: String, username: String, email: String, profileImageUrl: String, onSuccess: @escaping () -> Void) {
        let usersRef = Database.database().reference().child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
}
