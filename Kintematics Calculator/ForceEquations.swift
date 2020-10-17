//
//  ForceEquations.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/13/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class ForceEquations {
    private var a: PhysicsVariable = PhysicsVariable.init(name: "a")
    private var f: PhysicsVariable = PhysicsVariable.init(name: "f")
    private var m: PhysicsVariable = PhysicsVariable.init(name: "m")
    private var unknown:String = "N/A"
    
    init(listOfVars: [PhysicsVariable]) {
        a.isUnknown = true
        f.isUnknown = true
        m.isUnknown = true
        for i in listOfVars {
            switch i.name {
            case "a":
                a = i
            case "f":
                f = i
            case "m":
                m = i
            default:
                print("error w/ init force eq")
            }
        }
    }

    init(_ listOfVars: [PhysicsVariable], _ unknown: String) {
        switch unknown {
        case "f":
            f.isUnknown = true
        case "a":
            a.isUnknown = true
        case "m":
            m.isUnknown = true
        default:
            print("error- invalid unknown")
        }
        for i in listOfVars {
            switch i.name {
            case "a":
                a = i
            case "m":
                m = i
            case "f":
                f = i
            default:
                print("error w/ for loop")
            }
        }
    }
    
    func getUnknown() -> PhysicsVariable {
        switch true {
        case a.isUnknown:
            return a
        case f.isUnknown:
            return f
        case m.isUnknown:
            return m
        default:
            print("error- could not find unknown")
            return a
        }
    }
    
    func doEquation() {
        switch true {
        case a.isUnknown:
            a.value = f.value / m.value
        case f.isUnknown:
            f.value = m.value * a.value
        case m.isUnknown:
            m.value = f.value / a.value
        default:
            print("error- could not find unknown")
        }
    }
    
    func getF() -> PhysicsVariable {
        return self.f
    }
    
    func getM() -> PhysicsVariable {
        return self.m
    }
    
    func getA() -> PhysicsVariable {
        return self.a
    }
    
    func reset() {
        a.resetValue()
        f.resetValue()
        m.resetValue()
    }
    
    static func GET_ISOLATED_EQ(listOfVars: [PhysicsVariable], withValues: Bool) -> String {
        var eq: String = ""
        switch listOfVars[2].name {
        case "f":
            if withValues {
                eq = "f = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a"))"
            } else {
                eq = "f = m ✕ a"
            }
        case "m":
            if withValues {
                eq = "m = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "f")) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "a"))"
            } else {
                eq = "m = f / a"
            }
        case "a":
            if withValues {
                eq = "a = \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "f")) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m"))"
            } else {
                eq = "a = f / m"
            }
        default:
            print("error w/ getting isolated eq")
        }
        return eq
    }
}
