//
//  UserModel.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class UserModel {
    
    var username: String?
    var email: String?
    var profileImageUrl: String?
}
extension UserModel {
    static func transformUser(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.username = dict["username"] as? String
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        
        return user
    }
}
