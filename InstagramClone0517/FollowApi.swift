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
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(uid).setValue(true)
        REF_FOLLOWERS.child(uid).child(Api.User.CURRENT_USER!.uid).setValue(true)
        
        Api.Notification.NotificationToDatabase(uid: uid, objectId: uid, type: "follow")
    }
    
    func unFollowAction(uid: String) {
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(uid).setValue(NSNull())
        REF_FOLLOWERS.child(uid).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        
        Api.Notification.NotificationRemove(uid: uid, type: "follow")
    }
    
    func observeFollowingCount(completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).observe(.value, with: { (DataSnapshot) in
            let count = Int(DataSnapshot.childrenCount)
            completion(count)
        })
    }
    
    func observeFollowersCount(completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(Api.User.CURRENT_USER!.uid).observe(.value, with: { (DataSnapshot) in
            let count = Int(DataSnapshot.childrenCount)
            completion(count)
        })
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
