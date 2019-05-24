//
//  ActivityTableViewCell.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/24.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage

class ActivityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var notification: Notification? {
        didSet {
            updateView()
        }
    }
    
    var fromUser: UserModel? {
        didSet {
            setUserInfo()
        }
    }
    
    func updateView() {
        switch notification?.type {
        case "like":
            descriptionLabel.text = "いいね！しました"
            Api.Post.observePost(postId: notification!.objectId!) { (post) in
                if let photoImageUrlString = post.postImageUrl {
                    let photoImageUrl = URL(string: photoImageUrlString)
                    self.photoImageView.sd_setImage(with: photoImageUrl)
                }
            }
            
        case "comment":
            descriptionLabel.text = "コメントしました"
            Api.Post.observePost(postId: notification!.objectId!) { (post) in
                if let photoImageUrlString = post.postImageUrl {
                    let photoImageUrl = URL(string: photoImageUrlString)
                    self.photoImageView.sd_setImage(with: photoImageUrl)
                }
            }
            
        case "follow":
            descriptionLabel.text = "あなたをフォローしました"
            
        default:
            print("default")
        }
    }
    
    func setUserInfo() {
        nameLabel.text = fromUser?.username
        if let profileUrlString = fromUser?.profileImageUrl {
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        
        photoImageView.layer.cornerRadius = 18
        photoImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
