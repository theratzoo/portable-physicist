//
//  File.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 3/25/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class KinematicsVariable: PhysicsVariable {
    private static var VALUE_UNSET : Double = 23.7
    private static var UNSET : Int = -1
    private static var PAGE_ONE : Int = 1
    private var unroundedAnswer : Double = 0
    private var theVarNumb : Int = -1
    //var isValueUnset : Bool = true BAD ONE
    
    
    //below var is the correct one that will be used for now on
    //var isValueSet : Bool = false //only used for segue
    
    override init(name: String) {
        super.init(name: name)
    }
    
    override init(name: String, value: Double) {
        super.init(name: name, value: value)
    }
    
    /*init(name: String) {
        self.name = name
        self.value = 23.7
        self.varNumb = -1
        self.unknown = Unknown(isUnknown: false)
    }
    init(name: String, value: Double) {
        
        self.name = vName
        self.value = value
        self.varNumb = -1
        isValueUnset = false
        self.unknown = Unknown(isUnknown: false)
    }*/
    
    //whether its first or 2nd unknown... used for show work feature
    /*var setUnknownNumb : Int {
        get {
            return self.unknownNumb
        } set {
            self.unknownNumb = newValue
        }
    }*/
    
    func itIsUnknown() {
        super.isUnknown = true
    }
    
    //wip.. actually just change these to get/set
    
    
    /*
    var setValue : Double {
        get {
            return self.value
        }
        set {
            self.value = newValue
            isValueUnset = false
            isValueSet = true
            if unConvertedValue == 0 {
                self.unConvertedValue = newValue
            }
        }
    } */
    /*
    var getValue : Double {
        get {
            return self.value
        } set {
            self.value = newValue
            isValueUnset = false
            isValueSet = true
        }
    }*/
    
    //for its page
    var varNumb : Int {
        get {
            return self.theVarNumb
        } set {
            self.theVarNumb = newValue
        }
    }
    
    /*var setOrGetUnknown : Bool {
        get {
            return self.isUnknown
        } set {
            self.isUnknown = newValue
        }
    }*/
    
    func fullReset() {
        super.resetValue()
        super.resetUnknown()
        super.resetUnits()
        super.resetUnConverted()
        self.theVarNumb = -1
        
    }
    //for round func... can also have parameter for # of sig figs to round by
    func roundThisShit() { //might not work
        super.value = round(100 * super.value) / 100
    }
    
    /*func intValue() -> Int {
        let a: Int = Int(super.value)
        return a
    }*/
    
    
    /*
    var setUnconvertedValue : Double {
        get {
            return self.unConvertedValue
        } set {
            self.unConvertedValue = round(10000 * newValue) / 10000
        }
    }
    
    var getUnconvertedValue : Double {
        get {
            return self.unConvertedValue
        } set {
            self.unConvertedValue = newValue
        }
    } */
    //depricated
    var unroundedValueSetOrGet : Double {
        get {
            return self.unroundedAnswer
        }
        set {
            self.unroundedAnswer = newValue
        }
    }
}
