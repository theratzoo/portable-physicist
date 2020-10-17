//
//  ForceVariable.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/13/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class ForceVariable: PhysicsVariable {
    private var theDirection: String = "none"
    
    override init(name: String) {
        super.init(name: name)
    }
    
    override init(name: String, value: Double) {
        super.init(name: name, value: value)
    }
    
   /* var direction: String {
        get {
            return self.theDirection
        } set {
            self.theDirection = newValue
        }
    }*/

    override func resetValue() {
        super.resetValue()
        theDirection = "none"
    }
    
    func fullReset() {
        super.resetValue()
        super.resetUnknown()
        super.resetUnits()
    }
    
}
