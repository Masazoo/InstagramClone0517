//
//  CommentTableViewCell.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/20.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
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
        commentLabel.text = comment?.commentText
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
