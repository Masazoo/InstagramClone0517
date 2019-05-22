//
//  FollowApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/22.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowApi {
    
    var REF_FOLLOWING = Database.database().reference().child("following")
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    
    
    func followAction(uid: String) {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        REF_FOLLOWING.child(currentUser.uid).child(uid).setValue(true)
        REF_FOLLOWERS.child(uid).child(currentUser.uid).setValue(true)
    }
    
    func unFollowAction(uid: String) {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        REF_FOLLOWING.child(currentUser.uid).child(uid).setValue(NSNull())
        REF_FOLLOWERS.child(uid).child(currentUser.uid).setValue(NSNull())
    }
    
    
    
    
    func isFollowing(uid: String, completion: @escaping (Bool) -> Void) {
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let _ = DataSnapshot.value as? NSNull {
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    
    
}
