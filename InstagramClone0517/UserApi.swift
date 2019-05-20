//
//  UserApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
class UserApi {
    
    var REF_USERS = Database.database().reference().child("users")
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    
    func observeUser(uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newUser = UserModel.transformUser(dict: dict)
                completion(newUser)
            }
        })
    }
}
