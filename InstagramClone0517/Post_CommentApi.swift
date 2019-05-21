//
//  Post_CommentApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class Post_CommentApi {
    
    var REF_POST_COMMENT = Database.database().reference().child("post-comment")
    
    
    func observePostComments(postId: String, completion: @escaping (String) -> Void) {
        REF_POST_COMMENT.child(postId).observe(.childAdded, with: { (DataSnapshot) in
            completion(DataSnapshot.key)
        })
    }
    
    func sendDataToDatabase(postId: String, commentId: String, onError: @escaping (_ errorMessage: String) -> Void, onSuccess: @escaping () -> Void) {
        let newPostCommntRef = Api.post_comment.REF_POST_COMMENT.child(postId).child(commentId)
        newPostCommntRef.setValue(true) { (Error, DatabaseReference) in
            if Error != nil {
                onError(Error!.localizedDescription)
            }
            onSuccess()
        }
    }
}
