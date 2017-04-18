//
//  PostCell.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 13/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post:Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post:Post, img:UIImage? = nil)
    {
        self.post = post
        captionTextView.text = post.caption
        likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data,error) in
                if error != nil {
                    print("Unable to download image from storage")
                } else {
                    print("successfully downloaded image from storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString) 
                        }
                    }
                }
            })
        }
    }
}
