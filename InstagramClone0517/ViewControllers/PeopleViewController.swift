//
//  PeopleViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/22.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        loadUsers()
    }
    
    func loadUsers() {
        Api.User.observeUsers { (user) in
            Api.Follow.isFollowing(uid: user.uid!, completion: { (value) in
                user.isFollowing = value
                guard Api.User.CURRENT_USER?.uid != user.uid else {
                    return
                }
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PeopleToProfileUserSegue" {
            let userId = sender as! String
            let profileUserVC = segue.destination as! ProfileUserViewController
            profileUserVC.userId = userId
            profileUserVC.delegate = self
        }
    }
    
    

}
extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension PeopleViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "PeopleToProfileUserSegue", sender: userId)
    }
}
extension PeopleViewController: HeaderProfileCollectionReusableViewDelegate {
    func updateFollwoBtn(user: UserModel) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
    
}
