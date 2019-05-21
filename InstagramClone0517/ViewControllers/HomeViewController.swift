//
//  HomeViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        loadPost()
    }
    
    
    func loadPost() {
        Api.Post.obsesrvePosts { (newPost) in
            self.fetchUser(uid: newPost.uid!, completed: {
                self.posts.insert(newPost, at: 0)
                self.tableView.reloadData()
            })
        }
    }
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.users.insert(user, at: 0)
            completed()
        }
    }
    
    
    

    @IBAction func signOutBtn_TouchUpInside(_ sender: Any) {
        AuthService.signOut(onSuccess: {
            let stroyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = stroyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCommentSegue" {
            let postId = sender as! String
            let commentVC = segue.destination as! CommentViewController
            commentVC.postId = postId
        }
    }

}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension HomeViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "HomeToCommentSegue", sender: postId)
    }
}
