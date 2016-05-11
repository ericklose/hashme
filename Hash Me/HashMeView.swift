//
//  HashMeView.swift
//  Hash Me
//
//  Created by Eric Klose on 5/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HashMeView: UIView {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
}