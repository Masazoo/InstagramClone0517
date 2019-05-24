//
//  CommentApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    
    func observeComment(commentId: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(commentId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
    
    
    func sendCommentInfo(commentText: String, onSuccess: @escaping (String) -> Void) {
        let newCommentId = Api.Comment.REF_COMMENTS.childByAutoId().key
        let newCommentRef = Api.Comment.REF_COMMENTS.child(newCommentId!)
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentRef.setValue(["commentText": commentText, "uid": currentUserId]) { (Error, DatabaseReference) in
            if Error != nil {
                return
            }
            onSuccess(newCommentId!)
        }
    }
}
