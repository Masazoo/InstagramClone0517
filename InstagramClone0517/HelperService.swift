//
//  HelperService.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/18.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class HelperService {
    
    static func uploadDataToServe(captionText: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (URL, Error) in
                let profileImageUrl = URL?.absoluteString
                setUserInfo(captionText: captionText, profileImageUrl: profileImageUrl!, onSuccess: onSuccess)
            })
        })
    }
    static func setUserInfo(captionText: String, profileImageUrl: String, onSuccess: @escaping () -> Void) {
        let postsRef = Database.database().reference().child("posts")
        let newPostId = postsRef.childByAutoId().key
        let newUserRef = postsRef.child(newPostId!)
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        newUserRef.setValue(["captionText": captionText, "postImageUrl": profileImageUrl, "uid": currentUserId])
        ProgressHUD.showSuccess("投稿されました")
        onSuccess()
    }
}
