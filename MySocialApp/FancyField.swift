//
//  FancyField.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 12/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
@IBDesignable
class FancyField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
