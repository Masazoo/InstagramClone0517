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
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
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
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
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
        newUserRef.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    
    static func updateUserInfo(email: String, username: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Api.User.CURRENT_USER?.updateEmail(to: email, completion: { (Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
            }else{
                let uid = Api.User.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
                storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                    if Error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (URL, Error) in
                        let profileImageUrl = URL?.absoluteString
                        updateDatabase(uid: uid!, username: username, email: email, profileImageUrl: profileImageUrl!, onSuccess: onSuccess, onError: onError)
                    })
                })
            }
        })
    }
    static func updateDatabase(uid: String, username: String, email: String, profileImageUrl: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        let dict = ["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl]
        Api.User.REF_USERS.child(uid).updateChildValues(dict) { (Error, DatabaseReference) in
            if Error != nil {
                onError(Error!.localizedDescription)
            }else{
                onSuccess()
            }
        }
    }
    
}
