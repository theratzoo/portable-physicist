//
//  GravitationalForceEquation.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 6/6/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//
//  ISSUE: ROUNDING DOES NOT WORK FOR THIS... IDK IF THIS IS ISSUE OR NOT BUT DEAL W/ IT IN FUTURE
import Foundation

class GravitationalForceEquation {
    private var m1: PhysicsVariable = PhysicsVariable.init(name: "m1")
    private var m2: PhysicsVariable = PhysicsVariable.init(name: "m2")
    private var r: PhysicsVariable = PhysicsVariable.init(name: "r")
    private var fG: PhysicsVariable = PhysicsVariable.init(name: "fG")
    //6.754 * 10^-11
    private static var G: Double = 6.67 * Double(pow(Double(10),Double(-11)))
        
    init(listOfVars: [PhysicsVariable]) {
        m1.isUnknown = true
        m2.isUnknown = true
        r.isUnknown = true
        fG.isUnknown = true
        for i in listOfVars {
            switch i.name {
            case "m1":
                m1.equals(i)
                m1.isUnknown = false
            case "m2":
                m2.equals(i)
                m2.isUnknown = false
            case "r":
                r.equals(i)
                r.isUnknown = false
            case "fG":
                fG.equals(i)
                fG.isUnknown = false
            default:
                print("error w/ init in Grav")
            }
        }
    }
    
    init(listOfKnowns: [PhysicsVariable], unknown: String) {
        for i in listOfKnowns {
            switch i.name {
            case "m1":
                m1.equals(i)
            case "m2":
                m2.equals(i)
            case "r":
                r.equals(i)
            case "fG":
                fG.equals(i)
            default:
                print("error w/ init in Grav")
            }
        }
        switch unknown {
        case m1.name:
            m1.isUnknown = true
        case m2.name:
            m2.isUnknown = true
        case fG.name:
            fG.isUnknown = true
        case r.name:
            r.isUnknown = true
        default:
            print("erorr w/ setting up unknown")
        }
    }
    
    func solve() {
        switch true {
        case m1.isUnknown:
            m1.value = (fG.value * r.value * r.value) / (GravitationalForceEquation.G * m2.value)
        case m2.isUnknown:
            m2.value = (fG.value * r.value * r.value) / (GravitationalForceEquation.G * m1.value)
        case r.isUnknown:
            r.value = sqrt((GravitationalForceEquation.G * m1.value) * m2.value / (fG.value))
        case fG.isUnknown:
            fG.value = (GravitationalForceEquation.G * m1.value * m2.value) / (r.value * r.value)
        default:
            print("error w/ solve func")
        }
        //F = (G * m1 * m2) / r ^2
    }
    
    func getAnswer() -> PhysicsVariable {
        switch true {
        case m1.isUnknown:
            return m1
        case m2.isUnknown:
            return m2
        case r.isUnknown:
            return r
        case fG.isUnknown:
            return fG
            
        default:
            print("ERROR w/ getting answer for grav")
            return m1
        }
    }
    
    static func GET_ISOLATED_EQ(listOfVars: [PhysicsVariable], withValues: Bool) -> String {
        var eq: String = ""
        switch listOfVars[3].name {
        case "fG":
            if withValues {
                eq = "Fg =   \(GravitationalForceEquation.G) ✕ (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m1")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m2")))" + "/\(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "r"))^2"))"
            } else {
                eq = "Fg = G ✕ (m\u{2081} ✕ m\u{2082}) / \(Helper.exponentize(str: "r^2"))"
            }
        case "m1":
            if withValues {
                eq = "m\u{2081} =  (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fG")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "r"))^2"))) / (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m2")) ✕ \(GravitationalForceEquation.G)"
            } else {
                eq = "m\u{2081} = (Fg ✕ \(Helper.exponentize(str: "r^2"))) / (m\u{2082} ✕ G)"
            }
        case "m2":
            if withValues {
                eq = "m\u{2082} =  (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fG")) ✕ \(Helper.exponentize(str: "\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "r"))^2"))) / (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m1")) ✕ \(GravitationalForceEquation.G)"
            } else {
                eq = "m\u{2082} = (Fg ✕ \(Helper.exponentize(str: "r^2"))) / (m\u{2081} ✕ G)"
            }
        case "r":
            if withValues {
                eq = "r =   (\(GravitationalForceEquation.G) ✕ (\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m1")) ✕ \(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "m2")))" + "/\(Helper.INITIALIZE_VALUES(listOfVars: listOfVars, varName: "fG"))\(Helper.exponentize(str: ")^1/2"))"
            } else {
                eq = "r = (G ✕ (m\u{2081} ✕ m\u{2082}) / Fg\(Helper.exponentize(str: ")^1/2"))"
                
            }
        default:
            print("error w/ getting isolated eq")
        }
        return eq
    }
    
}
