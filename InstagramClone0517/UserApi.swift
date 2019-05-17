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
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
}
