//
//  MyPostApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/21.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class MyPostApi {
    
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
    
    func observeMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: { (DataSnapshot) in
            completion(DataSnapshot.key)
        })
    }
}
