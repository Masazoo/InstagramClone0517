//
//  PostApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class PostApi {
    
    var REF_POSTS = Database.database().reference().child("posts")
    
    func obsesrvePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict, key: DataSnapshot.key)
                completion(newPost)
            }
        })
    }
    
    
}
