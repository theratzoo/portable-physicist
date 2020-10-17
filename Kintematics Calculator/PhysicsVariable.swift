//
//  PhysicsVariable.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/13/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//
//Can always make different classes based on vectors versus scalars but too tedious to do it based on equation souly

//Add a feature of isVector which can be used to find out if it will show direction options for the variable or not...


//23.7 means unset
import Foundation

class PhysicsVariable {
    private var vName: String
    private var vValue: Double
    private var isitValueSet: Bool
    private var unknown: Unknown
    private var units: String = ""
    
    private var uConvertedValue : Double = 23.7
    private var isUnConvertedValueSet: Bool = false
    private var uConvertedUnits: String!
    private var uConvertedRoundedValue: String = ""
    
    private var unroundedAnswer: Double = 0 //prolly delete
    private var varNum:Int = -1
    private var isItScalar: Bool = false 
    private var roundedAnswer: String = "" //has to be string...
    
    private var problemValue: String = "" //this is for quiz/practice problem- not rounded (too much, some cases it will be rounded), but formatted to look nice
    private var mcProblemValue: String = ""
    
    private static var UNSET_VALUE: Double = 23.7
    
    init(name: String) {
        self.vName = name
        self.vValue = 23.7
        isitValueSet = false
        unknown = Unknown(isUnknown: false)
        fixName()
        defaultUnits()
        setUpScalar()
    }
    
    init(name: String, value: Double) {
        self.vName = name
        self.vValue = value
        isitValueSet = true
        unknown = Unknown(isUnknown: false)
        fixName()
        defaultUnits()
        setUpScalar()
    }
    
    var unit: String {
        get {
            return self.units
        }
        set {
            self.units = newValue
        }
    }
    
    var name: String {
        get {
            return self.vName
        } set {
            self.vName = newValue
        }
    }
    
    var value: Double {
        get {
            return self.vValue
        } set {
            self.vValue = newValue
            isValueSet = true
        }
    }
    
    var isValueSet: Bool {
        get {
            return self.isitValueSet
        } set {
            self.isitValueSet = newValue
        }
    }
    
    var isUnknown: Bool {
        get {
            return self.unknown.isUnknown
        } set {
            self.unknown.isUnknown = newValue
        }
    }
    
    var unknownNumber : Int {
        get {
            return self.unknown.getSetUNumb
        } set {
            self.unknown.getSetUNumb = newValue
        }
    }
    
    var unknownEq: String {
        get {
            return self.unknown.getSetUEquation
        } set {
            self.unknown.getSetUEquation = newValue
        }
    }
    
    var unConvertedValue: Double {
        get {
            return self.uConvertedValue
        } set {
            self.uConvertedValue = newValue
            isUnConvertedValueSet = true
        }
    }
    
    func setUpScalar() {
        switch vName {
        case "m":
            isItScalar = true
        case "t":
            isItScalar = true
        case "m1":
            isItScalar = true
        case "m2":
            isItScalar = true
        case "k":
            isItScalar = true
        case "r":
            isItScalar = true
        default:
            isItScalar = false
        }
    }
    
    var isScalar: Bool {
        get {
            return self.isItScalar
        } set {
            self.isItScalar = newValue
        }
    }
    
    func equals(_ pV: PhysicsVariable) { //W I P
        self.vValue = pV.value
        self.vName = pV.name
        self.isUnknown = pV.isUnknown
        self.units = pV.unit
    }
    
    //THIS IS FOR SHOW WORK
    //E.: this seems useless
    var varNumber: Int {
        get {
            return self.varNum
        } set {
            self.varNum = newValue
        }
    }
    
    func getRoundedAns() -> String {
        let v: String = "\(vValue)"
        if UserDefaults.standard.getEnableSigFigs() {
            self.roundedAnswer = SigFigCalculator.init(number: v).getRoundedAnswer()
        } else {
            self.roundedAnswer = RoundByDecimals.ROUND_BY_DECIMALS(value: v)
        }
        
        return self.roundedAnswer
    }
    
    func getUnConvertedRoundedAns() -> String {
        let v: String = "\(uConvertedValue)"
        if UserDefaults.standard.getEnableSigFigs() {
            self.uConvertedRoundedValue = SigFigCalculator.init(number: v).getRoundedAnswer()
        } else {
            self.uConvertedRoundedValue = RoundByDecimals.ROUND_BY_DECIMALS(value: v)
        }
        
        return self.uConvertedRoundedValue
    }
    //bottom two functions: Need to fix them so that they can be formatted for decimal or sig fig depending on UserDefaults
    func getProblemValue() -> String {
        if isUnConvertedValueSet {
            problemValue = "\(uConvertedValue)"
        } else {
            problemValue = "\(vValue)"
        }
        setUpProblemValue()
        if !problemValue.contains("✕") {
            
        }
        return problemValue
    }
    //????? is this even needed....
    private func setUpProblemValue() {
        if problemValue.contains("e") && problemValue.contains("+") {
            var ans: String = ""
            var hasReachedE: Bool = false
            var pow: String = ""
            for i in 0...problemValue.count - 1 {
                let index = problemValue.index(problemValue.startIndex, offsetBy: i)
                if problemValue[index] == "e" {
                    hasReachedE = true
                } else if problemValue[index] == "+"  {
                    ans += " ✕ 10^"
                } else if hasReachedE {
                    pow.append(problemValue[index])
                } else {
                    ans.append(problemValue[index])
                }
            }
            ans += pow
            problemValue = Helper.exponentize(str: ans)
            return
        }
        if problemValue.count < 8 {
            return
        }
        let isNegative: Bool = problemValue.first == "-"
        if isNegative {
            problemValue.removeFirst()
        }
        let end = problemValue.count - 1
        var preDecimalCount = 0
        var postDecimalCount = 0
        var hasReachedDecimal = false
        for i in 0...end {
            let index = problemValue.index(problemValue.startIndex, offsetBy: i)
            if problemValue[index] == "." {
                hasReachedDecimal = true
            } else if !hasReachedDecimal {
                preDecimalCount += 1
            } else {
                postDecimalCount += 1
            }
        }
        if postDecimalCount > preDecimalCount {
            while problemValue.count > 8 {
                //repeating decimal... Swift auto does decimals to the 10^-5 in scientific notation
                problemValue.removeLast()
            }
            return
        }
        var tempString: String = ""
        if isNegative {
            tempString += "-"
        }
        for i in 0...3 {
            if i == 0 {
                tempString += String(problemValue.first!)
            } else if i == 1 {
                tempString += "."
            } else {
                tempString.append(problemValue[problemValue.index(problemValue.startIndex, offsetBy: i-1)])
            }
        }
        let n: Int = preDecimalCount - 1
        tempString += " ✕ 10^\(n)"
        problemValue = Helper.exponentize(str: tempString)
        
    }
    
    var mcAnswer: String {
        get {
            return mcProblemValue
        } set {
            mcProblemValue = newValue
        }
    }
    
    func intValue() -> Int {
        return Int(vValue)
    }
    
    func defaultUnits() {
        switch true {
        case vName == "a":
            self.units = Helper.exponentize(str: "meters/second^2")
        case vName == "fV" || vName == "iV" || vName == "v" :
            self.units = "meters/second"
        case vName == "d" || vName == "r" :
            self.units = "meters"
        case vName == "f" || vName == "fG" :
            self.units = "Newtons"
        case vName == "m" || vName == "m1" || vName == "m2" :
            self.units = "kilograms"
        case vName == "k":
            self.units = "Joules"
        case vName == "t":
            self.units = "seconds"
        default:
            self.units = ""
            print("error w/ setting up default units")
            print(vName)
        }
    }
    
    
    //i don't think any of the reset funcs are needed... just an fyi for something to delete later...
    func totalReset() {
        resetUnits()
        resetValue()
        resetUnConverted()
        resetUnknown()
        unroundedAnswer = 0
    }
    

    
    func resetUnConverted() {
        self.uConvertedValue = 23.7
        self.uConvertedUnits = ""
    }
    
    func resetValue() {
        self.vValue = 23.7
        isValueSet = false
    }
    
    func resetUnknown() {
        self.unknown.fullReset()
    }
    
    func resetUnits() {
        self.units = ""
    }
    
    func getSIUnits() -> String {
        switch true {
        case vName == "m" || vName == "m1" || vName == "m2":
            return "kilograms"
        case vName == "v" || vName == "fV" || vName == "iV":
            return "meters/second"
        case vName == "f" || vName == "fG":
            return "Newtons"
        case vName == "d" || vName == "r":
            return "meters"
        case vName == "t":
            return "seconds"
        case vName == "a":
            return Helper.exponentize(str: "meters/second^2")
        case vName == "k":
            return "Joules"
        default:
            print("error w/ getSIUnits function")
            return "ERROR"
        }
    }
    
    static func FIX_NAME(varName: String) -> String {
        let temp = varName.lowercased()
        switch temp {
        case "mass":
            return "m"
        case "acceleration":
            return "a"
        case "final velocity":
            return "fV"
        case "initial velocity":
            return "iV"
        case "time":
            return "t"
        case "displacement":
            return "d"
        case "force":
            return "f"
        case "kinetic energy":
            return "k"
        case "velocity":
            return "v"
        case "mass one":
            return "m1"
        case "mass two":
            return "m2"
        case "gravitational force":
            return "fG"
        case "separation (r)":
            return "r"
        case "grav. force":
            return "fG"
        case "mass 1":
            return "m1"
        case "mass 2":
            return "m2"
        case "separation":
            return "r"
        default:
            print("error- could not fix name")
            return "ERROR"
        }
    }
    
    private func fixName() {
        switch vName {
        case "Mass":
            vName = "m"
        case "Acceleration":
            vName = "a"
        case "Final Velocity":
            vName = "fV"
        case "Initial Velocity":
            vName = "iV"
        case "Time":
            vName = "t"
        case "Displacement":
            vName = "d"
        case "Force":
            vName = "f"
        case "Kinetic Energy":
            vName = "k"
        case "Velocity":
            vName = "v"
        case "Mass One":
            vName = "m1"
        case "Mass Two":
            vName = "m2"
        case "Gravitational Force":
            vName = "fG"
        case "Separation (r)":
            vName = "r"
        default:
            break
        }
    }
    
    func getRealName() -> String {
        switch vName {
        case "a":
            return "Acceleration"
        case "fV":
            return "Final Velocity"
        case "iV":
            return "Initial Velocity"
        case "t":
            return "Time"
        case "d":
            return "Displacement"
        case "f":
            return "Force"
        case "k":
            return "Kinetic Energy"
        case "v":
            return "Velocity"
        case "m":
            return "Mass"
        case "m1":
            return "Mass One"
        case "m2":
            return "Mass Two"
        case "fG":
            return "Gravitational Force"
        case "r":
            return "Separation (r)"
        default:
            print("error w/ getting real name")
            return "error"
        }
    }
    
}
