//
//  Comment.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class Comment {
    
    var commentText: String?
    var uid: String?

}
extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        
        return comment
    }
}
