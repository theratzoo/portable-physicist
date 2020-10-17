//
//  HelperStuff.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 6/13/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//
// Can also include GET_LIST_OF_VARS here: parameter is the eq, and switch/for finds out which it is


import Foundation

import UIKit

class Helper {
    private static var LIST_OF_EQS:[String] = ["kinematics", "forces", "kinetic energy", "gravitational force"]
    static var MODE = "Normal"
    static var PREHELP_TOPASS = "emptyt"
    static var LIST_OF_UNIT_LISTS = [LIST_OF_UNITS_FOR_PICKER.VELOCITY_UNITS, LIST_OF_UNITS_FOR_PICKER.ACCELERATION_UNITS, LIST_OF_UNITS_FOR_PICKER.DISTANCE_UNITS, LIST_OF_UNITS_FOR_PICKER.TIME_UNITS, LIST_OF_UNITS_FOR_PICKER.MASS_UNITS, LIST_OF_UNITS_FOR_PICKER.FORCE_UNITS, LIST_OF_UNITS_FOR_PICKER.ENERGY_UNITS]

    
    
    static func INITIALIZE_VALUES(listOfVars: [PhysicsVariable], varName: String) -> Double  {
        for i in listOfVars {
            if i.name == varName {
                return i.value
            }
        }
        print("ERROR- COULD NOT PROPERLY INITALIZE VALUE")
        return 23.7
    }
    
    static func IS_IPHONE_X() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X, Xs")
                return true
            case 2688:
                print("iPhone Xs Max")
                return true
            case 1792:
                print("iPhone Xr")
                return true
            default:
                print("unknown")
            }
        }
        return false
    }
    static func GET_LIST_OF_EQS()-> [String] {
        return LIST_OF_EQS
    }
    //gets list of eqs... but formats it for settings pickerview
    //instaed of "problem type" can say "physics concept"
    static func GET_LIST_OF_EQS_FOR_SETTINGS() -> [String] {
        let list = LIST_OF_EQS
        var newList:[String] = [String]()
        newList.append("Select physics concept...")
        for i in list {
            var j = i
            newList.append(j)
        }
        newList.append("All (random)")
        return newList
    }
    
    static func GET_LIST_OF_VARS(eq: String) -> [String] {
        switch eq {
        case "kinematics":
            return ["Initial Velocity", "Final Velocity", "Acceleration", "Time", "Displacement"]
        case "forces":
            return ["Force", "Mass", "Acceleration"]
        case "kinetic energy":
            return ["Kinetic Energy", "Mass", "Velocity"]
        case "gravitational force":
            return ["Mass One", "Mass Two", "Separation (r)", "Gravitational Force"]
        default:
            print("ERROR")
        }
        return LIST_OF_EQS
    }
    
    //Put in a variable name (name from label) and it returns true if its a vector and false if it's a scalar
    static func IS_VECTOR(varName: String) -> Bool {
        switch varName {
        case "Mass":
            return false
        case "Mass One":
            return false
        case "Mass Two":
            return false
        case "Time":
            return false
        default:
            return true
        }
        
    }
    
    static func GET_RANDOM_MALE_NAME() -> String {
        let listOfNames: [String] = ["Bob", "Jerry", "Eric", "Nic", "Mark", "Thomas", "Harry", "Jacob", "Simon", "Justin", "Dan", "Michael", "Adam", "Aaron", "Steve", "Tom"]
        return listOfNames[Int(arc4random_uniform(UInt32(listOfNames.count-1)))]
    }
    
    
    static func GET_LIST_OF_UNITS(varName: String) -> [String] {
        switch true {
        case varName.contains("Velocity") || varName == "v" || varName == "fV" || varName == "iV":
            return LIST_OF_UNITS.VELOCITY_UNITS
        case varName.contains("Mass") || varName == "m" || varName == "m1" || varName == "m2":
            return LIST_OF_UNITS.MASS_UNITS
        case varName == "Acceleration" || varName == "a":
            return LIST_OF_UNITS.ACCELERATION_UNITS
        case varName.contains("Time") || varName == "t":
            return LIST_OF_UNITS.TIME_UNITS
        case varName.contains("Energy") || varName == "k":
            return LIST_OF_UNITS.ENERGY_UNITS
        case varName.contains("Force") || varName == "f" || varName == "fG":
            return LIST_OF_UNITS.FORCE_UNITS
        case varName.contains("Displacement") || varName.contains("Separation") || varName == "d" || varName == "r":
            return LIST_OF_UNITS.DISTANCE_UNITS
        default:
            print("E R R O R")
            return [""]
        }
    }
    
    static func CONVERT_UNITS(from: String, to:String, value:Double) -> Double {
        let listOfUnitFactors = GET_UNIT_FACTOR_LIST()
        var fromFactor: Double = 0
        var toFactor: Double = 0
        for i in listOfUnitFactors {
            if i.name.lowercased() == from.lowercased() {
                fromFactor = i.value
            }
            if i.name.lowercased() == to.lowercased() {
                toFactor = i.value
            }
        }
        let ultimateFactor: Double = fromFactor / toFactor
        return value * ultimateFactor
    }
    
    static func GET_UNIT_FACTOR_LIST() -> [UnitFactors] {
        var listOfUnitFactors: [UnitFactors] = [UnitFactors]()
        listOfUnitFactors.append(UnitFactors.init("meters/second", 1))
        listOfUnitFactors.append(UnitFactors.init("miles/hour", 0.44704))
        listOfUnitFactors.append(UnitFactors.init("meters/minute", 0.01666666666))
        listOfUnitFactors.append(UnitFactors.init("centimeters/second", 0.01))
        listOfUnitFactors.append(UnitFactors.init("feet/second", 0.3048))
        listOfUnitFactors.append(UnitFactors.init("kilometers/hour", 0.277778))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "meters/second^2"), 1))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "meters/minute^2"), 0.000277777777))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "miles/hour^2"), 0.00012417777777))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "centimeters/second^2"), 0.001))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "feet/second^2"), 0.3048))
        listOfUnitFactors.append(UnitFactors.init(Helper.exponentize(str: "kilometers/hour^2"), 0.00007716049383))
        listOfUnitFactors.append(UnitFactors.init("meters", 1))
        listOfUnitFactors.append(UnitFactors.init("miles", 1609.344))
        listOfUnitFactors.append(UnitFactors.init("feet", 0.3048))
        listOfUnitFactors.append(UnitFactors.init("centimeters", 0.01))
        listOfUnitFactors.append(UnitFactors.init("milimeters", 0.001))
        listOfUnitFactors.append(UnitFactors.init("kilometers", 1000))
        listOfUnitFactors.append(UnitFactors.init("yards", 0.9144))
        listOfUnitFactors.append(UnitFactors.init("inches", 0.0254))
        listOfUnitFactors.append(UnitFactors.init("nanometers", 0.000000001))
        listOfUnitFactors.append(UnitFactors.init("micrometers", 0.000001))
        listOfUnitFactors.append(UnitFactors.init("seconds", 1))
        listOfUnitFactors.append(UnitFactors.init("hours", 3600))
        listOfUnitFactors.append(UnitFactors.init("microseconds", 0.000001))
        listOfUnitFactors.append(UnitFactors.init("nanoseconds", 0.000000001))
        listOfUnitFactors.append(UnitFactors.init("miliseconds", 0.001))
        listOfUnitFactors.append(UnitFactors.init("minutes", 60))
        listOfUnitFactors.append(UnitFactors.init("kilograms", 1))
        listOfUnitFactors.append(UnitFactors.init("pounds", 0.453592))
        listOfUnitFactors.append(UnitFactors.init("grams", 0.001))
        listOfUnitFactors.append(UnitFactors.init("miligrams", 0.000001))
        listOfUnitFactors.append(UnitFactors.init("tons", 907.185))
        //tons are for US... add other versions of ton to all unit things...!!
        listOfUnitFactors.append(UnitFactors.init("ounces", 0.0283495))
        listOfUnitFactors.append(UnitFactors.init("Newtons", 1))
        listOfUnitFactors.append(UnitFactors.init("Kilonewtons", 1000))
        listOfUnitFactors.append(UnitFactors.init("poundal", 0.138254954376))
        listOfUnitFactors.append(UnitFactors.init("pound-force", 4.4482216152605 ))
        listOfUnitFactors.append(UnitFactors.init("Joules", 1))
        listOfUnitFactors.append(UnitFactors.init("Kilojoules", 1000))
        listOfUnitFactors.append(UnitFactors.init("Milijoules", 0.001))
        listOfUnitFactors.append(UnitFactors.init("Calorie", 4.184))
        listOfUnitFactors.append(UnitFactors.init("Kilocalorie", 4184))
        listOfUnitFactors.append(UnitFactors.init("Electronvolt", 1.6022e-19))
        return listOfUnitFactors
    }
    
    static func ROUND_BY_DECIMAL_POINTS(value: Double, roundBy: Double) -> Double {
        let r = roundBy * 10
        return round(r * value) / r
    }
    //input must be the shortened var names
    //E. can also just add unshortened names
    //NOTE: SI Units refer to the base ones
    static func GET_SI_UNIT(vName: String) -> String {
        let name = vName.lowercased()
        switch true {
        case name == "a" || name == "acceleration":
            return Helper.exponentize(str: "meters/second^2")
        case vName == "fV" || vName == "iV" || name == "v" || name.contains("velocity"):
            return "meters/second"
        case name == "d" || name == "r" || name.contains("separation") || name == "distance" || name == "displacement":
            return "meters"
        case name == "f" || name == "fg" || name.contains("force"):
            return "Newtons"
        case name == "m" || name == "m1" || name == "m2" || name.contains("mass") :
            return "kilograms"
        case name == "k" || name.contains("energy"):
            return "Joules"
        case name == "t" || name == "time":
            return "seconds"
        default:
            print("ERROR GETTING SI UNIT")
            return "error"
        }
    }
    
    static func GET_LIST_OF_METRIC_UNITS(varName: String) -> [String] {
        switch true {
        case varName == "a":
            return LIST_OF_METRIC_UNITS.ACCELERATION_UNITS
        case varName == "fV" || varName == "iV" || varName == "v" :
            return LIST_OF_METRIC_UNITS.VELOCITY_UNITS
        case varName == "d" || varName == "r" :
            return LIST_OF_METRIC_UNITS.DISTANCE_UNITS
        case varName == "f" || varName == "fG" :
            return LIST_OF_METRIC_UNITS.FORCE_UNITS
        case varName == "m" || varName == "m1" || varName == "m2" :
            return LIST_OF_METRIC_UNITS.MASS_UNITS
        case varName == "k" || varName == "K":
            return LIST_OF_METRIC_UNITS.ENERGY_UNITS
        case varName == "t":
            return LIST_OF_METRIC_UNITS.TIME_UNITS
        default:
            print("ERROR GETTING SI UNIT")
            return ["error"]
        }
    }
    
    static func GET_LIST_OF_CUSTOMARY_UNITS(varName: String) -> [String] {
        switch true {
        case varName == "a":
            return LIST_OF_CUSTOMARY_UNITS.ACCELERATION_UNITS
        case varName == "fV" || varName == "iV" || varName == "v" :
            return LIST_OF_CUSTOMARY_UNITS.VELOCITY_UNITS
        case varName == "d" || varName == "r" :
            return LIST_OF_CUSTOMARY_UNITS.DISTANCE_UNITS
        case varName == "f" || varName == "fG" :
            return LIST_OF_CUSTOMARY_UNITS.FORCE_UNITS
        case varName == "m" || varName == "m1" || varName == "m2" :
            return LIST_OF_CUSTOMARY_UNITS.MASS_UNITS
        case varName == "k" || varName == "K":
            return LIST_OF_CUSTOMARY_UNITS.ENERGY_UNITS
        case varName == "t":
            return LIST_OF_CUSTOMARY_UNITS.TIME_UNITS
        default:
            print("ERROR GETTING SI UNIT")
            return ["error"]
        }
    }
    
    //COME BACK TO THIS!!!
    static func GET_SHORTENED_UNIT(unitName: String) -> String {
        let name = unitName.lowercased()
        switch true {
        case name == "meters/second" || name == "meter/second":
            return "m/s"
        case name == Helper.exponentize(str: "meters/second^2") || name == Helper.exponentize(str: "meter/second^2"):
            return Helper.exponentize(str: "m/s^2")
        case name == "meters" || name == "meter":
            return "m"
        case name == "second" || name == "seconds":
            return "s"
        case name == "newton" || name == "newtons":
            return "N"
        case name == "joule" || name == "joules":
            return "J"
        case name == "kilogram" || name == "kilograms" :
            return "kg"
        case name == "milimeter" || name == "milimeters":
            return "mm"
        case name == "electronvolt" || name == "electronvolts":
            return "eV"
        case name == "miles/hour":
            return "mph"
        case name == "meters/minute":
            return "m/min"
        case name == "centimeters/second":
            return "cm/s"
        case name == "feet/second":
            return "ft/s"
        case name == "kilometers/hour":
            return "km/hr"
        case name == Helper.exponentize(str: "meters/minute^2"):
            return Helper.exponentize(str: "m/min^2")
        case name == Helper.exponentize(str: "miles/hour^2"):
            return Helper.exponentize(str: "mph^2")
        case name == Helper.exponentize(str: "centimeters/second^2"):
            return Helper.exponentize(str: "cm/s^2")
        case name == Helper.exponentize(str: "feet/second^2"):
            return Helper.exponentize(str: "ft/s^2")
        case name == Helper.exponentize(str: "kilometers/hour^2"):
            return Helper.exponentize(str: "km/hr^2")
        case name == "miles":
            return "mi"
        case name == "feet":
            return "ft"
        case name == "centimeters":
            return "cm"
        case name == "kilometers":
            return "km"
        case name == "yards":
            return "yd"
        case name == "inches":
            return "in"
        case name == "nanometers":
            return "nm"
        case name == "micrometers":
            return "μm"
        case name == "hours":
            return "hr"
        case name == "microseconds":
            return "μs"
        case name == "nanoseconds":
            return "ns"
        case name == "miliseconds":
            return "ms"
        case name == "minutes":
            return "min"
        case name == "kilograms":
            return "kg"
        case name == "pounds":
            return "lb"
        case name == "grams":
            return "g"
        case name == "miligrams":
            return "mg"
        case name == "tons":
            return "t"
        case name == "ounces":
            return "oz"
        case name == "newtons":
            return "N"
        case name == "kilonewtons":
            return "kN"
        case name == "poundal":
            return "pdl"
        case name == "pound-force":
            return "lbf"
        case name == "kilojoules":
            return "kJ"
        case name == "milijoules":
            return "mJ"
        case name == "calories":
            return "Cal"
        case name == "kilocalories":
            return "kCal"
        case name == "coulombs":
            return "C"
        default:
            print("error")
            return "error"
        }
        
    }
    
    static func GET_FULL_UNIT_NAME(unitName: String) -> String {
        let name = unitName.lowercased()
        switch name {
        case "m/s":
            return "meters/second"
        case Helper.exponentize(str: "m/s^2"):
            return Helper.exponentize(str: "meters/second^2")
        case "s":
            return "seconds"
        case "m":
            return "meters"
        case "a":
            return "acceleration"
        case "mph":
            return "miles/hour"
        case "m/min":
            return "meters/minute"
        case "cm/s":
            return "centimeters/second"
        case "ft/s":
            return "feet/second"
        case "km/hr":
            return "kilometers/hour"
        case Helper.exponentize(str: "m/min^2"):
            return Helper.exponentize(str: "meters/minute^2")
        case Helper.exponentize(str: "mph^2"):
            return Helper.exponentize(str: "miles/hour^2")
        case Helper.exponentize(str: "cm/s^2"):
            return Helper.exponentize(str: "centimeters/second^2")
        case Helper.exponentize(str: "ft/s^2"):
            return Helper.exponentize(str: "feet/second^2")
        case Helper.exponentize(str: "km/hr^2"):
            return Helper.exponentize(str: "kilometers/hour^2")
        case "mi":
            return "miles"
        case "ft":
            return "feet"
        case "cm":
            return "centimeters"
        case "mm":
            return "milimeters"
        case "km":
            return "kilometers"
        case "yd":
            return "yards"
        case "in":
            return "inches"
        case "nm":
            return "nanometers"
        case "μm":
            return "micrometers"
        case "hr":
            return "hours"
        case "μs":
            return "microseconds"
        case "ns":
            return "nanoseconds"
        case "mms":
            return "miliseconds"
        case "min":
            return "minutes"
        case "kg":
            return "kilograms"
        case "lb":
            return "pounds"
        case "g":
            return "grams"
        case "mg":
            return "miligrams"
        case "t":
            return "tons"
        case "oz":
            return "ounces"
        case "n":
            return "Newtons"
        case "kn":
            return "Kilonewtons"
        case "pdl":
            return "poundal"
        case "pdf":
            return "pound-force"
        case "j":
            return "Joules"
        case "kj":
            return "Kilojoules"
        case "mj":
            return "Milijoules"
        case "cal":
            return "Calories"
        case "kcal":
            return "Kilocalories"
        case "ev":
            return "Electronvolts"
        case "c":
            return "coulombs"
        default:
            print("error- could not get full name of unit \(name)")
            return "error"
        }
    }
    
    static func GET_FONT_SIZE() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return 12
            case 1334:
                return 12
            case 1920, 2208:
                return 13
            case 2436:
                return 14
            case 2688:
                return 14
            case 1792:
                return 14
            default:
                return 28
            }
        }
        return 28
    }
    
    static func GET_DONE_BTN_WIDTH() -> CGFloat {
       if UIDevice().userInterfaceIdiom == .phone {
            return 90
       } else {
        return 180
        }
        
    }
    static func GET_DONE_BTN_HEIGHT() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 30
        } else {
            return 60
        }
        
    }
    
    static func GET_DONE_FONT_SIZE() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 16
        } else {
            return 30
        }
    }
    
    static func GET_BOTTOM_VIEW_HEIGHT() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 200
        } else {
            return 350
        }
    }
    
    /*
     static let VELOCITY_UNITS = ["meters/second", "miles/hour", "meters/minute", "centimeters/second", "feet/second", "kilometers/hour"]
     static let ACCELERATION_UNITS = ["meters/second^2", "meters/minute^2", "miles/hour^2", "centimeters/second^2", "feet/second^2", "kilometers/hour^2"]
     static let DISTANCE_UNITS = ["miles", "feet", "centimeters", "milimeters", "kilometers", "yards", "inches", "nanometers", "micrometers"]
     static let TIME_UNITS = ["seconds", "hours", "microseconds", "nanoseconds", "miliseconds", "minutes"]
     static let MASS_UNITS = ["kilograms", "pounds", "grams", "miligrams", "tons", "ounces"]
     static let FORCE_UNITS = ["Newtons", "Kilonewtons"]
     static let ENERGY_UNITS = ["Joules", "Kilojoules", "Milijoules", "Calorie", "Kilocalorie", "Electronvolt"]
 */
    //check if there are n commas... if there are, remove first item from the list
    //n = the max number of saved conversions allowed (either 20 or 25, not sure yet)
    static func CONFIGURE_SAVED_CONVERSIONS() {
        var commaCount = 0
        let listOfConversions: String = UserDefaults.standard.getListOfSavedConversions()
        var newList: String = ""
        for i in 0...listOfConversions.count-1 {
            let index = listOfConversions.index(listOfConversions.startIndex, offsetBy: i)
            if listOfConversions[index] == "," {
                commaCount += 1
            }
        }
        if commaCount == 25 {
            var reachedFirstComma = false
            for i in 0...listOfConversions.count-1 {
                let index = listOfConversions.index(listOfConversions.startIndex, offsetBy: i)
                if reachedFirstComma {
                    newList.append(listOfConversions[index])
                } else if listOfConversions[index] == "," {
                    reachedFirstComma = true
                }
            }
        } else {
            newList = listOfConversions
        }
        UserDefaults.standard.setListOfSavedConversions(value: newList)
    }
    
     static func FIX_SCIENTIFIC_NOTATION(value: String) -> String {
        var temp: String = ""
        //var reachedE: Bool = false
        //var zIndex: String.Index!
        for i in 0...value.count - 1 {
            let index = value.index(value.startIndex, offsetBy: i)
            if value[index] == "e" {
                temp += " ✕ 10^"
                //zIndex = value.index(value.startIndex, offsetBy: i + 5)
            } else if value[index] == "+" {
                
            } else {
                temp.append(value[index])
            }
        }
        
        /*if temp[zIndex] == "-" {
            temp.remove(at: zIndex)
        }
        //-*/
        
        return exponentize(str: temp)
    }
    
    static func CONVERT_TO_SCI_NOTATION(value: String) -> String {
        var temp: String = ""
        var numberOfDigits: Int = 0
        var reachedDec = false
        
        let _ = value.first == "0"
        let _ = value.first == "-" && value[value.index(value.startIndex, offsetBy: 1)] == "0"
        if value.first == "0" || (value.first == "-" && value[value.index(value.startIndex, offsetBy: 1)] == "0") {
            var firstNonZero: String = ""
            var reachedNonZero: Bool = false
            var numberOfEarlyZeros: Int = 0
            for i in 0...value.count - 1 {
                let index = value.index(value.startIndex, offsetBy: i)
                if value[index] == "e" {
                    return FIX_SCIENTIFIC_NOTATION(value: value)
                } else if value[index] == "." {
                    reachedDec = true
                } else if reachedDec {
                    if !reachedNonZero && value[index] != "0" {
                        reachedNonZero = true
                        firstNonZero.append(value[index])
                        temp = firstNonZero
                        temp += "."
                        numberOfDigits += 1
                    } else if !reachedNonZero {
                        numberOfEarlyZeros += 1
                        numberOfDigits += 1
                    } else {
                        temp.append(value[index])
                    }
                    
                }
            }
            if UserDefaults.standard.getEnableSigFigs() {
                temp = SigFigCalculator.init(number: temp).getRoundedAnswer()
            } else {
                temp = RoundByDecimals.ROUND_BY_DECIMALS(value: temp)
            }
            
            temp += " ✕ 10^-\(numberOfDigits)"
            //This is where the code for >1 goes...
        } else {
            for i in 0...value.count - 1 {
                let index = value.index(value.startIndex, offsetBy: i)
                if value[index] == "e" {
                    return FIX_SCIENTIFIC_NOTATION(value: value)
                } else if value[index] == "." {
                    reachedDec = true
                } else if !reachedDec {
                    if temp.isEmpty || (temp.contains("-") && temp.count == 1) {
                        temp.append(value[index])
                        if !temp.contains("-") || temp.count > 1 {
                            temp.append(".")
                        }
                    } else {
                        temp.append(value[index])
                        numberOfDigits += 1
                    }
                
                }
            }
            if UserDefaults.standard.getEnableSigFigs() {
                temp = SigFigCalculator.init(number: temp).getRoundedAnswer()
            } else {
                temp = RoundByDecimals.ROUND_BY_DECIMALS(value: temp)
            }
            //one things that need to be added: support for small numbers (less than one)
            temp += " ✕ 10^\(numberOfDigits)"
        }
        return exponentize(str: temp)
        
    }
    
    static func exponentize(str: String) -> String {
        
        let supers = [
            "-": "\u{207B}",
            "0": "\u{2070}",
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}",
            "/": "\u{2E0D}"]
        var newStr = ""
        var isExp = false
        for (_, char) in str.characters.enumerated() {
            if char == "^" {
                isExp = true
            } else {
                if isExp {
                    let key = String(char)
                    if supers.keys.contains(key) {
                        newStr.append(Character(supers[key]!))
                    } else {
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    newStr.append(char)
                }
            }
        }
        return newStr
    }
}

class RoundByDecimals {
    static func ROUND_BY_DECIMALS(value: String) -> String {
        var ending: String = ""
        //deals with rounding answers that are in scientific notation...
        if value.contains("e") {
            var reachedE = false
            for i in value {
                if i == "e" {
                    reachedE = true
                    ending.append(i)
                } else if reachedE {
                    ending.append(i)
                }
            }
        }
        var newValue: String = ""
        var reachedDecimal = false
        var decimalCount: Int = 0
        let decimalMax: Int = Int(UserDefaults.standard.getDecimalPointNum())
        if decimalMax == 0 {

            return "\(Int(round(Double(value)!)))"
        }
        for i in value {
            if i == "." {
                reachedDecimal = true
                newValue += "."
            } else if reachedDecimal && decimalCount != decimalMax {
                decimalCount += 1
                newValue.append(i)
            } else if decimalCount == decimalMax {
                let index = value.index(value.startIndex, offsetBy: newValue.count)
                let tempC: String = String(value[index])
                let tempI = Double(tempC)!
                if tempI > 4 {
                    let tempCount = newValue.count
                    //print(newValue)
                    newValue = ROUND_UP(value: newValue)
                    //print(newValue)
                    if newValue.count == tempCount {
                        if !ending.isEmpty {
                            newValue += ending
                            return Helper.CONVERT_TO_SCI_NOTATION(value: newValue)
                        }
                        //it is NOT returning the newValue here...
                        return newValue
                    }
                    for _ in newValue.count...tempCount-1 {
                        newValue += "0"
                    }
                }
                if !ending.isEmpty {
                    newValue += ending
                    return Helper.CONVERT_TO_SCI_NOTATION(value: newValue)
                }
                //it is NOT returning the newValue here...
                return newValue
            } else {
                newValue.append(i)
            }
        }
        if !newValue.contains(".") {
            newValue += "."
        }
        if decimalCount >= decimalMax {
            if !ending.isEmpty {
                newValue += ending
                return Helper.CONVERT_TO_SCI_NOTATION(value: newValue)
            }
            print("100% sure its returning here")
            print("Decimal count: ")
            return newValue
        }
        for _ in decimalCount...decimalMax-1 {
            newValue += "0"
        }
        if !ending.isEmpty {
            newValue += ending
            return Helper.CONVERT_TO_SCI_NOTATION(value: newValue)
        }
        return newValue
    }
    private static func ROUND_UP(value: String) -> String {
        var temp:String = value
        switch temp.last {
        case "0":
            temp.removeLast()
            temp.append("1")
            return temp
        case "1":
            temp.removeLast()
            temp.append("2")
            return temp
        case "2":
            temp.removeLast()
            temp.append("3")
            return temp
        case "3":
            temp.removeLast()
            temp.append("4")
            return temp
        case "4":
            temp.removeLast()
            temp.append("5")
            return temp
        case "5":
            temp.removeLast()
            temp.append("6")
            return temp
        case "6":
            temp.removeLast()
            temp.append("7")
            return temp
        case "7":
            temp.removeLast()
            temp.append("8")
            return temp
        case "8":
            temp.removeLast()
            temp.append("9")
            return temp
        case "9":
            temp.removeLast()
            return ROUND_UP(value: temp)
        default:
            return temp
        }
    }
    
}
//can go in its own class
class SigFigCalculator {
    
    private var number: String
    private var originalNumber: String
    private var roundCounter = 0
    
    private var ending: String = ""
    
    init(number: String) {
        self.number = number
        self.originalNumber = number
        roundBySigFigs()
    }
    //first get # of sig figs... then compare it to target # of sig figs
    //return if equal, add zeros if too little, subtract sig digits if too many
    private func roundBySigFigs() {
        fixEnding()
        let sigFigCount = getSigFigCount()
        let sigFigTarget: Int = Int(UserDefaults.standard.getSigFigNum())
        if sigFigTarget > sigFigCount {
            roundByAddingSigFigs()
        } else if sigFigTarget < sigFigCount {
            roundByRemovingSigFigs()
        }
        roundAtEnd()
        addEnding()
    }
    
    //adds back ending
    private func addEnding() {
        if ending.isEmpty {
            return
        }
        var newEnding: String = " ✕ 10^"
        ending.removeFirst()
        if(ending.first == "+") {
            ending.removeFirst()
        }
        newEnding += ending
        number += newEnding
        number = Helper.exponentize(str: number)
    }
    
    
    //removes ending if number ends in a "e20" or something with e. stores it in variable.
    private func fixEnding() {
        var reachedE = false
        var counter = 0
        for i in 0...number.count - 1 {
            let index = number.index(number.startIndex, offsetBy: i)
            if number[index] == "e" {
                reachedE = true
            }
            if reachedE {
                counter += 1
                ending.append(number[index])
            }
        }
        
        if !reachedE {
            return
        }
        
        for _ in 0...counter-1 {
            number.removeLast()
        }
        
        
    }
    
    //gets the # of sig figs in the current number.
    private func getSigFigCount() -> Int {
        //notice: if the number has an e or x in it... have to remove it before calculating sig figs
        
        var ending: String = ""
        var reachedPow = false
        var temp = ""
        for i in 0...number.count - 1 {
            let index = number.index(number.startIndex, offsetBy: i)
            if number[index] == " " || number[index] == "e" {
                reachedPow = true
            }
            if reachedPow {
                ending.append(number[index])
            } else {
                temp.append(number[index])
            }
        }
        
        number = temp
        
        var sigFigCount = 0
        for i in 0...number.count-1 {
            let index = number.index(number.startIndex, offsetBy: i)
            if number[index] == "-" || number[index] == "." {
                //negative sign and decimal point are not significant. BUT, if they are found
                //within the isItSignificant function, we cannot just return false: we have to look
                //further as they are also not counted.
            } else if isItSignificant(indexNumber: i, direction: "N/A") {
                sigFigCount += 1
            }
        }
        
        number += ending
        
        return sigFigCount
    }
    //checks if the specific digit at an index is significant, not significant, or needs to do more to figure out (check bound(s))
    private func isItSignificant(indexNumber: Int, direction: String) -> Bool {
        let index = number.index(number.startIndex, offsetBy: indexNumber)
        let str = self.number[index]
        if str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "6" || str == "7" || str == "8" || str == "9" {
            //if it is a non-zero digit, it is significant
            return true
        } else if indexNumber == 0 {
            //this means that there are one or more zeros at end that are making this not significant. Not bounded leftward.
            return false
        } else if indexNumber == number.count-1 && !number.contains(".") {
            //this mean that there are one or more zeros at the end of the number AND these zeros are not "trailing zeros"... meaning the number lacks a decimal point. Not bounded rightward.
            return false
        } else if indexNumber == number.count-1 && number.contains(".") {
            //this means that we are at the end of the number AND there is a decimal, so the zero at the end will be significant. Last zero past the decimal is always significant.
            return true
        } else {
            //this is a zero that we need to do more to figure out if its significant or not. One of the Sig Fig rules is that a zero is significant only if it is "between" two significant digits. So we need to see if the right and the left digits "between" the zero are significant or not.
            //to prevent infinite loop, need to only test the side that we are traveling in.
            if direction == "Left" {
                return isItSignificant(indexNumber:indexNumber-1, direction: "Left")
            } else if direction == "Right" {
                return isItSignificant(indexNumber:indexNumber+1, direction: "Right")
            } else {
                return isItSignificant(indexNumber:indexNumber-1, direction: "Left") && isItSignificant(indexNumber:indexNumber+1, direction: "Right")
            }
            
        }
    }
    
    private func roundByAddingSigFigs() {
        var giveUp = false
        var sigFigCount: Int = getSigFigCount()
        let sigFigTarget: Int = Int(UserDefaults.standard.getSigFigNum())
        
        //this first if statement checks an exception, where the number lacks a decimal point, and adding one plus the end zero will make the number have too many sig figs. In that case, you have to round by SCI NOT
        //it also adds a decimal point and a zero if it does not already have one.
        if !number.contains(".") {
            number.append(".")
            number.append("0")
            sigFigCount = getSigFigCount()
            if sigFigCount == sigFigTarget {
                //we now have exactly enough sig figs! lucky
                return
            } else if sigFigCount > sigFigTarget {
                //now too many sig figs... so we cannot have right # of sig figs w/o SCI NOT
                giveUp = true
            }
        }
        
        while(sigFigCount < sigFigTarget && !giveUp) {
            addSigFig()
            sigFigCount = getSigFigCount()
        }
        
        if giveUp {
            roundBySciNot()
        }
        
    }
    
    private func roundByRemovingSigFigs() {
        
        var sigFigCount: Int = getSigFigCount()
        let sigFigTarget: Int = Int(UserDefaults.standard.getSigFigNum())
        while(sigFigCount > sigFigTarget) {
            removeSigFig()
            if number.last == "." {
                number.removeLast()
            }
            sigFigCount = getSigFigCount()
        }
        
        if sigFigCount != sigFigTarget {
            roundBySciNot()
        }
        
    }
    
    //for below two funcs... make sure to also recount how many sig figs are in the new number!
    private func addSigFig() {
        number.append("0")
    }
    private func removeSigFig() {
        if number.contains(".") {
            //everytime you remove... you have to round!
            /*if number.last == "5" || number.last == "6" || number.last == "7" || number.last == "8" || number.last == "9" {
                number.removeLast()
                roundUp()
            } else {
                number.removeLast()
            }*/
            number.removeLast()
        } else {
            for i in 0...number.count-1 {
                let index = number.index(number.startIndex, offsetBy: number.count - 1 - i)
                if number[index] != "0" {
                    /*if number[index] == "5" || number[index] == "6" || number[index] == "7" || number[index] == "8" || number[index] == "9" {
                        roundUpAtLocation(location: number.count - 2 - i)
                        
                    }*/
                    replaceItWithAZero(location: number.count - 1 - i)
                    return
                }
            }
        }
        
    }
    
    private func replaceItWithAZero(location: Int) {
        var temp: String = ""
        for i in 0...number.count-1 {
            let curIndex = number.index(number.startIndex, offsetBy:i)
            if i != location {
                temp.append(number[curIndex])
            } else {
                temp.append("0")
            }
        }
        number = temp
    }
    
    
    private func roundAtEnd() {
        var rounded = false
        var temp: String = ""
        for i in 0...number.count-1 {
            let curIndex = number.index(number.startIndex, offsetBy:i)
            if i > originalNumber.count-1 {
                rounded = true
                temp.append(number[curIndex])
            } else if number[curIndex] != originalNumber[curIndex] && !rounded {
                //ROUND
                if originalNumber[curIndex] == "5" || originalNumber[curIndex] == "6" || originalNumber[curIndex] == "7" || originalNumber[curIndex] == "8" || originalNumber[curIndex] == "9" {
                    //let newIndex = number.index(number.startIndex, offsetBy:i-1)
                    temp = roundUp(num: temp)
                    for j in 0...roundCounter {
                        if j != 0 {
                            temp.append("0")
                        }
                    }
                }
                temp.append(number[curIndex])
                rounded = true
            } else {
                temp.append(number[curIndex])
            }
        }
        number = temp
        roundCounter = 0 //just in case
        let targetSigFig: Int = Int(UserDefaults.standard.getSigFigNum())
        if targetSigFig > getSigFigCount() {
            roundBySciNot()
        } else if targetSigFig < getSigFigCount() {
            //should never be called but w/e
        }
        //now... this is where the headache begins... as rounding can change the # of sig figs the number has... so we have to do more D;
        
    }
    
    //if round by remove or round by add fail... we round by scientific notation instead.
    private func roundBySciNot() {
        //add digits to a new, temp # until it has non ./- characters equal to # of sig figs. if the first is a zero tho, we dont add that.
        let isNegative = number.first == "-"
        if isNegative {
            number.remove(at: number.firstIndex(of: "-")!)
        }
        var tempNumber: String = ""
        var tensPower: Int = 0
        var tensString = " ✕ 10^"
        let sigFigTarget: Int = Int(UserDefaults.standard.getSigFigNum())
        
        if greaterThanOne() {
            tensPower = -1
            var reachedDecimal = false
            for i in 0...number.count-1 {
                let index = number.index(number.startIndex, offsetBy: i)
                if number[index] != "." && !reachedDecimal {
                    tempNumber.append(number[index])
                    tensPower += 1
                } else {
                    reachedDecimal = true
                }
                if i == 0 {
                    tempNumber.append(".")
                }
                
            }
        } else {
            tensPower = 1
            tensString += "-"
            var beyondDecimal = false //not needed
            var encounteredNonZeroDigit = false
            for i in 0...number.count-1 {
                let index = number.index(number.startIndex, offsetBy: i)
                if number[index] == "." {
                    beyondDecimal = true
                } else if beyondDecimal && number[index] == "0" && !encounteredNonZeroDigit {
                    tensPower += 1
                } else if beyondDecimal && number[index] != "0" {
                    tempNumber.append(number[index])
                    if encounteredNonZeroDigit == false {
                        tempNumber.append(".")
                    }
                    encounteredNonZeroDigit = true
                }
            }
        }
        
        number = tempNumber
        if tempNumber.count-1 > sigFigTarget {
            roundByRemovingSigFigs()
        } else if tempNumber.count-1 < sigFigTarget {
            roundByAddingSigFigs()
        }
        
        tempNumber = number
        number = ""
        if isNegative {
            number = "-"
        }
        number += tempNumber
        number += tensString
        number += "\(tensPower)"
        
        number = Helper.exponentize(str: number)
        
        //GREATER THAN ONE:
        //exception: negative at beginning, zero if its at beginning or at second from beginning and the beginning is a negative.
        //for every digit added, add it to a sum. this sum stops adding when user reaches decimal place. it then uses that # as the power of ten. THIS ONLY WORKS FOR NUMBERS GREATER THAN ONE.
        //**sum starts at -1!
        
        //LESS THAN ONE:
        //sum starts at one, and adds for each zero beyond the decimal point. once a single nonzero is found, the sum stops adding.
        //the actual factual newValue starts adding when first nonzero beyond decimal is encountered! (besides the negative sign at front and a decimal point)
        
        //EDIT: have a is negative boolean that will later add a negative sign at front of number when this is all over
        
        //0.01
        //1e-2
        
        
    }
    //helper func that checks if the number ABS is less than one or not.
    private func greaterThanOne() -> Bool {
        var isBeyondDecimal = false
        for i in 0...number.count-1 {
            let index = number.index(number.startIndex, offsetBy: i)
            if number[index] == "." {
                isBeyondDecimal = true
            } else if !isBeyondDecimal {
                let c = number[index] != "-" && number[index] != "0"
                if c {
                    return c
                }
            }
            
        }
        return false
    }
    //might not work for 9s... test!!
    private func roundUp(num: String) -> String {
        var numb: String = num
        switch numb.last {
        case "0":
            numb.removeLast()
            numb.append("1")
            return numb
        case "1":
            numb.removeLast()
            numb.append("2")
            return numb
        case "2":
            numb.removeLast()
            numb.append("3")
            return numb
        case "3":
            numb.removeLast()
            numb.append("4")
            return numb
        case "4":
            numb.removeLast()
            numb.append("5")
            return numb
        case "5":
            numb.removeLast()
            numb.append("6")
            return numb
        case "6":
            numb.removeLast()
            numb.append("7")
            return numb
        case "7":
            numb.removeLast()
            numb.append("8")
            return numb
        case "8":
            numb.removeLast()
            numb.append("9")
            return numb
        case "9":
            numb.removeLast()
            roundCounter += 1
            return roundUp(num: numb)
            
        default:
            print("ERROR")
            break
        }
        return numb
    }
    
    func getRoundedAnswer() -> String {
        return self.number
    }
}

struct defaultsKeys { //for calculators
    //show units
    static let showUnits = "false"
    //number of sig figs
    static let sigFigNumber = "4 D"
    static let showSciNo = "f"
}

struct savedProblemSettings {
    static let selectedEq = "Default"
    static let typeOfProb = "FRQ (Default)"
    static let enableUnits = "FALSE"
    static let typeOfUnitsShown = "SI"
}

//based on their device...
/*struct staticUserSettings {
    //static let userDevice = "UNKNOWN"
    //static let firstTime = "TRUE"
    static let buttonSize = "-1"
}*/
//TESTING USERDEFAULTS IN DIFFERENT WAY BELOW

extension UserDefaults {
    
    //buttonSize funcs
    func setButtonSize(value: Double) {
        set(value, forKey: UserDefaultsKeys.buttonSize.rawValue)
    }
    
    func getButtonSize() -> Double {
        return double(forKey: UserDefaultsKeys.buttonSize.rawValue)
    }
    //showUnits func
    func setShowUnitsPP(value: Bool) {
        set(value, forKey: UserDefaultsKeys.showUnitsPP.rawValue)
    }
    func isUnitsShownPP() -> Bool {
        return bool(forKey: UserDefaultsKeys.showUnitsPP.rawValue)
    }
    //current physics eq selected for PP
    
    func setCurrentPhysicsEqPP(value: String) {
        set(value, forKey: UserDefaultsKeys.currentPhysicsEqPP.rawValue)
    }
    func getCurrentPhysicsEqPP() -> String {
        return string(forKey: UserDefaultsKeys.currentPhysicsEqPP.rawValue) ?? "nil"
    }
    //problem type for PP
    
    func setProblemTypePP(value: String) {
        set(value, forKey: UserDefaultsKeys.problemTypePP.rawValue)
    }
    func getProblemTypePP() -> String {
        return string(forKey: UserDefaultsKeys.problemTypePP.rawValue) ?? "nil"
    }
    
    //type of units for PP
    
    func setProblemUnitsPP(value: String) {
        set(value, forKey: UserDefaultsKeys.problemUnitsPP.rawValue)
    }
    func getProblemUnitsPP() -> String {
        return string(forKey: UserDefaultsKeys.problemUnitsPP.rawValue) ?? "nil"
    }
    
    //show units CALC
    func setShowUnitsCalc(value: Bool) {
        set(value, forKey: UserDefaultsKeys.showUnitsCalc.rawValue)
    }
    func getShowUnitsCalc() -> Bool {
        return bool(forKey: UserDefaultsKeys.showUnitsCalc.rawValue)
    }
    //enable(show) scientific notation for all parts of calculator
    func setEnableSciNot(value: Bool) {
        set(value, forKey: UserDefaultsKeys.enableSciNot.rawValue)
    }
    func getEnableSciNot() -> Bool {
        return bool(forKey: UserDefaultsKeys.enableSciNot.rawValue)
    }

    //number of decimal point shown func
    func setDecimalPointNum(value: Double) {
        set(value, forKey: UserDefaultsKeys.decimalPointNum.rawValue)
    }
    func getDecimalPointNum() -> Double {
        return double(forKey: UserDefaultsKeys.decimalPointNum.rawValue)
    }
    
    //enable sig figs for all parts of app. Sig figs trump over decimal places
    func setEnableSigFigs(value: Bool) {
        set(value, forKey: UserDefaultsKeys.enableSigFigs.rawValue)
    }
    func getEnableSigFigs() -> Bool {
        return bool(forKey: UserDefaultsKeys.enableSigFigs.rawValue)
    }
    
    //set the number of sig figs shown for all parts of calculator
    func setSigFigNum(value: Double) {
        set(value, forKey: UserDefaultsKeys.sigFigNum.rawValue)
    }
    func getSigFigNum() -> Double {
        return double(forKey: UserDefaultsKeys.sigFigNum.rawValue)
    }
    
    //save past conversions from Unit Converter... max of 20 or 25 idk yet
    func setListOfSavedConversions(value: String) {
        set(value, forKey: UserDefaultsKeys.listOfSavedConversions.rawValue)
    }
    func getListOfSavedConversions() -> String {
        return string(forKey: UserDefaultsKeys.listOfSavedConversions.rawValue) ?? "nil"
    }
    
    //check what mode app is in. Current options: Normal, Tutorial, Help
    func setMode(value: String) {
        set(value, forKey: UserDefaultsKeys.mode.rawValue)
    }
    func getMode() -> String {
        return string(forKey: UserDefaultsKeys.mode.rawValue) ?? "Normal"
    }
    
    //saved problem counter
    func setSavedProblemCounter(value: Double) {
        set(value, forKey: UserDefaultsKeys.savedProblemCounter.rawValue)
    }
    func getSavedProblemCounter() -> Double {
        return double(forKey: UserDefaultsKeys.savedProblemCounter.rawValue)
    }
    
    func setUpdate1_1_0(value: Bool) {
        set(value, forKey: UserDefaultsKeys.update1_1_0.rawValue)
    }
    func getUpdate1_1_0() -> Bool {
        return bool(forKey: UserDefaultsKeys.update1_1_0.rawValue)
    }
    
    func setListOfPromptlessProblems(value: [String]) {
        set(value, forKey: UserDefaultsKeys.listOfPromptlessProblems.rawValue)
    }
    func getListOfPromptlessProblems() -> [String] {
        return stringArray(forKey: UserDefaultsKeys.listOfPromptlessProblems.rawValue) ?? ["nil"]
    }
    
}

enum UserDefaultsKeys : String {
    case buttonSize
    
    case currentPhysicsEqPP
    case problemTypePP
    case problemUnitsPP
    case showUnitsPP
    case showUnitsCalc
    case enableSciNot
    case decimalPointNum
    case enableSigFigs
    case sigFigNum
    
    case listOfSavedConversions
    
    case mode
    
    case savedProblemCounter
    
    case update1_1_0
    case listOfPromptlessProblems
}

//program this...
struct pastUnitConversions {
    static let listOfConversions = ""
    static let numberOfConversions = "0"
}

struct LIST_OF_UNITS {
    static let VELOCITY_UNITS = ["meters/second", "miles/hour", "meters/minute", "centimeters/second", "feet/second", "kilometers/hour"]
    static let ACCELERATION_UNITS = [Helper.exponentize(str: "meters/second^2"), Helper.exponentize(str: "meters/minute^2"), Helper.exponentize(str: "miles/hour^2"), Helper.exponentize(str: "centimeters/second^2"), Helper.exponentize(str: "feet/second^2"), Helper.exponentize(str: "kilometers/hour^2")]
    static let DISTANCE_UNITS = ["meters", "miles", "feet", "centimeters", "milimeters", "kilometers", "yards", "inches", "nanometers", "micrometers"]
    static let TIME_UNITS = ["seconds", "hours", "microseconds", "nanoseconds", "miliseconds", "minutes"]
    static let MASS_UNITS = ["kilograms", "pounds", "grams", "miligrams", "tons", "ounces"]
    static let FORCE_UNITS = ["Newtons", "Kilonewtons", "poundal", "pound-force"]
    static let ENERGY_UNITS = ["Joules", "Kilojoules", "Milijoules", "Calorie", "Kilocalorie", "Electronvolt"]
    //lul not using below YET
    static let CHARGE_UNITS = ["coulombs", "nanocoulombs", "microcoulombs"]
    
}

struct LIST_OF_UNITS_FOR_PICKER {
    static let VELOCITY_UNITS = ["Select a velocity unit...", "meters/second", "miles/hour", "meters/minute", "centimeters/second", "feet/second", "kilometers/hour"]
    static let ACCELERATION_UNITS = ["Select an acceleration unit...", Helper.exponentize(str: "meters/second^2"), Helper.exponentize(str: "meters/minute^2"), Helper.exponentize(str: "miles/hour^2"), Helper.exponentize(str: "centimeters/second^2"), Helper.exponentize(str: "feet/second^2"), Helper.exponentize(str: "kilometers/hour^2")]
    static let DISTANCE_UNITS = ["Select a distance unit...", "meters", "miles", "feet", "centimeters", "milimeters", "kilometers", "yards", "inches", "nanometers", "micrometers"]
    static let TIME_UNITS = ["Select a time unit...", "seconds", "hours", "microseconds", "nanoseconds", "miliseconds", "minutes"]
    static let MASS_UNITS = ["Select a mass unit...", "kilograms", "pounds", "grams", "miligrams", "tons", "ounces"]
    static let FORCE_UNITS = ["Select a force unit...", "Newtons", "Kilonewtons", "poundal", "pound-force"]
    static let ENERGY_UNITS = ["Select an energy unit...","Joules", "Kilojoules", "Milijoules", "Calorie", "Kilocalorie", "Electronvolt"]
    //lul not using below YET
    static let CHARGE_UNITS = ["Select a charge unit...", "coulombs", "nanocoulombs", "microcoulombs"]
}

struct LIST_OF_METRIC_UNITS {
    static let VELOCITY_UNITS = ["meters/second", "meters/minute", "kilometers/hour"]
    static let ACCELERATION_UNITS = [Helper.exponentize(str: "meters/second^2")]
    static let DISTANCE_UNITS = ["meters", "kilometers", "milimeters", "centimeters"]
    static let TIME_UNITS = ["seconds", "hours", "miliseconds", "minutes"]
    static let MASS_UNITS = ["kilograms", "grams", "miligrams"]
    static let FORCE_UNITS = ["Newtons", "Kilonewtons"]
    static let ENERGY_UNITS = ["Joules", "Kilojoules", "Milijoules", "Electronvolt"]
}

struct LIST_OF_CUSTOMARY_UNITS {
    static let VELOCITY_UNITS = ["miles/hour", "feet/second"]
    static let ACCELERATION_UNITS = [Helper.exponentize(str: "miles/hour^2"), Helper.exponentize(str: "feet/second^2")]
    static let DISTANCE_UNITS = ["miles", "feet", "yards", "inches"]
    static let TIME_UNITS = ["seconds", "hours", "microseconds", "nanoseconds", "miliseconds", "minutes"]
    static let MASS_UNITS = ["pounds", "tons", "ounces"]
    static let FORCE_UNITS = ["poundal", "pound-force"]
    static let ENERGY_UNITS = ["Calorie", "Kilocalorie"]
    
}

//includes the factor that needs to be multiplied to turn this unit into SI
//what you do is divide the from unit ratio to the to unit ratio than multiply that by the user's given value
class UnitFactors {
    var name: String
    var value: Double
    init(_ name: String, _ value: Double) {
        self.name = name
        self.value = value
    }
    
}

struct PHYSICS_CONSTANTS {
    static let EARTH_GRAVITY = 9.81
    static let EARTH_MASS = 5.972e24
    static let BIG_G = 6.67e-11
}



extension UILabel {
    func getFontSizeForLabel() -> CGFloat {
        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        text.setAttributes([NSAttributedStringKey.font: self.font], range: NSMakeRange(0, text.length))
        let context: NSStringDrawingContext = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        text.boundingRect(with: self.frame.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
        let adjustedFontSize: CGFloat = self.font.pointSize * context.actualScaleFactor
        return adjustedFontSize
    }
}

struct HelpPopupText {
    //SETTINGS
    static let SETTINGS_1 = "The Settings page allows you to change the method of presenting and rounding the numbers presented in the app. Practice Problem's settings also include additional modes to customize your experience."
    //SECOND: BACK
    static let SETTINGS_3 = "Enabling this switch presents answers in Scientific Notation rather than standard notation. By default, it is turned off."
    static let SETTINGS_4 = "Entering a number here sets how many decimal places will be shown in answers. By default, 6 are shown. NOTE: Significant Figures number overrides this number."
    static let SETTINGS_5 = "Enabling this switch turns on Significant Figures for rounding answers. The Decimal Place number will be ignored if this is enabled. By default, Sig Figs are turned off."
    static let SETTINGS_6 = "Entering a number here sets how many significant figures will be presented in answers. By default, four significant figures will be rouned on."
    static let SETTINGS_7 = "Tapping this button saves any changes you made on this Settings view."
    
    //SETTINGS: PP EDITION
    static let PPSET_1 = "The Practice Problem Settings page allows you to customize your experience when doing Physics problems. Tapping here can change this to general settings, where app-wide settings dealing with the presentation of numbers are present."
    //SECOND: BACK
    static let PPSET_3 = "Tapping this menu button brings up a list of Physics problem types that can be presented for practice problems. The current options are: Kinematics, Forces, Kinetic Energy, and Gravitational Force problems."
    static let PPSET_4 = "Tapping this menu button brings up a list of question types that can be presented for practice problems. The two choices are currently Free Response and Multiple Choice. The Free Response option can also have units enabled for it."
    static let PPSET_5 = "Tapping this menu button brings up a list of unit types that can be presented for the prompts in practice problems. The options are either SI(base) units, any Metric units, or all units including customary."
    static let PPSET_6 = "Enabling this switch turns on units for the answer for practice problems. You would have to select an SI(base) unit before answering the question. This is only available for Free Response questions as of now."
    static let PPSET_7 = "Tapping this button saves any changes you made on this Settings view."
    
    //HOME
    static let HOME_1 = "Welcome to Portable Physicist! Here, you get to select what calculator you want to use. To navigate to other tools, click on one of the calculator buttons, and then click on the More button"
    //SECOND: SETTINGS
    static let HOME_3 = "Tapping this button brings you to the Kinematics Calculator"
    static let HOME_4 = "Tapping this button brings you to the Forces Calculator"
    static let HOME_5 = "Tapping this button brings you to the Kinetic Energy Calculator"
    static let HOME_6 = "Tapping this button brings you to the Gravitational Force Calculator"
    
    //CALCULATOR
    static let CALC_1 = "Here, enter in values and their units to calculate the unknown variables. You only need to enter in 3 values for Kinematics and all the presented variables except for one for other calculators."
    //SECOND: MORE
    //THIRD: SETTINGS
    static let CALC_4 = "Enter in a number for the first variable (only if it is known). In this case, the first variable is Initial Velocity. Otherwise, a number will be provided for this variable after you press the Calculate button with the appropriate number of values filled in."
    static let CALC_5 = "Enter in a number for the second variable (only if it is known). In this case, the second variable is Final Velocity. Otherwise, a number will be provided for this variable after you press the Calculate button with the appropriate number of values filled in."
    static let CALC_6 = "Enter in a number for the third variable (only if it is known). In this case, the third variable is Acceleration. Otherwise, a number will be provided for this variable after you press the Calculate button with the appropriate number of values filled in."
    static let CALC_7 = "Enter in a number for the fourth variable (only if it is known/shown). In this case, the fourth variable is Time. Otherwise, a number will be provided for this variable after you press the Calculate button with the appropriate number of values filled in."
    static let CALC_8 = "Enter in a number for the fifth variable (only if it is known/shown). In this case, the fifth variable is Displacement. Otherwise, a number will be provided for this variable after you press the Calculate button with the appropriate number of values filled in."
    static let CALC_9 = "Select a unit for the first variable (only if you inputted or will input a value for it). In this case, the units to select are velocity. If no units are selected, it will default to the SI (base) unit."
    static let CALC_10 = "Select a unit for the second variable (only if you inputted or will input a value for it). In this case, the units to select are velocity. If no units are selected, it will default to the SI (base) unit."
    static let CALC_11 = "Select a unit for the third variable (only if you inputted or will input a value for it). In this case, the units to select are acceleration. If no units are selected, it will default to the SI (base) unit."
    static let CALC_12 = "Select a unit for the fourth variable (only if you inputted or will input a value for it). In this case, the units to select are time. If no units are selected, it will default to the SI (base) unit."
    static let CALC_13 = "Select a unit for the fifth variable (only if you inputted or will input a value for it). In this case, the units to select are distance. If no units are selected, it will default to the SI (base) unit."
    static let CALC_14 = "Press the Calculate button to produce the solution(s) to your problem based on your inputs. The answer(s) will appear right above this button, and they will be presented/rounded based on your settings."
    
    //OPTIONS
    static let OPT_1 = "Here, other features are accessible. These features include options to show work, show the physics equations, convert values, get practice problems, or take a quiz."
    //SECOND: BACK
    static let OPT_3 = "Tap this button to go back to the home screen to select another calculator to use. Available calculators as of now are Kinematics, Force, Kinetic Energy, and Gravitational Force."
    static let OPT_4 = "Tap this button to show the work of the problems you saved. A step-by-step guide is provided for you on how to go from the known values to the answer."
    static let OPT_5 = "Tap this button to show the list of physics equations used in the calculator."
    static let OPT_6 = "Tap this button to go to the Unit Converter, where you can convert values based on your physics needs. Up to 25 conversions can be saved and accessed here."
    static let OPT_7 = "Tap this button to begin a Practice Problem, where it will give you a problem based on one of the four physics concepts in the app, and you have to answer the prompt."
    static let OPT_8 = "Tap this button to set up for a Quiz. It will bring you to a page where you select options to set up your Quiz experience."
    
    //SHOWORK
    
    static let SHOWORK_1 = "Here, the work for the physics problems you saved in the calculator, practice problems, and quiz is present. Step-by-step guides are provided for solving the problem, going all the way to the answer from the start."
    //SECOND: BACK
    static let SHOWORK_3 = "This view shows the work for each step of solving the problem. It includes descriptions detailing how to arrive at the answer and working with the numbers and equations."
    static let SHOWORK_4 = "Tapping this button brings you to the previous step shown."
    static let SHOWORK_5 = "Tapping this button brings you to the next step of the work."
    static let SHOWORK_6 = "This shows the step number you are currently viewing. The second number is the total number of steps presentable."
    static let SHOWORK_7 = "Tapping this menu button brings up a list of the Physics problems/calculations you saved. Select one of them to view its steps here."
    //SHOWEQ
    
    static let SHOWEQ_1 = "Here, a list of the equations present in the app are available here. The five Kinematics equations, the Force equation, the Kinetic Energy equation, and the Gravitational Force equation are all selectable to view."
    //SECOND: BACK
    static let SHOWEQ_3 = "This is where the equation(s) are shown, based on the type of Physics equation you selected."
    static let SHOWEQ_4 = "Tapping this menu button reveals the list of equations to pick from to then display in the above frame."
    
    //UNITCONVERT
    
    static let UNITCONVERT_1 = "Here, a unit converter is present, where you input a value, its units and physics variable name, and the unit you want to convert it to. The most recent conversions are saved and accessible here as well."
    //SECOND: BACK
    //THIRD: SETTINGS
    static let UNITCONVERT_4 = "Tapping this menu button brings up a list of Physics variables to choose from when setting up your conversion."
    static let UNITCONVERT_5 = "Tapping this menu button brings up a list of units for the specified Physics variable. Select the unit that your value currently holds, not the only that you want to convert to. If no units are chosen, SI (base) is chosen by default."
    static let UNITCONVERT_6 = "Enter in the current value that you want to be converted to a different unit."
    static let UNITCONVERT_7 = "Tapping this menu button brings up a list of units based on the chosen Physics variable that will be converted to. Select the unit that you want to convert your value to, not the one that it currently is. If no units are chosen, SI (base) is chosen by default."
    static let UNITCONVERT_8 = "Tapping this button calculates the conversion, placing the converted answer below this button."
    static let UNITCONVERT_9 = "This is where the latest conversion is present. It includes the value and the unit that it was converted to."
    static let UNITCONVERT_10 = "Tapping this button reveals the past 25 conversions you have done. Each of those conversions contains its converted value/unit and its unconverted value/unit."
    
    //PRACPRO
    static let PRACPRO_1 = "Here, Practice Problems are available to hone your Physics prowess. Practice Problems are available for any Physics equation in this app, and can also be presented in different unit types and as free response rather than multiple choice."
    //SECOND: MORE
    static let PRACPRO_3 = "Tapping the gear brings you to specific Practice Problem settings and general settings for the app."
    static let PRACPRO_4 = "The prompt for the Practice Problem is here. Reading this gives you the values and units necessary to solve the problem. The types of units and Physics problems shown here can be adjusted."
    static let PRACPRO_5  = "Tap one of these buttons to select the multiple choice answer you think is correct."
    static let PRACPRO_6 = "Tapping this button checks the answer you provided, whether it be a number or a multiple choice letter, and tell you if you got it right or wrong."
    static let PRACPRO_7 = "Tapping this button gives you a hint to aid you in solving. The Hint button is only available if you answered incorrectly."
    static let PRACPRO_8 = "Tapping this button brings you to a different Practice Problem. NOTE: previous Practice Problems cannot be returned to."
    
    //PREQUIZ
    
    static let PREQUIZ_1 = "Here, the configurations for the Quiz mode are present. Before beginning a Quiz, the type of Physics problem, number of Quiz questions, units in the problem, and format of question (M.C. or F.R.) must be chosen."
    //SECOND: BACK
    static let PREQUIZ_3 = "Tapping this button reveals the Help mode for this particular setting, explaining what these settings do."
    static let PREQUIZ_4 = "Entering in a value here determines the number of individual questions in the Quiz."
    static let PREQUIZ_5 = "Tapping this menu button brings up a selection of question types to choose from. Presently, only Multiple Choice and Free Response questions are available."
    static let PREQUIZ_6 = "Tapping this menu button brings up a choice of unit types to be shown in the Quiz prompt. SI (base) is the default unit type chosen."
    static let PREQUIZ_7 = "Tapping this menu button brings up a selection of Physics problems to choose from. Picking one of these will determine what kind of questions appear on the prompts for the Quiz."
    static let PREQUIZ_8 = "Turning this switch on will turn on units for the Quiz. You would have to select a unit for each Free Response question if this switch is on. This feature is unavailable for multiple choice questions, and is turned off by default."
    static let PREQUIZ_9 = "Touching this button begins the Quiz. It is only ready when sufficient settings are configured."
    
    //QUIZ
    static let QUIZ_1 = "Here, the Quiz screen is present. The format is similar to the Practice Problem, except for a few notable differences. Firstly, there is no hint label. Second of all, once you exit, you cannot return to that question. In addition, an incorrect answer will show you the answer immediately."
    static let QUIZ_2 = "The number of correct answers and the problem number you are on is indicated here."
    static let QUIZ_3 = "Tapping this button will exit you from the Quiz. Doing so is not reversible- all progress will be lost."
    static let QUIZ_4 = "Tapping this arrow will bring you to the next question. This is only available once you answer the current problem. After the last problem, an overview of your results is presented."
    static let QUIZ_5 = "This is where the Quiz question is present, selected based on the chosen settings at the prior location."
    static let QUIZ_6 = "This is where you enter in the value that you think is the answer. Make sure that it is in SI (base) units!"
    static let QUIZ_7 = "As long as you selected Free Response as the question type and turned on units, this menu button would appear, where you have to select the units for the answer you entered."
    static let QUIZ_8 = "Tapping this button checks your answer, telling you if you got it right or not. If you get it right, a point is added to your score. After you finish the Quiz, an overview of your results is presented."
    
    //ALL
    static let BACK = "Tap this arrow to return to the previous screen."
    static let SETTINGS = "Tapping the gear brings you to settings for the app."
    static let MORE = "Tapping this button brings you to a menu with other features, such as Practice Problems and Show Work"
    static let SAVE = "Tapping this button saves the current problem to be viewed in Show Work."
}

struct HelpPopups {
    static let SETTINGS = [HelpPopupText.SETTINGS_1, HelpPopupText.BACK, HelpPopupText.SETTINGS_3, HelpPopupText.SETTINGS_4, HelpPopupText.SETTINGS_5, HelpPopupText.SETTINGS_6, HelpPopupText.SETTINGS_7]
    static let PPSET = [HelpPopupText.PPSET_1, HelpPopupText.BACK, HelpPopupText.PPSET_3, HelpPopupText.PPSET_4, HelpPopupText.PPSET_5, HelpPopupText.PPSET_6, HelpPopupText.PPSET_7]
    static let HOME = [HelpPopupText.HOME_1, HelpPopupText.SETTINGS, HelpPopupText.HOME_3, HelpPopupText.HOME_4, HelpPopupText.HOME_5, HelpPopupText.HOME_6]
    static let CALC = [HelpPopupText.CALC_1, HelpPopupText.MORE, HelpPopupText.SETTINGS, HelpPopupText.CALC_4, HelpPopupText.CALC_5, HelpPopupText.CALC_6, HelpPopupText.CALC_7, HelpPopupText.CALC_8, HelpPopupText.CALC_9, HelpPopupText.CALC_10, HelpPopupText.CALC_11, HelpPopupText.CALC_12, HelpPopupText.CALC_13, HelpPopupText.CALC_14, HelpPopupText.SAVE]
    static let OPT = [HelpPopupText.OPT_1, HelpPopupText.BACK, HelpPopupText.OPT_3, HelpPopupText.OPT_4, HelpPopupText.OPT_5, HelpPopupText.OPT_6, HelpPopupText.OPT_7, HelpPopupText.OPT_8]
    static let SHOWORK = [HelpPopupText.SHOWORK_1, HelpPopupText.BACK, HelpPopupText.SHOWORK_3, HelpPopupText.SHOWORK_4, HelpPopupText.SHOWORK_5, HelpPopupText.SHOWORK_6, HelpPopupText.SHOWORK_7]
    static let SHOWEQ = [HelpPopupText.SHOWEQ_1, HelpPopupText.BACK, HelpPopupText.SHOWEQ_3, HelpPopupText.SHOWEQ_4]
    static let UNITCONVERT = [HelpPopupText.UNITCONVERT_1, HelpPopupText.BACK, HelpPopupText.SETTINGS, HelpPopupText.UNITCONVERT_4, HelpPopupText.UNITCONVERT_5, HelpPopupText.UNITCONVERT_6, HelpPopupText.UNITCONVERT_7, HelpPopupText.UNITCONVERT_8, HelpPopupText.UNITCONVERT_9, HelpPopupText.UNITCONVERT_10]
    static let PRACPRO = [HelpPopupText.PRACPRO_1, HelpPopupText.MORE, HelpPopupText.PRACPRO_3, HelpPopupText.PRACPRO_4, HelpPopupText.PRACPRO_5, HelpPopupText.PRACPRO_6, HelpPopupText.PRACPRO_7, HelpPopupText.PRACPRO_8, HelpPopupText.SAVE]
    static let PREQUIZ = [HelpPopupText.PREQUIZ_1, HelpPopupText.BACK, HelpPopupText.PREQUIZ_3, HelpPopupText.PREQUIZ_4, HelpPopupText.PREQUIZ_5, HelpPopupText.PREQUIZ_6, HelpPopupText.PREQUIZ_7, HelpPopupText.PREQUIZ_8, HelpPopupText.PREQUIZ_9]
    static let QUIZ = [HelpPopupText.QUIZ_1, HelpPopupText.QUIZ_2, HelpPopupText.QUIZ_3, HelpPopupText.QUIZ_4, HelpPopupText.QUIZ_5, HelpPopupText.QUIZ_6, HelpPopupText.QUIZ_7, HelpPopupText.QUIZ_8, HelpPopupText.SAVE]
}



/*later
struct SessionSavedValues {
    static var MODE = "Normal"
    //static var LATEST_PROBLEM = SaveProblem
}*/

class SavedProblem: NSObject, NSCoding {
    //if i need to, i can change this to only have strings and doubles...
    //like have a list of values (both converted and unconverted), list of units, etc.
    /*private var answers: [PhysicsVariable]
    private var knownValues: [PhysicsVariable]
    private var equation: String*/
    private var equation: String
    private var savedProblemName: String
    
    private var knownUnconvertedValues: [Double] = [Double]()
    private var knownConvertedValues: [Double] = [Double]()
    private var knownOriginalUnits: [String] = [String]()
    private var knownNames: [String] = [String]()
    
    private var answerValues: [Double] = [Double]()
    private var answerNames: [String] = [String]()
    
    private var prompt: String = "na"
    
    init(answers: [PhysicsVariable], knownValues: [PhysicsVariable], equation: String, savedProblemName: String, prompt: String) {
        for i in knownValues {
            self.knownUnconvertedValues.append(i.unConvertedValue)
            self.knownConvertedValues.append(i.value)
            self.knownOriginalUnits.append(i.unit)
            self.knownNames.append(i.name)
        }
        for i in answers {
            self.answerValues.append(i.value)
            self.answerNames.append(i.name)
        }
        self.equation = equation
        self.savedProblemName = savedProblemName
        self.prompt = prompt
    }
    
    init(equation: String, savedProblemName: String, knownUnconvertedValues: [Double], knownConvertedValues: [Double], knownOriginalUnits: [String], knownNames: [String], answerValues: [Double], answerNames: [String], prompt: String) {
        self.equation = equation
        self.savedProblemName = savedProblemName
        self.knownUnconvertedValues = knownUnconvertedValues
        self.knownConvertedValues = knownConvertedValues
        self.knownOriginalUnits = knownOriginalUnits
        self.knownNames = knownNames
        self.answerValues = answerValues
        self.answerNames = answerNames
        self.prompt = prompt
    }
    
    func getEquationName() -> String {
        return self.equation
    }

    func getSavedProblemName() -> String {
        return self.savedProblemName
    }
    
    func getPrompt() -> String {
        return self.prompt
    }
    
    func fixPrompt() {
        self.prompt = "na"
    }
    
    func getListOfVariables() -> [PhysicsVariable] {
        var listOfVars: [PhysicsVariable] = [PhysicsVariable]()
        for i in 0...knownNames.count-1 {
            let tempVari = PhysicsVariable.init(name: knownNames[i], value: knownConvertedValues[i])
            tempVari.unConvertedValue = knownUnconvertedValues[i]
            tempVari.unit = knownOriginalUnits[i]
            listOfVars.append(tempVari)
        }
        for i in 0...answerNames.count-1 {
            let tempVari = PhysicsVariable.init(name: answerNames[i], value: answerValues[i])
            listOfVars.append(tempVari)
        }
        return listOfVars
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let equation = aDecoder.decodeObject(forKey: "equation") as! String
        let savedProblemName = aDecoder.decodeObject(forKey: "savedProblemName") as! String
        let knownUnconvertedValues = aDecoder.decodeObject(forKey: "knownUnconvertedValues") as! [Double]
        let knownConvertedValues = aDecoder.decodeObject(forKey: "knownConvertedValues") as! [Double]
        let knownOriginalUnits = aDecoder.decodeObject(forKey: "knownOriginalUnits") as! [String]
        let knownNames = aDecoder.decodeObject(forKey: "knownNames") as! [String]
        let answerValues = aDecoder.decodeObject(forKey: "answerValues") as! [Double]
        let answerNames = aDecoder.decodeObject(forKey: "answerNames") as! [String]
        var prompt = "na"
        
        if UserDefaults.standard.getUpdate1_1_0() {
            var oldSavedProblem = false
            for i in UserDefaults.standard.getListOfPromptlessProblems() {
                if i == savedProblemName {
                    oldSavedProblem = true
                    print(i)
                }
            }
            
            if !oldSavedProblem {
                print(savedProblemName)
                print(UserDefaults.standard.getListOfPromptlessProblems())
                prompt = aDecoder.decodeObject(forKey: "prompt") as! String
            }
            
        }
        
        
        self.init(equation: equation, savedProblemName: savedProblemName, knownUnconvertedValues: knownUnconvertedValues, knownConvertedValues: knownConvertedValues, knownOriginalUnits: knownOriginalUnits, knownNames: knownNames, answerValues: answerValues, answerNames: answerNames, prompt: prompt)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(equation, forKey: "equation")
        aCoder.encode(savedProblemName, forKey: "savedProblemName")
        aCoder.encode(knownUnconvertedValues, forKey: "knownUnconvertedValues")
        aCoder.encode(knownConvertedValues, forKey: "knownConvertedValues")
        aCoder.encode(knownOriginalUnits, forKey: "knownOriginalUnits")
        aCoder.encode(knownNames, forKey: "knownNames")
        aCoder.encode(answerValues, forKey: "answerValues")
        aCoder.encode(answerNames, forKey: "answerNames")
        aCoder.encode(prompt, forKey: "prompt")
    }
    
}


/*settings tag:
 0: titleLabel
 1: returnBtn
 2: enableSciNotView
 3: decimalPntNumView
 4: enableSigFigView
 5: sigFigNumView
 6: saveBtn
 */

/*
 calculator tag:
 0: titleLabel (explain calculator, options)
 1: moreBtn
 2: settingsBtn
 3: varOne (label + field) I
 4: F
 5: A
 6: T
 7: D
 8: unit 1
 9: F U
 10: A U
 11: T U
 12: D U
 13: calculate (explain where answer goes)
 
 */
