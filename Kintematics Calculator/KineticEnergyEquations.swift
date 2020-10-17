//
//  KineticEnergyEquations.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/25/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class KineticEnergyEquations {
    private var v: PhysicsVariable = PhysicsVariable.init(name: "v")
    private var k: PhysicsVariable = PhysicsVariable.init(name: "k")
    private var m: PhysicsVariable = PhysicsVariable.init(name: "m")
    private var unknown: String = "N/A"
    
    init(listOfKnowns: [PhysicsVariable]) {
        for i in listOfKnowns {
            setKnowns(u: i)
        }
        setUnknown()
    }
    //idk if i need this init since there will always be one unknown
    init(listOfKnowns: [PhysicsVariable], unknown: String) {
        self.unknown = unknown
        for i in listOfKnowns {
            setKnowns(u: i)
        }
        setUnknown()
    }
    
    func setKnowns(u: PhysicsVariable) {
        switch u.name {
        case "v":
            v.value = u.value
        case "k":
            k.value = u.value
        case "m":
            m.value = u.value
        default:
            print("error- could not set knowns")
        }
    }
    
    func setUnknown() {
        switch false {
        case v.isValueSet:
            v.isUnknown = true
        case k.isValueSet:
            k.isUnknown = true
        case m.isValueSet:
            m.isUnknown = true
        default:
            print("error- could not set unknowns")
        }
    }
    
    func solve() {
        switch true {
        case k.isUnknown:
            k.value = 0.5 * m.value * v.value * v.value
        case m.isUnknown:
            m.value = (k.value * 2.0) / (v.value * v.value)
        case v.isUnknown:
            v.value = sqrt((2.0 * k.value) / m.value)
        default:
            print("error: could not solve")
        }
    }
    
    func getUnknown() -> PhysicsVariable {
        switch true {
        case v.isUnknown:
            return v
        case k.isUnknown:
            return k
        case m.isUnknown:
            return m
        default:
            print("ERROR: could not get unknown")
        }
        return v
    }
    
    func getListOfVars() -> [PhysicsVariable] {
        var listOfVars: [PhysicsVariable] = [PhysicsVariable]()
        listOfVars.append(k)
        listOfVars.append(m)
        listOfVars.append(v)
        return listOfVars
    }
    
    func reset() {
        v.resetValue()
        m.resetValue()
        k.resetValue()
        unknown = "N/A"
    }
    
    static func GET_ISOLATED_EQ(listOfVars: [PhysicsVariable], withValues: Bool) -> String {
        var eq: String = ""
        switch listOfVars[2].name {
        case "k":
            if withValues {
                eq = "K = ½ ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "v"))^2"))"
            } else {
                eq = "K = ½ ✕ m ✕ \(Helper.exponentize(str: "v^2"))"
            }
        case "m":
            if withValues {
                eq = "m = 2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "k")) / \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "v"))^2"))"
            } else {
                eq = "m = 2 ✕ K / \(Helper.exponentize(str: "v^2"))"
            }
        case "v":
            if withValues {
                eq = "a = (2 ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "k")) / \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m"))\(Helper.exponentize(str: ")^1/2"))"
            } else {
                eq = "v = (2 ✕ K / m\(Helper.exponentize(str: ")^1/2"))"
            }
        default:
            print("error w/ getting isolated eq")
        }
        return eq
    }
    
}
