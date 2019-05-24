//
//  Notification.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/24.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
class Notification {
    
    var from: String?
    var objectId: String?
    var type: String?
    var notificationId: String?
    
}
extension Notification {
    static func transformNotification(dict: [String: Any], key: String) -> Notification {
        let noti = Notification()
        noti.from = dict["from"] as? String
        noti.objectId = dict["objectId"] as? String
        noti.type = dict["type"] as? String
        noti.notificationId = key
        
        return noti
    }
}
