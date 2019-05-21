//
//  Post.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class Post {
    
    var captionText: String?
    var postImageUrl: String?
    var uid: String?
    var postId: String?
}
extension Post {
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.captionText = dict["captionText"] as? String
        post.postImageUrl = dict["postImageUrl"] as? String
        post.uid = dict["uid"] as? String
        post.postId = key
        
        return post
    }
}
