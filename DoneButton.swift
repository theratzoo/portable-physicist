//
//  DoneButton.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 1/25/19.
//  Copyright © 2019 Luke Deratzou. All rights reserved.
//

import UIKit

class DoneButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let fontSize: CGFloat = Helper.GET_DONE_FONT_SIZE()
        self.titleLabel?.font = UIFont(name: "Menlo", size: fontSize) //size can depend on iphone size
        self.frame.size = CGSize(width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT())
        self.setTitle("Done", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let fontSize: CGFloat = Helper.GET_DONE_FONT_SIZE()
        self.titleLabel?.font = UIFont(name: "Menlo", size: fontSize) //size can depend on iphone size
        
        self.frame.size = CGSize(width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()) //these two Helper funcs can be moved to this class or at least this file instead of Helper...
        self.setTitle("Done", for: .normal)
    }

}
