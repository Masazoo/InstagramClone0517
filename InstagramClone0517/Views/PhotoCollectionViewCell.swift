//
//  PhotoCollectionViewCell.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.postImageUrl {
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
    }
    
    func photo_TouchUpInside() {
        delegate?.goToDetailVC(postId: post!.postId!)
    }
}
