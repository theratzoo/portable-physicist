//
//  Quiz.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/2/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import Foundation

class Quiz {
    private static var VALUE_UNSET : Double = 23.7
    
    var prompt: String
    var answer: PhysicsVariable
    init(_ prompt: String, _ answer: PhysicsVariable) {
        self.prompt = prompt
        self.answer = answer
        //PracticeProblemsViewController().generateProblemQ()
    }
    init() {
        self.prompt = "wait"
        self.answer = KinematicsVariable.init(name: "nothing yet")
    }
    //wip...
    func getRandomProblem() {
        
    }
    
}
