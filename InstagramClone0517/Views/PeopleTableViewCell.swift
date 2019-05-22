//
//  PeopleTableViewCell.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/22.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate: PeopleTableViewCellDelegate?
    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user?.username
        if let profileUrlString = user?.profileImageUrl {
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
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
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! {
            Api.Follow.unFollowAction(uid: user!.uid!)
            configureFollowAction()
            user?.isFollowing = false
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    func nameLabel_TouchUpInside() {
        delegate?.goToProfileUserVC(userId: user!.uid!)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
