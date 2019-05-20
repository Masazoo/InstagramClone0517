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
}
extension Post {
    static func transformPost(dict: [String: Any]) -> Post {
        let post = Post()
        post.captionText = dict["captionText"] as? String
        post.postImageUrl = dict["postImageUrl"] as? String
        post.uid = dict["uid"] as? String
        
        return post
    }
}
