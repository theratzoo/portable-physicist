//
//  CustomButton.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 7/23/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.clear : UIColor.clear
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
