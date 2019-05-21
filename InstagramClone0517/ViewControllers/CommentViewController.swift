//
//  CommentViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var postId = ""
    var comments = [Comment]()
    var users = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        loadComments()
    }
    
    
    func loadComments() {
        Api.post_comment.observePostComments(postId: self.postId) { (commentId) in
            Api.Comment.observeComment(commentId: commentId, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.insert(comment, at: 0)
                    self.tableView.reloadData()
                })
            })
        }
    }
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.users.insert(user, at: 0)
            completed()
        }
    }
    
    

    @IBAction func sendBtn_TouchUpInside(_ sender: Any) {
        Api.Comment.sendCommentInfo(commentText: self.commentTextField.text!) { (commentId) in
            Api.post_comment.sendDataToDatabase(postId: self.postId, commentId: commentId, onError: { (error) in
                ProgressHUD.showError(error)
            }, onSuccess: {
                ProgressHUD.showSuccess("投稿が成功しました")
            })
        }
    }
    
    
}
extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
}
