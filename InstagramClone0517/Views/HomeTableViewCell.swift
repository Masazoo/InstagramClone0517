//
//  HomeTableViewCell.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate: HomeTableViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: UserModel? {
        didSet {
            setupUserInfo()
        }
    }
    
    
    
    func updateView() {
        captionLabel.text = post?.captionText
        if let photoUrlString = post?.postImageUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let profileUrlString = user?.profileImageUrl {
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        
        let tapGestureForCommentImageView = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGestureForCommentImageView)
        commentImageView.isUserInteractionEnabled = true
    }
    
    func commentImageView_TouchUpInside() {
        delegate?.goToCommentVC(postId: post!.postId!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
