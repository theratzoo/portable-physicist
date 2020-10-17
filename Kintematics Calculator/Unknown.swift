//
//  Unknown.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 4/30/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation
//Depricated???? yeah probably
class Unknown {
    private static var UNSET_UNKNOWN_NUMBER : Int = -1
    private static var UNSET_UNKNOWN_EQUATION : String = "Z"
    var unknownNumber : Int
    var unknownEquation: String
    var isUnknown : Bool
    
    init(isUnknown: Bool) {
        self.isUnknown = isUnknown
        self.unknownNumber = -1
        self.unknownEquation = "Z"
    }
    
    init(isUnknown: Bool, unknownNumber: Int, unknownEquation: String) {
        self.isUnknown = isUnknown
        self.unknownNumber = unknownNumber
        self.unknownEquation = unknownEquation
    }
    
    func fullReset() {
        self.unknownNumber = -1
        self.unknownEquation = "Z"
        self.isUnknown = false
    }
    
    var getSetUNumb : Int {
        get {
            return self.unknownNumber
        } set {
            self.unknownNumber = newValue
        }
    }
    var getSetUEquation : String {
        get {
            return self.unknownEquation
        } set {
            self.unknownEquation = newValue
        }
    }
}
