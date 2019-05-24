//
//  DetailViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/23.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        fetchPost()
    }
    

    func fetchPost() {
        Api.Post.observePost(postId: postId) { (post) in
            self.fetchUser(uid: post.uid!, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.user = user
            completed()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToCommentSegue" {
            let postId = sender as! String
            let commentVC = segue.destination as! CommentViewController
            commentVC.postId = postId
        }
        
        if segue.identifier == "DetailToProfileUserSegue" {
            let userId = sender as! String
            let ProfileUserVC = segue.destination as! ProfileUserViewController
            ProfileUserVC.userId = userId
        }
    }
}
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.post = self.post
        cell.user = self.user
        cell.delegate = self
        return cell
    }
}
extension DetailViewController: HomeTableViewCellDelegate {
    
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "DetailToCommentSegue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "DetailToProfileUserSegue", sender: userId)
    }
}
