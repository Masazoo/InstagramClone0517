//
//  ProfileViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/17.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: UserModel!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        fetchPost()
    }
    

    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
            self.navigationItem.title = user.username
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func fetchPost() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        Api.MyPosts.observeMyPosts(userId: currentUser.uid) { (postId) in
            Api.Post.observePost(postId: postId, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }

}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerCell.user = user
        }
        return headerCell
    }
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
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
