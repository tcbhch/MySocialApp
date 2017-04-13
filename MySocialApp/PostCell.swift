//
//  PostCell.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 13/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit

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
    
    func configureCell(post:Post)
    {
        self.post = post
        captionTextView.text = post.caption
        likesLbl.text = "\(post.likes)"
        
    }
    
    

}
