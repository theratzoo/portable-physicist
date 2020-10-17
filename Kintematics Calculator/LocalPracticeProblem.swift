//
//  LocalPracticeProblem.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 1/7/19.
//  Copyright © 2019 Luke Deratzou. All rights reserved.
//
//Class that "stores" all vars needed to save a local practice problem. Loads up this saved practice problem so long as user does not restart the app.
import Foundation


/*struct LocalPracticeProblem {
    //static var LIST_OF_VARS: [PhysicsVariable]
    
    static var LIST_OF_VARS : ([PhysicsVariable]) -> () {
        get {
            return LIST_OF_VARS
        }
        set {
            
        }
    }
}*/

class LocalPracticeProblem {
    
    private var listOfVars: [PhysicsVariable]
    private var promptNum: Int
    private var listOfMCOptions: [String]
    private var correctMCOption: String
    
    static var LIST_OF_VARS: [PhysicsVariable] = [PhysicsVariable]()
    static var PROMPT_NUM: Int = -1
    static var LIST_OF_MC_OPTIONS: [String] = [String]()
    static var CORRECT_MC_OPTION: String = "-1"
    
    static var IS_THERE_A_PROBLEM_SAVED: Bool = false //depricated
    
    static var EQUATION_NAME: String = "None"
    static var UNIT_TYPE: String = "SI (base)"
    
    static var LIST_OF_VARS_FOR_SAVE: [PhysicsVariable] = [PhysicsVariable]()
    
    init(listOfVars: [PhysicsVariable], promptNum: Int, listOfMCOptions: [String], correctMCOption: String, equationName: String, unitType: String, listOfProblemsForSave: [PhysicsVariable]) {
        self.listOfVars = listOfVars
        LocalPracticeProblem.LIST_OF_VARS = listOfVars
        self.promptNum = promptNum
        LocalPracticeProblem.PROMPT_NUM = promptNum
        self.listOfMCOptions = listOfMCOptions
        LocalPracticeProblem.LIST_OF_MC_OPTIONS = listOfMCOptions
        self.correctMCOption = correctMCOption
        LocalPracticeProblem.CORRECT_MC_OPTION = correctMCOption
        LocalPracticeProblem.IS_THERE_A_PROBLEM_SAVED = true
        LocalPracticeProblem.EQUATION_NAME = equationName
        LocalPracticeProblem.UNIT_TYPE = unitType
        LocalPracticeProblem.LIST_OF_VARS_FOR_SAVE = listOfProblemsForSave
    }
    
    static func GET_LIST_OF_VARS() -> [PhysicsVariable] {
        return LIST_OF_VARS
    }
    
    static func GET_PROMPT_NUM() -> Int {
        return PROMPT_NUM
    }
    
    static func GET_LIST_OF_MC_OPTIONS() -> [String] {
        return LIST_OF_MC_OPTIONS
    }
    
    static func GET_CORRECT_MC_OPTION() -> String {
        return CORRECT_MC_OPTION
    }
    
    static func GET_EQUATION_NAME() -> String {
        return EQUATION_NAME
    }
    
    static func GET_UNIT_TYPE() -> String {
        return UNIT_TYPE
    }
    
    static func GET_LIST_VARS_FOR_SAVE() -> [PhysicsVariable] {
        return LIST_OF_VARS_FOR_SAVE
    }
    
    //DEPRICATED
    func getListOfVars() -> [PhysicsVariable] {
        return listOfVars
    }
    
    func getPromptNum() -> Int {
        return promptNum
    }
    
    func getListOfMCOptions() -> [String] {
        return listOfMCOptions
    }
    
    func getCorrectMCOptions() -> String {
        return correctMCOption
    }
    
    static func RESET() {
        LIST_OF_VARS.removeAll()
        PROMPT_NUM = -1
        LIST_OF_MC_OPTIONS.removeAll()
        CORRECT_MC_OPTION = "-1"
        LIST_OF_VARS_FOR_SAVE.removeAll()
    }
    
}
