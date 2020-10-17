//
//  KinematicsEquations.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 4/28/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class KinematicsEquations {
    private var a : PhysicsVariable = PhysicsVariable.init(name: "a")
    private var iV : PhysicsVariable = PhysicsVariable.init(name: "iV")
    private var fV : PhysicsVariable = PhysicsVariable.init(name: "fV")
    private var t : PhysicsVariable = PhysicsVariable.init(name: "t")
    private var d : PhysicsVariable = PhysicsVariable.init(name: "d")
    private var unknown : String = "NIL"
    
    
    init(listOfKnowns: [PhysicsVariable]) {
        a.isUnknown = true
        fV.isUnknown = true
        iV.isUnknown = true
        t.isUnknown = true
        d.isUnknown = true
        setKnowns(u: listOfKnowns[0])
        setKnowns(u: listOfKnowns[1])
        setKnowns(u: listOfKnowns[2])
    }
    
    init(_ listOfKnowns: [PhysicsVariable], _ unknown : String) {

        self.unknown = unknown
        setKnowns(u: listOfKnowns[0])
        setKnowns(u: listOfKnowns[1])
        setKnowns(u: listOfKnowns[2])
        
    }
    
    func setKnowns(u : PhysicsVariable) {
        switch u.name {
        case "a":
            a.value = u.value
            a.isUnknown = false
            a.unit = u.unit
        case "iV":
            iV = u
            iV.isUnknown = false
        case "fV":
            fV = u
            fV.isUnknown = false
        case "t":
            t = u
            t.isUnknown = false
        case "d":
            d = u
            d.isUnknown = false
        default:
            print("error")
        }
    }
    
    func doKinemtaicsEquation() {
        if unknown != "NIL" {
            switch true {
            case !a.isValueSet && a.name != unknown:
                kinematicsEquationD()
            case !t.isValueSet && t.name != unknown:
                kinematicsEquationC()
            case !fV.isValueSet && fV.name != unknown:
                kinematicsEquationB()
            case !d.isValueSet && d.name != unknown:
                kinematicsEquationA()
            case !iV.isValueSet && iV.name != unknown:
                kinematicsEquationE()
            doTheEqs()
            default:
                print("error doing eq")
            }
        } else {
            switch false {
            case a.isValueSet:
                kinematicsEquationD()
            case t.isValueSet:
                kinematicsEquationC()
            case fV.isValueSet:
                kinematicsEquationB()
            case d.isValueSet:
                kinematicsEquationA()
            case iV.isValueSet:
                kinematicsEquationE()
            default:
                print("error doing eq")
            }
            while(!testValues()) {
                doTheEqs()
            }
        }
        
    }
    private func testValues() -> Bool {
        
        if fV.isValueSet && iV.isValueSet && d.isValueSet && t.isValueSet && a.isValueSet {
            return true
        } else {
            return false
        }

    }
    
    private func doTheEqs() {
        kinematicsEquationA()
        kinematicsEquationB()
        kinematicsEquationC()
        kinematicsEquationD()
        kinematicsEquationE()
    }
    
    func isFirstUnknown() -> Bool {
        switch true {
        case iV.isUnknown:
            return false
        case fV.isUnknown:
            return false
        case d.isUnknown:
            return false
        case a.isUnknown:
            return false
        case t.isUnknown:
            return false
        default:
            return true
        }
    }
    
    
    func kinematicsEquationA() {
        switch false {
        case fV.isValueSet:
            if isFirstUnknown() {
                fV.unknownNumber = 1
            } else {
                fV.unknownNumber  = 2
            }
            fV.unknownEq = "A"
            fV.isUnknown = true
            fV.value = iV.value + (a.value * t.value)
            
        case t.isValueSet:
            if isFirstUnknown() {
                t.unknownNumber  = 1
            } else {
                t.unknownNumber  = 2
            }
            t.unknownEq = "A"
            t.isUnknown = true
            t.value = (fV.value - iV.value) / a.value
            if t.value < 0 {
                if fV.isUnknown {
                    fV.value *= -1
                } else {
                    iV.value *= -1
                }
                t.value = 23.7
                t.isValueSet = false
                kinematicsEquationA()
            }
        case iV.isValueSet:
            if isFirstUnknown() {
                iV.unknownNumber  = 1
                
            } else {
                iV.unknownNumber  = 2
            }
            iV.unknownEq = "A"
            iV.isUnknown = true
                iV.value = fV.value - (a.value * t.value)
            
        case a.isValueSet:
            if isFirstUnknown() {
                a.unknownNumber  = 1
            } else {
                a.unknownNumber  = 2
            }
            a.unknownEq = "A"
            a.isUnknown = true
            
                a.value = (fV.value - iV.value) / t.value
            
        default:
            break
        }
        //vf = vi + at
    }
    func kinematicsEquationB() {
        switch false {
        case d.isValueSet:
            if isFirstUnknown() {
                d.unknownNumber = 1
            } else {
                d.unknownNumber = 2
            }
            d.unknownEq = "B"
            d.isUnknown = true
            
                d.value = (iV.value * t.value) + (0.5 * a.value * t.value * t.value)
            
        case t.isValueSet:
            if isFirstUnknown() {
                t.unknownNumber = 1
            } else {
                t.unknownNumber = 2
            }
            t.unknownEq = "B"
            t.isUnknown = true
            t.value = specialCase() //code
            
        case iV.isValueSet:
            if isFirstUnknown() {
                iV.unknownNumber = 1
            } else {
                iV.unknownNumber = 2
            }
            iV.unknownEq = "B"
            iV.isUnknown = true
            
                iV.value = (d.value - (0.5 * a.value * (t.value * t.value))) / t.value
            
            
        case a.isValueSet:
            if isFirstUnknown() {
                a.unknownNumber = 1
            } else {
                a.unknownNumber = 2
            }
            a.unknownEq = "B"
            a.isUnknown = true
            
                a.value = 2.0 * (d.value - (iV.value * t.value)) / (t.value * t.value)
            
        default:
            break
        }
        
        //d = vit + .5at^2
    }
    func kinematicsEquationC() {
        switch false {
        case d.isValueSet:
            if isFirstUnknown() {
                d.unknownNumber  = 1
            } else {
                d.unknownNumber  = 2
            }
            d.unknownEq = "C"
            d.isUnknown = true
            
                d.value = (0.5 * ((fV.value * fV.value) - (iV.value * iV.value))) / a.value
            
        case fV.isValueSet:
            if isFirstUnknown() {
                fV.unknownNumber = 1
            } else {
                fV.unknownNumber = 2
            }
            fV.unknownEq = "C"
            fV.isUnknown = true
            
                fV.value = sqrt((iV.value * iV.value) + (2.0 * a.value * d.value))
            
        case iV.isValueSet:
            if isFirstUnknown() {
                iV.unknownNumber = 1
            } else {
                iV.unknownNumber = 2
            }
            iV.unknownEq = "C"
            iV.isUnknown = true
            
                iV.value = sqrt((fV.value * fV.value) - (2.0 * a.value * d.value))
            
        case a.isValueSet:
            if isFirstUnknown() {
                a.unknownNumber  = 1
            } else {
                a.unknownNumber  = 2
            }
            a.unknownEq = "C"
            a.isUnknown = true
            
                a.value = (0.5 * ((fV.value * fV.value) - (iV.value * iV.value))) / d.value
            
        default:
            break
        }
        //vf^2 = vi^2 + 2ad
    }
    func kinematicsEquationD() {
        switch false {
        case d.isValueSet:
            if isFirstUnknown() {
                d.unknownNumber = 1
            } else {
                d.unknownNumber = 2
            }
            d.unknownEq = "D"
            d.isUnknown = true
            
                d.value = (t.value * (iV.value + fV.value)) / 2.0
            
        case t.isValueSet:
            if isFirstUnknown() {
                t.unknownNumber  = 1
            } else {
                t.unknownNumber  = 2
            }
            t.unknownEq = "D"
            t.isUnknown = true
            t.value = (2.0 * d.value) / (iV.value + fV.value)
        case iV.isValueSet:
            if isFirstUnknown() {
                iV.unknownNumber  = 1
            } else {
                iV.unknownNumber  = 2
            }
            iV.unknownEq = "D"
            iV.isUnknown = true
            
                iV.value = ((2.0 * d.value) / t.value) - fV.value
            
        case fV.isValueSet:
            if isFirstUnknown() {
                fV.unknownNumber = 1
            } else {
                fV.unknownNumber = 2
            }
            fV.unknownEq = "D"
            fV.isUnknown = true
            
            
                fV.value = ((2.0 * d.value) / t.value) - iV.value
            
        default:
            break
        }
        //d = t(vo + v) /2

    }
    
    func kinematicsEquationE() {
        switch false {
        case d.isValueSet:
            if isFirstUnknown() {
                d.unknownNumber = 1
            } else {
                d.unknownNumber = 2
            }
            d.unknownEq = "E"
            d.isUnknown = true
            
                d.value = (fV.value * t.value) - (0.5 * a.value * t.value * t.value)
            
        case t.isValueSet:
            if isFirstUnknown() {
                t.unknownNumber  = 1
            } else {
                t.unknownNumber  = 2
            }
            t.unknownEq = "E"
            t.isUnknown = true
            t.value = specialCase()
            print("error- too lazy to quad this shit")
        case a.isValueSet:
            if isFirstUnknown() {
                a.unknownNumber  = 1
            } else {
                a.unknownNumber  = 2
            }
            a.unknownEq = "E"
            a.isUnknown = true
            
                a.value = 2.0 * ((fV.value * t.value) - d.value) / (t.value * t.value)
            
        case fV.isValueSet:
            if isFirstUnknown() {
                fV.unknownNumber  = 1
            } else {
                fV.unknownNumber  = 2
            }
            fV.unknownEq = "E"
            fV.isUnknown = true
            
                fV.value = (d.value + (0.5 * a.value * t.value * t.value)) / t.value
        default:
            break
        }
        //d = vFt - 1/2 a t ^2
    }
    
    //gets only one answer, only applicable if there is an unknown set (i.e. practice problem/quiz only asking for 1 value)
    func getSingleUnknown() -> PhysicsVariable {
        switch unknown {
        case "fV":
            return fV
        case "iV":
            return iV
        case "d":
            return d
        case "a":
            return a
        case "t":
            return t
        default:
            print("error getting unknown")
            return fV
        }
    }
    
    //gets both answers
    func getAnswers() -> [PhysicsVariable] {
        var phiz: [PhysicsVariable] = [PhysicsVariable]()
        for i in 0...1 {
            switch true {
            case fV.isUnknown && check(list: phiz, theVar: fV, i: i):
                phiz.append(fV)
            case iV.isUnknown && check(list: phiz, theVar: iV, i: i):
                phiz.append(iV)
            case a.isUnknown && check(list: phiz, theVar: a, i: i):
                phiz.append(a)
            case t.isUnknown && check(list: phiz, theVar: t, i: i):
                phiz.append(t)
            case d.isUnknown && check(list: phiz, theVar: d, i: i):
                phiz.append(d)
            default:
                print("error w/ getting answer")
            }
        }
        return phiz
    }
    
    func check(list: [PhysicsVariable], theVar: PhysicsVariable, i: Int) -> Bool {
        if list.isEmpty || i == 0 {
            return true
        } else if list[0].name == theVar.name {
            return false
        }
        return true
    }
    //Note: only need to get the first equation, not the second, as the second can literally be any of the other 4 equations
    static func GET_EQUATION(listOfVars: [PhysicsVariable]) -> Int {
        var eqs : Int = 0
        switch listOfVars.last?.name { //on page 8 kinematics: Fatal error: index out of range
        case "a":
            eqs = 4
        case "fV":
            eqs = 2
        case "d":
            eqs = 1
        case "t":
            eqs = 3
        case "iV":
            eqs = 5
        default:
            print("error w/ getting eqs")
        }
        
        return eqs
    }
    
    
    func specialCase() -> Double {
        //uses quadratic equation to solve for t for KinematicsEquationB... WIP
        return 0
    }
    
    static func GET_ISOLATED_EQ(listOfVars: [PhysicsVariable], unknownNum: Int, withValues: Bool) -> String {
        //can later turn these into images
        var eq: String =  ""
        switch unknownNum {
        case 1:
            switch listOfVars[3].name {
            case "iV":
                if withValues {
                    eq = "iV = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))"
                } else {
                    eq = "iV = fV - a ✕ t"
                }
            case "fV":
                if withValues {
                    eq = "fV = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV")) + \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))"
                } else {
                    eq = "fV = iV + a ✕ t"
                }
            case "t":
                if withValues {
                    eq = "t = (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))) / a"
                } else {
                    eq = "t = (fV - iV) / a"
                }
            case "a":
                if withValues {
                    eq = "a = (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))"
                } else {
                    eq = "a = (fV - iV) / t"
                }
            default:
                print("error w/ getting isolated eq")
            }
        case 2:
            switch listOfVars[3].name {
            case "iV":
                if withValues {
                    eq = "iV = (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d")) - (½ ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2"))))/\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))"
                } else {
                    eq = "iV = (d - (½ ✕ a ✕ \(Helper.exponentize(str: "t^2"))))/t"
                }
            case "d":
                if withValues {
                    eq = "d = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))*\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")) + ½ ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2"))"
                } else {
                    eq = "d = iV*t + ½ ✕ a ✕ \(Helper.exponentize(str: "t^2"))"
                }
            case "t":
                if withValues {
                    eq = "ERROR"
                } else {
                    eq = "ERROR"
                }
            case "a":
                if withValues {
                    eq = "a = 2 ✕ (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d")) - (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")))) / \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2"))"
                } else {
                    eq = "a = 2 ✕ (d - (iV ✕ t)) / \(Helper.exponentize(str: "t^2"))"
                }
            default:
                print("error w/ getting isolated eq")
            }
        case 3:
            switch listOfVars[3].name {
            case "iV":
                if withValues {
                    eq = "iV = (\(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV"))^2")) - 2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))\(Helper.exponentize(str: ")^1/2"))"
                } else {
                    eq = "iV = (\(Helper.exponentize(str: "fV^2")) - 2 ✕ a ✕ d\(Helper.exponentize(str: ")^1/2"))"
                }
            case "fV":
                if withValues {
                    eq = "fV = (\(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))^2")) + 2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))\(Helper.exponentize(str: ")^1/2"))"
                } else {
                    eq = "fV = (\(Helper.exponentize(str: "iV^2")) + 2 ✕ a ✕ d\(Helper.exponentize(str: ")^1/2"))"
                }
            case "d":
                if withValues {
                    eq = "d = (½ ✕ (\(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV"))^2")) - \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))^2")))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a"))"
                } else {
                    
                    eq = "d = (½ ✕ (\(Helper.exponentize(str: "fV^2")) - \(Helper.exponentize(str: "iV^2")))) / a"
                }
            case "a":
                if withValues {
                    eq = "a = (½ ✕ (\(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV"))^2")) - \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))^2")))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))"
                } else {
                    eq = "a = (½ ✕ (\(Helper.exponentize(str: "fV^2")) - \(Helper.exponentize(str: "iV^2")))) / d"
                }
            default:
                print("error w/ getting isolated eq")
            }
        case 4:
            switch listOfVars[3].name {
            case "iV":
                if withValues {
                    eq = "iV = (2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV"))"
                } else {
                    eq = "iV = (2 ✕ d) / t - fV"
                }
                //\u{2080} to get subscripted 0
            case "fV":
                if withValues {
                    eq = "fV = (2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV"))"
                } else {
                    eq = "fV = (2 ✕ d) / t - iV"
                }
            case "t":
                if withValues {
                    eq = "t = (2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))) / (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV")) + \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")))"
                } else {
                    eq = "t = (2 ✕ d) / (iV + fV)"
                }
            case "d":
                if withValues {
                    eq = "d = (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")) ✕ (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "iV")) + \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")))) / 2"
                } else {
                    eq = "d = (t ✕ (iV + fV)) / 2"
                }
            default:
                print("error w/ getting isolated eq")
            }
        case 5:
            switch listOfVars[3].name {
            case "d":
                if withValues {
                    eq = "d = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t")) - ½ ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2"))"
                } else {
                    eq = "d = fV ✕ t - ½ ✕ a ✕ \(Helper.exponentize(str: "t^2"))"
                }
            case "fV":
                if withValues {
                    eq = "fV = (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d")) + (½ ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2")))) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))"
                } else {
                    eq = "fV = (d + (½ ✕ a ✕ \(Helper.exponentize(str: "t^2")))) / t"
                }
            case "t":
                if withValues {
                    eq = "t"
                } else {
                    eq = "ERROR"
                }
            case "a":
                if withValues {
                    eq = "a = 2 ✕ ((\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fV")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))) - \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "d"))) / \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "t"))^2"))"
                } else {
                    eq = "a = 2 ✕ ((fV ✕ t) - d) / \(Helper.exponentize(str: "t^2"))"
                }
            default:
                print("error w/ getting isolated eq!")
            }
        default:
            print("error w/ getting isolated eq. eq number: \(unknownNum)")
        }
        return eq
    }
    
}
