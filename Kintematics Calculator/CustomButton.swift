//
//  CustomButton.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 7/23/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class CustomButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
}
