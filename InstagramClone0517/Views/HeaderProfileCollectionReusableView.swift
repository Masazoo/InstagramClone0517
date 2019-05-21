//
//  HeaderProfileCollectionReusableView.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    
    var user: UserModel? {
        didSet {
            setupUserInfo()
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
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
    }
    
}
