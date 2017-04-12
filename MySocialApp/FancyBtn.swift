//
//  FancyBtn.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 12/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
@IBDesignable
class FancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 2.0
    }
}
