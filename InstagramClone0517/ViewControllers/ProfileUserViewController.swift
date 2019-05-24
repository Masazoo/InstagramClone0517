//
//  ProfileUserViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/22.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var userId = ""
    var user: UserModel!
    var posts = [Post]()
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        fetchPosts()
    }
    

    func fetchUser() {
        Api.User.observeUser(uid: self.userId) { (user) in
            Api.Follow.isFollowing(uid: self.userId, completion: { (value) in
                user.isFollowing = value
                self.navigationItem.title = user.username
                self.user = user
                self.collectionView.reloadData()
            })
        }
    }
    
    func fetchPosts() {
        Api.MyPosts.observeMyPosts(userId: self.userId) { (postId) in
            Api.Post.observePost(postId: postId, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUserToSettingSegue" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
        
        if segue.identifier == "ProfileUserToDetailSegue" {
            let postId = sender as! String
            let DetailVC = segue.destination as! DetailViewController
            DetailVC.postId = postId
        }
    }
    
}
extension ProfileUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerCell.user = user
            headerCell.delegate = self.delegate
            headerCell.delegate2 = self
        }
        return headerCell
    }
}
extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 3, height: collectionView.frame.size.width / 3 - 3)
    }
}
extension ProfileUserViewController: HeaderProfileCollectionReusableViewDelegateSwiching {
    func goToSettingVC() {
        self.performSegue(withIdentifier: "ProfileUserToSettingSegue", sender: nil)
    }
}
extension ProfileUserViewController: SettingTableViewControllerDelegate {
    func updateUserInfo() {
        self.fetchUser()
    }
}
extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        self.performSegue(withIdentifier: "ProfileUserToDetailSegue", sender: postId)
    }
}
