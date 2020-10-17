//
//  MenuButton.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 1/17/19.
//  Copyright © 2019 Luke Deratzou. All rights reserved.
//

import UIKit

class MenuButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(displayP3Red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
        let fontSize: CGFloat = Helper.GET_FONT_SIZE()
        self.titleLabel?.font = UIFont(name: "Menlo", size: fontSize) //size can depend on iphone size
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        //self.frame.size = CGSize(width: 170, height: 28) //base it on user device
        self.setTitleColor(UIColor.black, for: .normal)
        self.tintColor = UIColor.gray
        //shadow?
        //add arrow?
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(displayP3Red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
        let fontSize: CGFloat = Helper.GET_FONT_SIZE()
        self.titleLabel?.font = UIFont(name: "Menlo", size: fontSize) //size can depend on iphone size
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        //self.frame.size = CGSize(width: 170, height: 28) //base it on user device
        self.setTitleColor(UIColor.black, for: .normal)
        self.tintColor = UIColor.gray
        //shadow?
        //add arrow?
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
