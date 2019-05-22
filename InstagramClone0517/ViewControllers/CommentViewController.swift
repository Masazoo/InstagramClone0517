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
    @IBOutlet weak var constraintToButtom: NSLayoutConstraint!
    
    var postId = ""
    var comments = [Comment]()
    var users = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        handleTextField()
        sendButtonDefault()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // textFieldとkeyboardの設定
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToButtom.constant = -(keyboardFrame!.height)
            self.view.layoutIfNeeded()
        }
    }
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToButtom.constant = 0
            self.view.layoutIfNeeded()
        }
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
    
    // textFieldとbutton周りの設定
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            sendButtonDefault()
            return
        }
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.isEnabled = true
    }
    
    // sendButtonのデフォルト設定
    func sendButtonDefault() {
        sendBtn.setTitleColor(.gray, for: .normal)
        sendBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommentToProfileUserSegue" {
            let userId = sender as! String
            let ProfileUserVC = segue.destination as! ProfileUserViewController
            ProfileUserVC.userId = userId
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
        cell.delegate = self
        return cell
    }
}
extension CommentViewController: CommentTableViewCellDelegate {
    func goToProfileUserSegue(userId: String) {
        self.performSegue(withIdentifier: "CommentToProfileUserSegue", sender: userId)
    }
    
}
