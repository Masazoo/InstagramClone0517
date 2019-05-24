//
//  NotificationApi.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/24.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class NotificationApi {
    
    var REF_NOTIFICATION = Database.database().reference().child("notification")
    
    
    // 入力が一回 (like, follow)
    func NotificationToDatabase(uid: String, objectId: String, type: String) {
        let newNotificationRef = REF_NOTIFICATION.child(uid).child("\(type)-\(uid)-\(Api.User.CURRENT_USER!.uid)")
        newNotificationRef.setValue(["from": Api.User.CURRENT_USER?.uid, "objectId": objectId, "type": type])
    }
    
    // 入力が複数回 (comment)
    func commentNotificationToDatabase(uid: String, objectId: String) {
        let newNotificationId = REF_NOTIFICATION.child(uid).childByAutoId().key
        let newNotificationRef = REF_NOTIFICATION.child(uid).child(newNotificationId!)
        newNotificationRef.setValue(["from": Api.User.CURRENT_USER?.uid, "objectId": objectId, "type": "comment"])
    }
    
    // 削除
    func NotificationRemove(uid: String, type: String) {
        let notificationRef = REF_NOTIFICATION.child(uid).child("\(type)-\(uid)-\(Api.User.CURRENT_USER!.uid)")
        notificationRef.setValue(NSNull())
    }
    
    
    func observeNotification(completion: @escaping (Notification) -> Void) {
        REF_NOTIFICATION.child(Api.User.CURRENT_USER!.uid).observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newNoti = Notification.transformNotification(dict: dict, key: DataSnapshot.key)
                completion(newNoti)
            }
        })
    }
    
    
}
