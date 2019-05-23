//
//  HeaderProfileCollectionReusableView.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollwoBtn(user: UserModel)
}
protocol HeaderProfileCollectionReusableViewDelegateSwiching {
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwiching?
    
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
        
        if Api.User.CURRENT_USER?.uid == user?.uid {
            followBtn.setTitle("編集する", for: .normal)
            followBtn.addTarget(self, action: #selector(self.goToSetting), for: .touchUpInside)
        }else{
            updateFollowBtn()
        }
    }
    
    func updateFollowBtn() {
        if user!.isFollowing! {
            configureUnFollowAction()
        }else{
            configureFollowAction()
        }
    }
    
    func configureFollowAction() {
        followBtn.setTitle("フォローする", for: .normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
    }
    
    func configureUnFollowAction() {
        followBtn.setTitle("フォロー中", for: .normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    func followAction() {
        if !user!.isFollowing! {
            Api.Follow.followAction(uid: user!.uid!)
            configureUnFollowAction()
            user?.isFollowing = true
            delegate?.updateFollwoBtn(user: user!)
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! {
            Api.Follow.unFollowAction(uid: user!.uid!)
            configureFollowAction()
            user?.isFollowing = false
            delegate?.updateFollwoBtn(user: user!)
        }
    }
    
    func goToSetting() {
        delegate2?.goToSettingVC()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
    }
    
}
