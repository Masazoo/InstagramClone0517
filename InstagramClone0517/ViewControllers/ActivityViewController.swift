//
//  ActivityViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var fromUsers = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        loadNotification()
    }
    
    func loadNotification() {
        Api.Notification.observeNotification { (notification) in
            self.fetchUser(from: notification.from!, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        }
    }
    func fetchUser(from uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.fromUsers.insert(user, at: 0)
            completed()
        }
    }

   

}
extension ActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let notification = notifications[indexPath.row]
        let fromUser = fromUsers[indexPath.row]
        cell.notification = notification
        cell.fromUser = fromUser
        return cell
    }
}
