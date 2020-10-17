//
//  PracticeProblemsViewController.swift
//  Kintematics Calculator
//
//  Created by Ben Deratzou on 3/9/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//
//Features:
//Add way to look at previous problems (maybe)
//Hints! Base these off of steps from the showWorkTextView in the calculator
//Points system??? for correct answers to reward people??
//Maybe add problems with pictures in the future???
//Problems with angles, ap styled ones, etc. for more of a challenge -> can also have a challenge mode option or just difficulties
//Graph problems!
//btn that gives options for different types of problems- ones with pictures, ones with graphs, ones with angles, ones that are easier/harder, multiple choice, etc.

//old ap problems- change names and other small parts
//A car is initially moving at \(ViewController.GlobalVariable.iV) m/s along a track. After traveling \(ViewController.GlobalVariable.d) m, the car is now moving at a speed of \(ViewController.GlobalVariable.fV) m/s. What is the car's acceleration?
//Need to convert before putting values in kinematics calculator for problems- maybe use the converter from UnitConverterViewController...

//Prompt ideas:


//Make problems more "realistic"- numbers should be reasonable sized, signs should make sense, etc.


//Stuff to do before launch:

//*make problems realistic- make sure numbers make sense
//*make sure the answers come from the numbers given to the user!!
//*make sure rounding is working properly

//*make it default that units are in SI, make settings to do differing units (might wait till later to implement that in fact...)
//(for above, actually instead have 3 levels: one with only SI units, one with SI units and easy-to-convert units (i.e. metric units) and one with all units (that will maybe have a notice that answers may deviate from the user's)

//Alpha Notes:

//MAKE SURE PROBLEMS ACTUALLY MAKE SENSE
//DON'T ROUND THE VALUES- JUST MAKE THEM READABLE; ONLY ROUND IN REASON. CAN ALSO USE X*10^Y OR X*10^-Y FOR BETTER FORMATING

import UIKit

class PracticeProblemsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var checkAnswerBtn: UIButton!
    @IBOutlet weak var mcview: UIView!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var selectUnitBtn: UIButton!
    
    @IBOutlet weak var saveProblemBtn: UIButton!
    
    var unitsPickerData : [String] = [String]()
    var listOfPrompts : [String] = ["Hi. Acceleration = , Initial Velocity = , Displacement = . What is the Final Velocity?", "Hello. Time = , Final Velocity = , Displacement = . What is the Initial Velocity?", "hey. Time = , Displacement = , Acceleration = . What is the Final Velocity?", "howdy. Acceleration = , Initial Velocity = , Time = . What is Displacement?", "A car is initially moving at m/s along a highway. After traveling  m, the car is now moving at a speed of  m/s. What is the car's acceleration (in m/s^2)?", "Tim throws a ball into the air. After t seconds, the ball is traveling in the air at vF. How far did the ball travel in the air (in meters)? Note: this was done on Earth, which has an acceleration due to gravity equal to 9.81m/s^2"]
    var unitsChosen : String = "Select a unit..."
    var listOfRandomSpeeds : [String] = ["miles/hour", "meters/second", "kilometers/hour"]
    var listOfRandomDistances : [String] = ["meters", "miles", "kilometers"]
    var listOfRandomTimes : [String] = ["seconds", "minutes"]
    
    var buttonA: UIButton!
    var buttonB: UIButton!
    var buttonC: UIButton!
    var buttonD: UIButton!
    var labelA: UILabel!
    var labelB: UILabel!
    var labelC: UILabel!
    var labelD: UILabel!
    
    var listOfMCOptions: [String] = [String]()
    
    //idea #2: have a list. the list can have shit added to it.
    
    var listOfVars: [PhysicsVariable] = [PhysicsVariable]()
    
    var listOfVarsForSaved: [PhysicsVariable] = [PhysicsVariable]()
    
    var toPass: String = ""
    
    var eqName: String = ""
    var typeOfQuestion: String = ""
    
    var randomPrompt : Int = -1
    var areUnitsEnabled: Bool = false
    var correctMCLetter: String = "X"
    var typeOfUnitsShown: String = "not set"
    
    var didUserFinishProblem: Bool = false
    var bottomView: UIView!
    
    var savedName = "Saved Problem \(Int(UserDefaults.standard.getSavedProblemCounter()))"
    
    var exitHelpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatButtonsAndLabels()
        if Helper.MODE == "Help" {
            helpMode()
            return
        }
        mcview.tag = -1
        hintBtn.isHidden = true
        answerTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        if UserDefaults.standard.getCurrentPhysicsEqPP() != "None" {
            toPass = UserDefaults.standard.getCurrentPhysicsEqPP()
            toPass = toPass.lowercased()
            print(toPass)
        } else {
            print("FATAL ERROR")
        }
        
        switch toPass {
        case "kinematics":
            eqName = "kinematics"
            unitsPickerData = ["Select units...", "meters/second", "seconds", Helper.exponentize(str: "meters/second^2"), "meters"]
        case "forces":
            eqName = "forces"
            unitsPickerData = ["Select units...", "Newtons", "kilograms", Helper.exponentize(str: "meters/second^2")]
        case "kinetic energy":
            eqName = "kinetic energy"
            unitsPickerData = ["Select units...", "Joules", "kilograms", "meters/second"]
        case "gravitational force":
            eqName = "gravitational force"
            unitsPickerData = ["Select units...", "Newtons", "kilograms", "meters"]
        default:
            eqName = getRandomProblemName()
        }
        
        
        setUpProblemType()
        generateProblem()
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //can later make sure that sufficient data is passed so that when ViewDidLoad is called, it can check if it came from Options and if it did, than it can reload the same problem that was present.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Helper.MODE == "Help" {
            if exitHelpMode {
                Helper.MODE = "Normal"
            }
            return
        }
        saveMC()
        if !didUserFinishProblem {
            if listOfVarsForSaved.isEmpty {
                listOfVarsForSaved = listOfVars
            }
            _ = LocalPracticeProblem.init(listOfVars: listOfVars, promptNum: randomPrompt, listOfMCOptions: listOfMCOptions, correctMCOption: correctMCLetter, equationName: eqName, unitType: UserDefaults.standard.getProblemUnitsPP(), listOfProblemsForSave: listOfVarsForSaved)
        }
        if (segue.identifier == "options") {
            let svc = segue.destination as! OptionsViewController;
            svc.toPass = "PP \(eqName)"
            
        } else if segue.identifier == "settings" {
            let svc = segue.destination as! SettingsViewController;
            svc.toPass = "practiceproblems"
        }
    }
    
    //WIP TEST
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        checkAnswerBtn.isEnabled = true
        answerTextField.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func formatButtonsAndLabels() {
        var cornerRadius: CGFloat = 10
        if self.view.frame.width > 500 {
            cornerRadius = 25
        }
        answerTextField.layer.masksToBounds = true
        answerTextField.layer.cornerRadius = cornerRadius
        checkAnswerBtn.isEnabled = false
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = cornerRadius
        titleLabel.text = "Practice Problems- \(UserDefaults.standard.getCurrentPhysicsEqPP().capitalized)"
        problemTextView.layer.masksToBounds = true
        problemTextView.layer.cornerRadius = 25
        if self.view.frame.width > 500 {
            problemTextView.font = UIFont(name: "Menlo", size: 42)
            
        } else {
            answerTextField.font = answerTextField.font?.withSize(14)
        }
        
        //button stuff
        
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            hintBtn.frame = CGRect(x: hintBtn.frame.minX, y: hintBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            moreBtn.frame = CGRect(x: moreBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
            settingsBtn.frame = CGRect(x: settingsBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
            arrowBtn.frame = CGRect(x: arrowBtn.frame.minX, y: arrowBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        } else {
            hintBtn.frame = CGRect(x: hintBtn.frame.minX, y: hintBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            moreBtn.frame = CGRect(x: moreBtn.frame.minX, y: moreBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            settingsBtn.frame = CGRect(x: settingsBtn.frame.minX, y: settingsBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            arrowBtn.frame = CGRect(x: arrowBtn.frame.minX, y: arrowBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        }
        
        if checkAnswerBtn.frame.width / 100 > checkAnswerBtn.frame.height / 25 {
            let newWidth: CGFloat = checkAnswerBtn.frame.height * (100/25)
            checkAnswerBtn.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: checkAnswerBtn.frame.minY, width: newWidth, height: checkAnswerBtn.frame.height)
        } else {
            let newHeight: CGFloat = checkAnswerBtn.frame.width * (25/100)
            checkAnswerBtn.frame = CGRect(x: checkAnswerBtn.frame.minX, y: checkAnswerBtn.frame.minY, width: checkAnswerBtn.frame.width, height: newHeight)
        }
        
        if saveProblemBtn.frame.width / 60 > saveProblemBtn.frame.height / 20 {
            let newWidth: CGFloat = saveProblemBtn.frame.height * (60/20)
            saveProblemBtn.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: saveProblemBtn.frame.minY, width: newWidth, height: saveProblemBtn.frame.height)
        } else {
            let newHeight: CGFloat = saveProblemBtn.frame.width * (20/60)
            saveProblemBtn.frame = CGRect(x: saveProblemBtn.frame.minX, y: saveProblemBtn.frame.minY, width: saveProblemBtn.frame.width, height: newHeight)
        }
        
    }
    
    func isInvalidProblem() -> Bool {
        for i in listOfVars {
            if i.isScalar && i.value < 0 {
                print(i.name)
                print(i.value)
                return true
            }
        }
        return false
    }
    
    func isNan() -> Bool{
        if (listOfVars.last?.value.isNaN)! {
            return false
        }
        return true
        
    }
    
    @IBAction func nextProblemBtnAction(_ sender: UIButton) {
        if toPass == "all (random)" {
            eqName = getRandomProblemName()
        }
        checkAnswerBtn.isEnabled = false
        didUserFinishProblem = false
        answerTextField.backgroundColor = UIColor.white
        hintBtn.isHidden = true
        randomPrompt = -1
        LocalPracticeProblem.RESET()
        pickRandomProblemType()
        generateProblem()
        answerTextField.text?.removeAll()
    }
    
    func getRandomProblemName() -> String {
        switch arc4random_uniform(4) {
        case 0:
            unitsPickerData = ["Select units...", "meters/second", "seconds", Helper.exponentize(str: "meters/second^2"), "meters"]
            return "kinematics"
        case 1:
            unitsPickerData = ["Select units...", "Newtons", "kilograms", Helper.exponentize(str: "meters/second^2")]
            return "forces"
        case 2:
            unitsPickerData = ["Select units...", "Joules", "kilograms", "meters/second"]
            return "kinetic energy"
            
        case 3:
            unitsPickerData = ["Select units...", "Newtons", "kilograms", "meters"]
            return "gravitational force"
            
        default:
            return "FATAL ERROR"
        }
    }
    
    

    func randomNumAndSign(_ varName: String) -> PhysicsVariable {
        
        let knownVar = PhysicsVariable.init(name: varName)
        
        let rando = arc4random_uniform(UInt32(2))
        let variable : Double = Double(arc4random_uniform(UInt32(100)))
        let decimalPlace : Double = Double(arc4random_uniform(UInt32(10))) / 10
        if rando == 1 {
            knownVar.value = variable + decimalPlace
            knownVar.unit = selectUnit(varName: varName)
            if eqName == "gravitational force" && varName.contains("m") {
                let r: Double = Double(arc4random_uniform(10)) + 20
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            } else if eqName == "gravitational force" && varName.contains("r") {
                let r: Double = Double(arc4random_uniform(6)) + 6
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            } else if eqName == "gravitational force" {
                let r: Double = Double(arc4random_uniform(5)) + 5
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            }
            return convertUnits(knownVar.unit, knownVar)
        } else {
            let x = 0 - variable
            if knownVar.isScalar {
                knownVar.value = variable + decimalPlace
            } else {
                knownVar.value = x + decimalPlace
            }
            knownVar.unit = selectUnit(varName: varName)
            if eqName == "gravitational force" && varName.contains("m") {
                let r: Double = Double(arc4random_uniform(10)) + 20
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            } else if eqName == "gravitational force" && varName.contains("r") {
                let r: Double = Double(arc4random_uniform(6)) + 6
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            } else if eqName == "gravitational force" {
                let r: Double = Double(arc4random_uniform(5)) + 5
                var mult: Double = 10
                mult = pow(mult, r)
                knownVar.value = changeMagnitude(knownVar: knownVar, multiplier: mult)
            }
            return convertUnits(knownVar.unit, knownVar)
        }
    }
    
    func selectUnit(varName: String) -> String {
        if typeOfUnitsShown == "SI (base)" {
            return Helper.GET_SI_UNIT(vName: varName)
        } else if typeOfUnitsShown == "Metric" {
            let random: Int = Int(arc4random_uniform(UInt32(Helper.GET_LIST_OF_METRIC_UNITS(varName: varName).count)))
            return Helper.GET_LIST_OF_METRIC_UNITS(varName: varName)[random]
        } else if typeOfUnitsShown == "Customary" {
            let random: Int = Int(arc4random_uniform(UInt32(Helper.GET_LIST_OF_CUSTOMARY_UNITS(varName: varName).count)))
            return Helper.GET_LIST_OF_CUSTOMARY_UNITS(varName: varName)[random]
        } else {
            let random: Int = Int(arc4random_uniform(UInt32(Helper.GET_LIST_OF_UNITS(varName: varName).count - 1)))
            return Helper.GET_LIST_OF_UNITS(varName: varName)[random]
        }
    }
    
    func convertUnits(_ units: String, _ knownVar: PhysicsVariable) -> PhysicsVariable {
        //knownVar.unConvertedValue = Helper.CONVERT_UNITS(physicsVar: knownVar, toSI: false)
        knownVar.unConvertedValue = Helper.CONVERT_UNITS(from: knownVar.getSIUnits(), to: knownVar.unit, value: knownVar.value)

        return knownVar
    }
    
    func changeMagnitude(knownVar: PhysicsVariable, multiplier: Double) -> Double {
        knownVar.value = knownVar.value * multiplier
        //fix for grav force mass values being messed up
        let temp = "\(knownVar.value)"
        if knownVar.name.contains("m") && temp.contains("e") && knownVar.value > 100000 {
            var newValue = ""
            var reachedE = false
            for i in 0...temp.count-1 {
                let index = temp.index(temp.startIndex, offsetBy: i)
                if temp[index] == "e" {
                    reachedE = true
                    newValue.append(temp[index])
                } else if reachedE {
                    newValue.append(temp[index])
                } else if i < 7 {
                    newValue.append(temp[index])
                }
            }
            knownVar.value = Double(newValue) ?? knownVar.value
        }
        return knownVar.value
    }
    
    func resetStuff() {
        listOfVars.removeAll()
        listOfVarsForSaved.removeAll()
    }
    
    //for below: find way to escape from calculation if it won't produce real numbers and then generate a new one.
    func generateProblem() {
        if LocalPracticeProblem.GET_PROMPT_NUM() != -1 && noSettingsChanged() {
            reloadProblem()
            
            // also... make sure to reset randomPrompt when Next button is clicked... E: should be good
            return
        }
        
        randomPrompt = Int(arc4random_uniform(UInt32(listOfPrompts.count)))
        resetStuff()
        switch eqName {
        case "kinematics":
            kinematicsProb(isQuiz: false, isReloaded: false)
        case "forces":
            forcesProb(isQuiz: false, isReloaded: false)
        case "kinetic energy":
            kineticEnergyProb(isQuiz: false, isReloaded: false)
        case "gravitational force":
            gravitationalForceProb(isQuiz: false, isReloaded: false)
        default:
            print("erorr- could not find typeOfProb. eq name was \(eqName)")
        }
        print("pregen")
        if answerTextField.isHidden { //Click on "begin quiz", then it goes here... idk why
            enableOrDisableMCButtons(toEnable: true)
            generateRandomMCOptions()
        }
        print("postgen")
    }
    
    func noSettingsChanged() -> Bool {
        if LocalPracticeProblem.GET_EQUATION_NAME() != eqName {
            return false
        } else if LocalPracticeProblem.GET_UNIT_TYPE() != UserDefaults.standard.getProblemUnitsPP() {
            return false
        } else {
            return true
        }
    }
    
    func enableOrDisableMCButtons(toEnable: Bool) {
        if !answerTextField.isHidden {
            return
        }
        if answerTextField.isHidden {
            buttonA.isEnabled = toEnable
            buttonB.isEnabled = toEnable
            buttonC.isEnabled = toEnable
            buttonD.isEnabled = toEnable
        }
        fixBtnImage()
        
    }
    
    func reloadProblem() {
        listOfMCOptions = LocalPracticeProblem.GET_LIST_OF_MC_OPTIONS() //double check code!!
        listOfVars = LocalPracticeProblem.GET_LIST_OF_VARS()
        randomPrompt = LocalPracticeProblem.GET_PROMPT_NUM()
        correctMCLetter = LocalPracticeProblem.GET_CORRECT_MC_OPTION()
        listOfVarsForSaved = LocalPracticeProblem.GET_LIST_VARS_FOR_SAVE()
        
        switch eqName {
        case "kinematics":
            kinematicsProb(isQuiz: false, isReloaded: true)
        case "forces":
            forcesProb(isQuiz: false, isReloaded: true)
        case "kinetic energy":
            kineticEnergyProb(isQuiz: false, isReloaded: true)
        case "gravitational force":
            gravitationalForceProb(isQuiz: false, isReloaded: true)
        default:
            print("error w/ reloading problem")
        }
        if answerTextField.isHidden && listOfMCOptions[0] != "N/A" { //error for going to options
            labelA.text = listOfMCOptions[0]
            labelB.text = listOfMCOptions[1]
            labelC.text = listOfMCOptions[2]
            labelD.text = listOfMCOptions[3]
            //generateRandomMCOptions()
        } else if answerTextField.isHidden {
            generateRandomMCOptions()
        }
    }
    
    func generateQuizProblem(typeOfEq: String, theTypeOfUnitsShown: String) {
        eqName = typeOfEq
        typeOfUnitsShown = theTypeOfUnitsShown
        randomPrompt = Int(arc4random_uniform(UInt32(listOfPrompts.count)))
        switch typeOfEq {
        case "kinematics":
            kinematicsProb(isQuiz: true, isReloaded: false)
        case "forces":
            forcesProb(isQuiz: true, isReloaded: false)
        case "kinetic energy":
            kineticEnergyProb(isQuiz: true, isReloaded: false)
        case "gravitational force":
            gravitationalForceProb(isQuiz: true, isReloaded: false)
        default:
            print("error w/ generating quiz problem")
        }
    }
    
    func kinematicsProb(isQuiz: Bool, isReloaded: Bool) {
        if !isReloaded {
            switch randomPrompt {
            case 0:
                var fV : PhysicsVariable = PhysicsVariable.init(name: "fV")
                fV.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff() //idk where this needs to go, but it needs to go somewhere different than v 1.1...
                    let a = randomNumAndSign("a")
                    let iV = randomNumAndSign("iV")
                    let d = randomNumAndSign("d")
                    iV.value *= 10
                    iV.unConvertedValue *= 10
                    listOfVars.append(a)
                    listOfVars.append(iV)
                    listOfVars.append(d)
                    listOfVarsForSaved.append(a)
                    listOfVarsForSaved.append(iV)
                    listOfVarsForSaved.append(d)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "fV")
                    eq.doKinemtaicsEquation()
                    fV = eq.getSingleUnknown()
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    listOfVars.append(fV)
                    if fV.value != 23.7 || fV.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
                print("fV: \(fV.value)")
            case 1:
                var iV: PhysicsVariable = PhysicsVariable.init(name: "iV")
                iV.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let t = randomNumAndSign("t")
                    let fV = randomNumAndSign("fV")
                    let d = randomNumAndSign("d")
                    listOfVars.append(t)
                    listOfVars.append(fV)
                    listOfVars.append(d)
                    listOfVarsForSaved.append(t)
                    listOfVarsForSaved.append(fV)
                    listOfVarsForSaved.append(d)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "iV")
                    eq.doKinemtaicsEquation()
                    iV = eq.getSingleUnknown()
                    listOfVars.append(iV)
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    if iV.value != 23.7 || iV.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
                print("iV: \(iV.value)")
            case 2:
                var fV : PhysicsVariable = PhysicsVariable.init(name: "fV")
                fV.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let a:PhysicsVariable = randomNumAndSign("a")
                    let t:PhysicsVariable = randomNumAndSign("t")
                    let d:PhysicsVariable = randomNumAndSign("d")
                    listOfVars.append(t)
                    listOfVars.append(a)
                    listOfVars.append(d)
                    listOfVarsForSaved.append(a)
                    listOfVarsForSaved.append(t)
                    listOfVarsForSaved.append(d)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "fV")
                    eq.doKinemtaicsEquation()
                    fV = eq.getSingleUnknown()
                    listOfVars.append(fV)
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    if fV.value != 23.7 || fV.isValueSet {
                        isProblemPossible = isProblemValid()                }
                }
                print("fV: \(fV.value)")
            case 3:
                var d : PhysicsVariable = PhysicsVariable.init(name: "d")
                d.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let a:PhysicsVariable = randomNumAndSign("a")
                    let t:PhysicsVariable = randomNumAndSign("t")
                    let iV:PhysicsVariable = randomNumAndSign("iV")
                    listOfVars.append(t)
                    listOfVars.append(a)
                    listOfVars.append(iV)
                    listOfVarsForSaved.append(a)
                    listOfVarsForSaved.append(iV)
                    listOfVarsForSaved.append(t)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "d")
                    eq.doKinemtaicsEquation()
                    d = eq.getSingleUnknown()
                    listOfVars.append(d)
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    if d.value != 23.7 || d.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
                print("d: \(d.value)")
            case 4:
                var a : PhysicsVariable = PhysicsVariable.init(name: "a")
                a.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let d:PhysicsVariable = randomNumAndSign("d")
                    let iV:PhysicsVariable = randomNumAndSign("iV")
                    let fV:PhysicsVariable = randomNumAndSign("fV")
                    listOfVars.append(d)
                    listOfVars.append(iV)
                    listOfVars.append(fV)
                    listOfVarsForSaved.append(fV)
                    listOfVarsForSaved.append(iV)
                    listOfVarsForSaved.append(d)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "a")
                    eq.doKinemtaicsEquation()
                    a = eq.getSingleUnknown()
                    listOfVars.append(a)
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    if a.value != 23.7 || a.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
                print("a: \(a.value)")
            case 5:
                var d : PhysicsVariable = PhysicsVariable.init(name: "d")
                d.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let t:PhysicsVariable = randomNumAndSign("t")
                    let fV:PhysicsVariable = randomNumAndSign("fV")
                    let a: PhysicsVariable = PhysicsVariable.init(name: "a", value: 9.81)
                    listOfVars.append(t)
                    listOfVars.append(a)
                    listOfVars.append(fV)
                    listOfVarsForSaved.append(a)
                    listOfVarsForSaved.append(fV)
                    listOfVarsForSaved.append(t)
                    let eq:KinematicsEquations = KinematicsEquations.init(listOfVars, "d")
                    eq.doKinemtaicsEquation()
                    d = eq.getSingleUnknown()
                    listOfVars.append(d)
                    let eq2:KinematicsEquations = KinematicsEquations.init(listOfKnowns: listOfVarsForSaved)
                    eq2.doKinemtaicsEquation()
                    let temp = eq2.getAnswers()
                    listOfVarsForSaved.append(temp[0])
                    listOfVarsForSaved.append(temp[1])
                    if d.value != 23.7 || d.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            default:
                print("error- out of range")
            }
        } else {
            fixUnits()
        }
        
        var iV:PhysicsVariable = PhysicsVariable.init(name: "iV")
        var fV:PhysicsVariable = PhysicsVariable.init(name: "fV")
        var t:PhysicsVariable = PhysicsVariable.init(name: "t")
        var d:PhysicsVariable = PhysicsVariable.init(name: "d")
        var a:PhysicsVariable = PhysicsVariable.init(name: "a")
        
        for i in 0...2 {
            print(i)
            switch listOfVars[i].name {
            case "iV":
                iV = listOfVars[i]
            case "fV":
                fV = listOfVars[i]
            case "d":
                d = listOfVars[i]
            case "a":
                a = listOfVars[i]
            case "t":
                t = listOfVars[i]
            default:
                print("error- could not set up vars for listOfPrompts")
            }
        }
        let randomMaleName = Helper.GET_RANDOM_MALE_NAME()
        listOfPrompts = ["An airplane, with an initial velocity of \(iV.getProblemValue()) \(iV.unit) accelerates at \(a.getProblemValue()) \(a.unit). After traveling \(d.getProblemValue()) \(d.unit), what is the airplane's final velocity?", "For his brithday, Billy got a drone! He decided to begin flying the drone on a nice summer day. After he got the drone moving, his friend \(randomMaleName) took the controls, and flew the drone with a constant acceleration. After \(t.getProblemValue()) \(t.unit), the drone's velocity was measured to be \(fV.getProblemValue()) \(fV.unit). Since the drone traveled \(d.getProblemValue()) \(d.unit), what was the drone's velocity right when \(randomMaleName) began flying it?", "A boat was traveling with a constant acceleration of \(a.getProblemValue()) \(a.unit). After traveling \(d.getProblemValue()) \(d.unit) for \(t.getProblemValue()) \(t.unit), what was the boat's velocity?", "A cheeta spotted prey and decided to chase after it. After a few seconds, the Cheeta maintained a constant acceleration of \(a.getProblemValue()) \(a.unit), with its initial velocity being \(iV.getProblemValue()) \(iV.unit). What was the cheeta's displacement after \(t.getProblemValue()) \(t.unit)", "A car is initially moving at \(iV.getProblemValue()) \(iV.unit) along a highway. After traveling \(d.getProblemValue()) \(d.unit), the car is now moving at a speed of \(fV.getProblemValue()) \(fV.unit). What is the car's acceleration?", "Tim threw a tennis ball into the air. After \(t.getProblemValue()) \(t.unit), the ball was traveling in the air at \(fV.getProblemValue()) \(fV.unit). How far did the ball travel in the air? Note: this was done on Earth, which has an acceleration due to gravity equal to 9.81 \(Helper.exponentize(str: "m/s^2"))"]
        
        if isInvalidProblem() {
            kinematicsProb(isQuiz: isQuiz, isReloaded: isReloaded)
        } else {
            if isQuiz {
                QuizViewController.THE_ANSWER = listOfVars.last
                QuizViewController.THE_PROMPT = listOfPrompts[randomPrompt]
                QuizViewController.LIST_OF_VARS = listOfVars

            } else {
                problemTextView.text = listOfPrompts[randomPrompt]
            }
        }
        
        
    }
    
    func forcesProb(isQuiz: Bool, isReloaded: Bool) {
        if !isReloaded {
            switch true {
            case randomPrompt == 0 || randomPrompt == 3:
             var f:PhysicsVariable = PhysicsVariable.init(name: "f")
             f.isUnknown = true
             var isProblemPossible = false
             while(!isProblemPossible) {
                resetStuff()
                 let a:PhysicsVariable = randomNumAndSign("a")
                 let m:PhysicsVariable = randomNumAndSign("m")
                 m.value /= 10
                 m.unConvertedValue /= 10
                 listOfVars.append(a)
                 listOfVars.append(m)
                 let eq:ForceEquations = ForceEquations.init(listOfVars, "f")
                 eq.doEquation()
                 f = eq.getF()
                 listOfVars.append(f)
                 if f.value != 23.7 || f.isValueSet {
                    isProblemPossible = isProblemValid()
                 }
             }
             case randomPrompt == 1 || randomPrompt == 4 || randomPrompt == 5:
                var a:PhysicsVariable = PhysicsVariable.init(name: "a")
                a.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let f:PhysicsVariable = randomNumAndSign("f")
                    let m:PhysicsVariable = randomNumAndSign("m")
                    if randomPrompt == 1 {
                        m.value *= 1000
                        m.unConvertedValue *= 1000
                        f.value *= 100
                        f.unConvertedValue *= 100
                    }
                    listOfVars.append(f)
                    listOfVars.append(m)
                    let eq:ForceEquations = ForceEquations.init(listOfVars , "a")
                    eq.doEquation()
                    a = eq.getA()
                    listOfVars.append(a)
                    if a.value != 23.7 || a.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                 }
            case randomPrompt == 2:
                var m:PhysicsVariable = PhysicsVariable.init(name: "m")
                m.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let a:PhysicsVariable = PhysicsVariable.init(name: "a", value: -9.81)
                    let f:PhysicsVariable = randomNumAndSign("f")
                    f.value *= 15
                    f.unConvertedValue *= 15
                    listOfVars.append(a)
                    listOfVars.append(f)
                    let eq:ForceEquations = ForceEquations.init(listOfVars , "m")
                    eq.doEquation()
                    m = eq.getM()
                    listOfVars.append(m)
                    if m.value != 23.7 || m.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            
            default:
                print("error w/ force random prompt")
            }
        }
         var m:PhysicsVariable = PhysicsVariable.init(name: "m")
         var f:PhysicsVariable = PhysicsVariable.init(name: "f")
         var a:PhysicsVariable = PhysicsVariable.init(name: "a")
         
         for i in 0...1 {
             switch listOfVars[i].name {
             case "m":
                m = listOfVars[i]
             case "f":
                f = listOfVars[i]
             case "a":
                a = listOfVars[i]
             default:
             print("error- could not set up vars for listOfPrompts")
             }
         }
        
            listOfPrompts = ["A ball with mass \(m.getProblemValue()) \(m.unit) was thrown with an acceleration of \(a.getProblemValue()) \(a.unit). What was the force exerted on the ball?", "An airplane takes off with a force of \(f.getProblemValue()) \(f.unit) and a mass of \(m.getProblemValue()) \(m.unit). What is the airplane's acceleration?", "A man jumps down onto the floor and exerts a force of \(f.getProblemValue()) \(f.unit). Assuming there is no air resistance, what is the man's mass (with his acceleration being gravity on Earth, -9.81 \(Helper.exponentize(str: "m/s^2")))?", "Sally pushed a lego with her hand, causing it to accelerate at a constant acceleration of \(a.getProblemValue()) \(a.unit). Given the lego's mass of \(m.getProblemValue()) \(m.unit), what force was required for Sally to push the block to achieve the acceleration?", "Nicholas is working on a math problem. After yelling out in frustration on how terrible the problem is, he pushes his book off his desk with a force of \(f.getProblemValue()) \(f.unit). Knowing the book's mass is \(m.getProblemValue()) \(m.unit), what acceleration is produced by the force?", "Eric attempts to lift a large supply of dorritos with a mass of \(m.getProblemValue()) \(m.unit). After applying a force of \(f.getProblemValue()) \(f.unit), what acceleration results from the man's efforts?"]
        //Beyond this point there is bad code for QuizViewController when it sets up quiz problem...
        if isInvalidProblem() {
            print("invalid!")
            forcesProb(isQuiz: isQuiz, isReloaded: isReloaded)
        } else {
            if isQuiz {
                QuizViewController.THE_ANSWER = listOfVars.last
                QuizViewController.THE_PROMPT = listOfPrompts[randomPrompt]
                QuizViewController.LIST_OF_VARS = listOfVars

            } else {
                problemTextView.text = listOfPrompts[randomPrompt]
            }
        }
        
    }
    
    func kineticEnergyProb(isQuiz: Bool, isReloaded: Bool) {
        if !isReloaded {
            switch true {
            case randomPrompt == 0 || randomPrompt == 3 || randomPrompt == 5:
                var k:PhysicsVariable = PhysicsVariable.init(name: "k")
                k.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let v:PhysicsVariable = randomNumAndSign("v")
                    let m:PhysicsVariable = randomNumAndSign("m")
                    if randomPrompt == 0 {
                        m.value *= 10000
                        m.unConvertedValue *= 10000
                        v.value *= 100
                        v.unConvertedValue *= 100
                    } else if randomPrompt == 1 {
                        m.value *= 100
                        m.unConvertedValue *= 100
                    } else if m.value < 20 {
                        m.value *= 3
                        m.unConvertedValue *= 3
                    }
                    listOfVars.append(v)
                    listOfVars.append(m)
                    let eq:KineticEnergyEquations = KineticEnergyEquations.init(listOfKnowns: listOfVars, unknown: "k")
                    eq.solve()
                    k = eq.getUnknown()
                    listOfVars.append(k)
                    if k.value != 23.7 || k.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            case randomPrompt == 1:
                var m:PhysicsVariable = PhysicsVariable.init(name: "m")
                m.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let v:PhysicsVariable = randomNumAndSign("v")
                    let k:PhysicsVariable = randomNumAndSign("k")
                    listOfVars.append(v)
                    listOfVars.append(k)
                    let eq:KineticEnergyEquations = KineticEnergyEquations.init(listOfKnowns: listOfVars, unknown: "m")
                    eq.solve()
                    m = eq.getUnknown()
                    listOfVars.append(m)
                    if m.value != 23.7 || m.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            case randomPrompt == 2 || randomPrompt == 4:
                var v:PhysicsVariable = PhysicsVariable.init(name: "v")
                v.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let k:PhysicsVariable = randomNumAndSign("k")
                    let m:PhysicsVariable = randomNumAndSign("m")
                    
                    if m.value < 25 {
                        m.value *= 3
                        m.unConvertedValue *= 3
                    }
                    m.value *= 3
                    m.unConvertedValue *= 3
                    
                    listOfVars.append(k)
                    listOfVars.append(m)
                    let eq:KineticEnergyEquations = KineticEnergyEquations.init(listOfKnowns: listOfVars, unknown: "v")
                    eq.solve()
                    v = eq.getUnknown()
                    listOfVars.append(v)
                    if v.value != 23.7 || v.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            default:
                print("error w/ force random prompt")

            }
        }
        var m: PhysicsVariable = PhysicsVariable.init(name: "m")
        var k: PhysicsVariable = PhysicsVariable.init(name: "k")
        var v: PhysicsVariable = PhysicsVariable.init(name: "v")
        
        for i in 0...1 {
            switch listOfVars[i].name {
            case "m":
                m = listOfVars[i]
            case "k":
                k = listOfVars[i]
            case "v":
                v = listOfVars[i]
            default:
                print("error- could not set up vars for listOfPrompts")
            }
        }
        let randomMaleName = Helper.GET_RANDOM_MALE_NAME()
        listOfPrompts = ["A meteor with a mass of \(m.getProblemValue()) \(m.unit) falls down from the sky. Right before hitting Earth, the meteor's velocity is  \(v.getProblemValue()) \(v.unit). What is the meteor's kinetic energy?", "A ball at rest was kicked by an excited teenager. With a velocity of \(v.getProblemValue()) \(v.unit) and Kinetic energy of \(k.getProblemValue()) \(k.unit), what was the ball's mass?", "\(randomMaleName) ran a 100 meter sprint with his kinetic energy at \(k.getProblemValue()) \(k.unit). What was the boy's velocity if his mass was \(m.getProblemValue()) \(m.unit)?", "A cheeta chases prey, sprinting at speeds up to \(v.getProblemValue()) \(v.unit). Given the mass of the cheeta is \(m.getProblemValue()) \(m.unit), what is the cheeta's maximum kinetic energy?", "\(randomMaleName), with a mass of \(m.getProblemValue()) \(m.unit), was sliding down a tube. What was his velocity the instant his kinetic energy equaled \(k.getProblemValue()) \(k.unit)?", "How much kinetic energy is required for \(randomMaleName) to push a car of mass \(m.getProblemValue()) \(m.unit) at a constant velocity of \(v.getProblemValue()) \(v.unit)?"]
        
        if isInvalidProblem() {
            kineticEnergyProb(isQuiz: isQuiz, isReloaded: false)
        } else {
            if isQuiz {
                QuizViewController.THE_ANSWER = listOfVars.last
                QuizViewController.THE_PROMPT = listOfPrompts[randomPrompt]
                QuizViewController.LIST_OF_VARS = listOfVars

            } else {
                problemTextView.text = listOfPrompts[randomPrompt]
            }
        }
    }
    
    func gravitationalForceProb(isQuiz: Bool, isReloaded: Bool) {
        print("gravitationalForceProb()")
        listOfPrompts = ["A moon with the mass of ___ _ orbits a planet of mass ___ _. Given the distance between the bodies is ___, what is the force the the planet exerts on the moon?", "A meteor of mass __ _ attempts to enter a planet's atmosphere, but instead enters said planet's orbit. The meteor orbits the planet at a distance __ __, exerting a force of __ _. What is the planet's mass?", "A planet of mass _ orbits its star of mass _. Given the star's gravitational force on the planet equals __ _, what is the distance between the two objects?", "A satellite orbits a celestial body of mass __ _ at a distance ___ _. Given the gravitational force is __ _, what is the mass of the satellite?", "A cluster of space debri of mass ___ _ orbits a moon of mass __ _. Given the distance of separation is __ _, what is the force exerted on the moon by the debri?", "A basket ball of mass ___ feels a gravitational force by the Earth of mass ___ _. Given the moon has a mass 1/6th of the Earth and the separation is __ _, what is the magnitude of the force on the moon?"]
        //might want this here first so that, depending on the info given in the prompt chosen, more accurate/realistic numbers can be randomly selected.
        if !isReloaded {
            print("prompt:\(randomPrompt)")
            switch true {
            case randomPrompt == 0 || randomPrompt == 4 || randomPrompt == 5:
                var fG: PhysicsVariable = PhysicsVariable.init(name: "fG")
                fG.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    var r:PhysicsVariable = randomNumAndSign("r")
                    var m1:PhysicsVariable = randomNumAndSign("m1")
                    let m2:PhysicsVariable = randomNumAndSign("m2")
                    if randomPrompt == 5 {
                        eqName = "forces"
                        m2.value = PHYSICS_CONSTANTS.EARTH_MASS
                        m2.unConvertedValue = m2.value
                        m1 = randomNumAndSign("m1")
                        m1.value /= 10
                        m1.unConvertedValue /= 10
                        r = randomNumAndSign("r")
                        eqName = "gravitational force"
                    }
                    listOfVars.append(r)
                    listOfVars.append(m1)
                    listOfVars.append(m2)
                    let eq:GravitationalForceEquation = GravitationalForceEquation.init(listOfKnowns: listOfVars, unknown: "fG")
                    eq.solve()
                    fG = eq.getAnswer()
                    if randomPrompt == 5 {
                        fG.value = fG.value / 6.0
                    }
                    listOfVars.append(fG)
                    if fG.value != 23.7 || fG.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            case randomPrompt == 2:
                var r: PhysicsVariable = PhysicsVariable.init(name: "r")
                r.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let fG:PhysicsVariable = randomNumAndSign("fG")
                    let m1:PhysicsVariable = randomNumAndSign("m1")
                    let m2:PhysicsVariable = randomNumAndSign("m2")
                    listOfVars.append(fG)
                    listOfVars.append(m1)
                    listOfVars.append(m2)
                    let eq:GravitationalForceEquation = GravitationalForceEquation.init(listOfKnowns: listOfVars, unknown: "r")
                    eq.solve()
                    r = eq.getAnswer()
                    listOfVars.append(r)
                    if r.value != 23.7 || r.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            case randomPrompt == 3 || randomPrompt == 1:
                var m1: PhysicsVariable = PhysicsVariable.init(name: "m1")
                m1.isUnknown = true
                var isProblemPossible = false
                while(!isProblemPossible) {
                    resetStuff()
                    let r:PhysicsVariable = randomNumAndSign("r")
                    let fG:PhysicsVariable = randomNumAndSign("fG")
                    let m2:PhysicsVariable = randomNumAndSign("m2")
                    listOfVars.append(r)
                    listOfVars.append(fG)
                    listOfVars.append(m2)

                    let eq:GravitationalForceEquation = GravitationalForceEquation.init(listOfKnowns: listOfVars, unknown: "m1")
                    eq.solve()
                    m1 = eq.getAnswer()
                    listOfVars.append(m1)
                    if m1.value != 23.7 || m1.isValueSet {
                        isProblemPossible = isProblemValid()
                    }
                }
            default:
                print("error w/ gravitational force problem")
            }
        }
        print("We made it past the conversions!")
        var fG = PhysicsVariable.init(name: "fG")
        var m1 = PhysicsVariable.init(name: "m1")
        var m2 = PhysicsVariable.init(name: "m2")
        var r = PhysicsVariable.init(name: "r")
        
        for i in 0...2 {
            switch listOfVars[i].name {
            case "fG":
                fG = listOfVars[i]
            case "m1":
                m1 = listOfVars[i]
            case "m2":
                m2 = listOfVars[i]
            case "r":
                r = listOfVars[i]
            default:
                print("error- could not set up vars for listOfPrompts")
                print(listOfVars[i].name)
            }
        }
        //For all practice probs: need to make sure that the numbers make sense: they need to go with problem. Work harder to make them work!
        print("preprompt")
        listOfPrompts = ["A moon with the mass of \(m1.getProblemValue()) \(m1.unit) orbits a planet of mass \(m2.getProblemValue()) \(m2.unit). Given the distance between the bodies is \(r.getProblemValue()) \(r.unit), what is the force the the planet exerts on the moon?", "A meteor of mass \(m2.getProblemValue()) \(m2.unit) attempts to enter a planet's atmosphere, but instead enters said planet's orbit. The meteor orbits the planet at a distance \(r.getProblemValue()) \(r.unit), exerting a force of \(fG.getProblemValue()) \(fG.unit). What is the planet's mass?", "A planet of mass \(m1.getProblemValue()) \(m1.unit) orbits its star of mass \(m2.getProblemValue()) \(m2.unit). Given the star's gravitational force on the planet equals \(fG.getProblemValue()) \(fG.unit), what is the distance between the two objects?", "A satellite orbits a celestial body of mass \(m2.getProblemValue()) \(m2.unit) at a distance \(r.getProblemValue()) \(r.unit). Given the gravitational force is \(fG.getProblemValue()) \(fG.unit), what is the mass of the satellite?", "A cluster of space debri of mass \(m1.getProblemValue()) \(m1.unit) orbits a moon of mass \(m2.getProblemValue()) \(m2.unit). Given the distance of separation is \(r.getProblemValue()) \(r.unit), what is the force exerted on the moon by the debri?", "A basket ball of mass \(m1.getProblemValue()) \(m1.unit) feels a gravitational force by the Earth of mass \(m2.getProblemValue()) \(m2.getSIUnits()). Given the moon has a mass 1/6th of the Earth and the separation is \(r.getProblemValue()) \(r.unit), what is the magnitude of the force on the moon felt by the ball?"]
        print("postprompt")
        if isInvalidProblem() {
            gravitationalForceProb(isQuiz: isQuiz, isReloaded: false)
        } else {
            if isQuiz {
                QuizViewController.THE_ANSWER = listOfVars.last
                QuizViewController.THE_PROMPT = listOfPrompts[randomPrompt]
                QuizViewController.LIST_OF_VARS = listOfVars
            } else {
                problemTextView.text = listOfPrompts[randomPrompt]
            }
        }
    }
    //Fixes units of a loaded problem only when unit type settings change and are no longer capaitable with prior problem. For simplicity's sake, it just changes them to SI rather than anything else complex.
    func fixUnits() {
        var listOfVarsToFix: [PhysicsVariable] = [PhysicsVariable]()
        var tempListOfVars: [PhysicsVariable] = [PhysicsVariable]()
        for i in 0...listOfVars.count - 1 {
            tempListOfVars.append(listOfVars[i])
        }
        for i in 0...listOfVars.count - 1 {
            if UserDefaults.standard.getProblemUnitsPP() == "SI (base)" {
                if listOfVars[i].unit != listOfVars[i].getSIUnits() {
                    listOfVarsToFix.append(listOfVars[i])
                    tempListOfVars.remove(at: i)
                }
            } else if UserDefaults.standard.getProblemUnitsPP() == "Metric" {
                var isGood = false
                for j in Helper.GET_LIST_OF_METRIC_UNITS(varName: listOfVars[i].name) {
                    if j == listOfVars[i].unit {
                        isGood = true
                    }
                }
                if !isGood {
                    listOfVarsToFix.append(listOfVars[i])
                    tempListOfVars.remove(at: i)
                    
                }
            } else if UserDefaults.standard.getProblemUnitsPP() == "Customary" {
                var isGood = false
                for j in Helper.GET_LIST_OF_CUSTOMARY_UNITS(varName: listOfVars[i].name) {
                    if j == listOfVars[i].unit {
                        isGood = true
                    }
                }
                if !isGood {
                    listOfVarsToFix.append(listOfVars[i])
                    tempListOfVars.remove(at: i)
                    
                }
            }
            
        }
        if listOfVarsToFix.isEmpty {
            return
        }
        let ans = tempListOfVars.removeLast() //ans must be at end; why it's removed...
        for i in 0...listOfVarsToFix.count - 1 {
            listOfVarsToFix[i].unConvertedValue = listOfVarsToFix[i].value
            listOfVarsToFix[i].unit = listOfVarsToFix[i].getSIUnits()
            tempListOfVars.append(listOfVarsToFix[i])
        }
        tempListOfVars.append(ans)
        listOfVars = tempListOfVars
        
    }
    //checks if the problem is valid by if #1 the answer is not NaN and #2 if the scalars are not negative
    func isProblemValid() -> Bool {
        if (listOfVars.last?.value.isNaN)! {
            return false
        }
        for i in listOfVars {
            if i.isScalar && i.value <= 0 {
                return false
            }
        }
        return true
    }
    //Sets up the problem type- finds out if user settings are MC or FRQ then loads the subsequent one
    func setUpProblemType() {
        typeOfUnitsShown = UserDefaults.standard.getProblemUnitsPP()
        
        if UserDefaults.standard.getProblemTypePP() == "Multiple Choice" {
            answerTextField.isHidden = true
            selectUnitBtn.isHidden = true
            mcview.isHidden = false
            setUpMCOutlets()
        } else if UserDefaults.standard.getProblemTypePP() == "Free Response" {
            answerTextField.isHidden = false
            mcview.isHidden = true
        } else {
            pickRandomProblemType()
            return
        }
        typeOfQuestion = UserDefaults.standard.getProblemTypePP()
        if UserDefaults.standard.isUnitsShownPP() {
            areUnitsEnabled = true
            setUpBottomView()
        } else {
            areUnitsEnabled = false
            selectUnitBtn.isHidden = true
        }
        
    }
    
    func pickRandomProblemType() {
        if UserDefaults.standard.getProblemTypePP() != "Both (random)" {
            return
        }
        if arc4random_uniform(2) == 1 {
            //MC
            typeOfQuestion = "Multiple Choice"
            answerTextField.isHidden = true
            mcview.isHidden = false
            for i in mcview.subviews {
                if let viewWithTag = self.mcview.viewWithTag(i.tag) {
                    viewWithTag.removeFromSuperview()
                }
            }
            setUpMCOutlets()
            areUnitsEnabled = false
            selectUnitBtn.isHidden = true
        } else {
            //FRQ
            typeOfQuestion = "Free Response"
            answerTextField.isHidden = false
            mcview.isHidden = true
            if UserDefaults.standard.isUnitsShownPP() {
                selectUnitBtn.isHidden = false
                areUnitsEnabled = true
                setUpBottomView()
            } else {
                areUnitsEnabled = false
                selectUnitBtn.isHidden = true
            }
        }
        
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - Helper.GET_BOTTOM_VIEW_HEIGHT(), width: self.view.frame.width, height: Helper.GET_BOTTOM_VIEW_HEIGHT()))
        bottomView.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        //bottomView.tag = 100
        self.view.addSubview(bottomView)
        bottomView.isHidden = true
        let unitPicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: self.bottomView.frame.height))
        unitPicker.delegate = self
        unitPicker.dataSource = self
        //unitPicker.tag = 1
        self.bottomView.addSubview(unitPicker)
        unitPicker.isHidden = false
        let doneBtn = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        //doneBtn.tag = sender.tag
        doneBtn.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.bottomView.addSubview(doneBtn)
        doneBtn.isHidden = false
        
    }
    
    @IBAction func showBottomView(_ sender: UIButton) {
        for i in bottomView.subviews {
            i.isHidden = false
        }
        bottomView.isHidden = false
        bottomView.tag = 111
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func hideBottomView(_ sender: UIButton) {
        for i in bottomView.subviews {
            i.isHidden = true
        }
        bottomView.isHidden = true
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = true
            }
        }
        selectUnitBtn.setTitle(unitsChosen, for: .normal)
    }
    
    
    func fixBtnImage() {
        var listOfEnabledImages: [UIImage] = [UIImage(named: "button_a.gif")!, UIImage(named: "button_b.gif")!, UIImage(named: "button_c.gif")!, UIImage(named: "button_d.gif")!]
        var listOfDisabledImages: [UIImage] = [UIImage(named: "button_a_disabled.gif")!, UIImage(named: "button_b_disabled.gif")!, UIImage(named: "button_c_disabled.gif")!, UIImage(named: "button_d_disabled.gif")!]
        var listOfBtns: [UIButton] = [buttonA, buttonB, buttonC, buttonD]
        for i in 0...3 {
            if listOfBtns[i].isEnabled {
                listOfBtns[i].setBackgroundImage(listOfEnabledImages[i], for: .normal)
            } else {
                listOfBtns[i].setBackgroundImage(listOfDisabledImages[i], for: .normal)
            }
        }
    }
    
    //Need to make font a little bigger =)
    //Alpha E.: make font resize based on screen size...
    func setUpMCOutlets() {
        let height: Double = Double(mcview.frame.height) * (30.0/140.0)
        print(height)
        let yPos: Double = Double(mcview.frame.height * 0.25)
        let xPos: Double = Double(mcview.frame.width * 0.25)
        let labelWidth: Double = Double(mcview.frame.width * 0.70)
        
        var fontSize: CGFloat = 16
        if self.view.frame.width > 500 {
            fontSize = 32
        }
        
        
        buttonA = UIButton(type: .system)
        buttonA.frame = CGRect(x: 0, y:yPos * 0, width: height, height: height)
        buttonA.addTarget(self, action: #selector(pressButtonA), for: .touchUpInside)
        buttonA.setBackgroundImage(UIImage(named: "button_a.gif"), for: .normal)
        
        buttonB = UIButton(type: .system)
        buttonB.frame = CGRect(x: 0, y:yPos * 1, width:height, height: height)
        buttonB.addTarget(self, action: #selector(pressButtonB), for: .touchUpInside)
        buttonB.setBackgroundImage(UIImage(named: "button_b.gif"), for: .normal)
        
        buttonC = UIButton(type: .system)
        buttonC.frame = CGRect(x: 0, y:yPos * 2, width:height, height: height)
        buttonC.addTarget(self, action: #selector(pressButtonC), for: .touchUpInside)
        buttonC.setBackgroundImage(UIImage(named: "button_c.gif"), for: .normal)
        
        buttonD = UIButton(type: .system)
        buttonD.frame = CGRect(x: 0, y:yPos * 3, width:height, height: height)
        buttonD.addTarget(self, action: #selector(pressButtonD), for: .touchUpInside)
        buttonD.setBackgroundImage(UIImage(named: "button_d.gif"), for: .normal)
        
        labelA = UILabel(frame: CGRect(x: xPos, y:yPos * 0, width: labelWidth, height:height))
        labelA.textColor = UIColor.white
        labelA.font = UIFont(name: "Menlo", size: fontSize)
        labelB = UILabel(frame: CGRect(x: xPos, y:yPos * 1, width: labelWidth, height:height))
        labelB.textColor = UIColor.white
        labelB.font = UIFont(name: "Menlo", size: fontSize)
        labelC = UILabel(frame: CGRect(x: xPos, y:yPos * 2, width: labelWidth, height:height))
        labelC.textColor = UIColor.white
        labelC.font = UIFont(name: "Menlo", size: fontSize)
        labelD = UILabel(frame: CGRect(x: xPos, y:yPos * 3, width: labelWidth, height:height))
        labelD.textColor = UIColor.white
        labelD.font = UIFont(name: "Menlo", size: fontSize)

        self.mcview.addSubview(buttonA)
        self.mcview.addSubview(buttonB)
        self.mcview.addSubview(buttonC)
        self.mcview.addSubview(buttonD)
        self.mcview.addSubview(labelA)
        self.mcview.addSubview(labelB)
        self.mcview.addSubview(labelC)
        self.mcview.addSubview(labelD)
    }
    
    func generateRandomMCOptions() {
        let rando = arc4random_uniform(UInt32(3))
        
        var ans: String = (listOfVars.last?.getRoundedAns())!
       
        var u: String = (listOfVars.last?.unit)!
        u = Helper.GET_SHORTENED_UNIT(unitName: u)
        
        
        //was toPass == "gravitational force"
        if eqName == "gravitational force" {
            print("preans")
            ans = generateRandomOptions(isReal: true)
            print("postans")
        } else if eqName == "kinetic energy" && u == "J" && checkPow(value: ans) > 9 {
            ans = Helper.CONVERT_TO_SCI_NOTATION(value: ans)
            //testing this...
        }
        
        listOfVars.last?.mcAnswer = ans
        //generate 3 other random numbers that will also have two random decimal spots so they don't look fishy. And for now, make all units match up w/ the answer's
        var listOfNotAnswerLabels: [UILabel] = [labelA, labelB, labelC, labelD]
        switch rando {
        case 0:
            correctMCLetter = "A"
            labelA.text = "\(ans)"
            setUpOtherOptions(filledInLabelNum: 0, unit: u)
            listOfNotAnswerLabels.remove(at: 0)
            configureAnswer(answer: labelA, listOfNotAnswers: listOfNotAnswerLabels)
        case 1:
            correctMCLetter = "B"
            labelB.text = "\(ans)"
            setUpOtherOptions(filledInLabelNum: 1, unit: u)
            listOfNotAnswerLabels.remove(at: 1)
            configureAnswer(answer: labelB, listOfNotAnswers: listOfNotAnswerLabels)
        case 2:
            correctMCLetter = "C"
            labelC.text = "\(ans)"
            setUpOtherOptions(filledInLabelNum: 2, unit: u)
            listOfNotAnswerLabels.remove(at: 2)
            configureAnswer(answer: labelC, listOfNotAnswers: listOfNotAnswerLabels)
        case 3:
            correctMCLetter = "D"
            labelD.text = "\(ans)"
            setUpOtherOptions(filledInLabelNum: 3, unit: u)
            listOfNotAnswerLabels.remove(at: 3)
            configureAnswer(answer: labelD, listOfNotAnswers: listOfNotAnswerLabels)
        default:
            print("HUGE ERROR")
        }
        print("if i see this print statement ill be amazed") //i did not see it!
        listOfNotAnswerLabels = [labelA, labelB, labelC, labelD]
        addUnit(listOfLabels: listOfNotAnswerLabels, unit: u)
    }
    //puts answer in a form similar to the not-answers
    //as of now, all it does is adds decimals to not answers to make them and answer look similar
    //but this can certainly do more in the future!
    func configureAnswer(answer: UILabel, listOfNotAnswers: [UILabel]) {
        var listOfEnds = [String]()
        if answer.text?.contains("*") ?? false || answer.text?.contains("✕") ?? false {
            //gets rid of the *10^5 text to make it a valid number. will add it at end.
            var reachedX = false
            for i in listOfNotAnswers {
                var temp: String = " "
                for j in 0...i.text!.count-1 {
                    let index = i.text!.index(i.text!.startIndex, offsetBy: j)
                    if j == 0 {
                        reachedX = false
                    } else if i.text![index] == "*" || i.text![index] == "✕" {
                        reachedX = true
                        temp.append(i.text![index])
                    } else if reachedX {
                        temp.append(i.text![index])
                    }
                }
                for _ in 1...temp.count {
                    i.text!.removeLast()
                }
                listOfEnds.append(temp)
            }
            var temp: String = " "
            for j in 0...answer.text!.count-1 {
                let index = answer.text!.index(answer.text!.startIndex, offsetBy: j)
                if j == 0 {
                    reachedX = false
                } else if answer.text![index] == "*" || answer.text![index] == "✕" {
                    reachedX = true
                    temp.append(answer.text![index])
                } else if reachedX {
                    temp.append(answer.text![index])
                }
            }
            print(answer.text!)
            for _ in 1...temp.count {
                answer.text!.removeLast()
            }
            print(answer.text!)
            listOfEnds.append(temp)
        }

        var differentDecimals = true
        for i in listOfNotAnswers {
            if getNumOfDecimalPlaces(num: i.text!) == getNumOfDecimalPlaces(num: answer.text!) {
                differentDecimals = false
            }
        }
        if differentDecimals {
            //Thread 1: Fatal error: Can't form Range with upperBound < lowerBound
            if getNumOfDecimalPlaces(num: listOfNotAnswers[0].text!) > getNumOfDecimalPlaces(num: answer.text!) - 1 {
                for _ in getNumOfDecimalPlaces(num: answer.text!) - 1...getNumOfDecimalPlaces(num: listOfNotAnswers[0].text!) {
                    for j in listOfNotAnswers {
                        j.text?.removeLast()
                    }
                }
            } else {
                for _ in getNumOfDecimalPlaces(num: listOfNotAnswers[0].text!)...getNumOfDecimalPlaces(num: answer.text!)-1 {
                    for j in listOfNotAnswers {
                        let rand = arc4random_uniform(9)
                        j.text! += "\(rand)"
                    }
                }
            }
            
        }
        for i in 0...listOfNotAnswers.count {
            if listOfEnds.isEmpty {
                return
            }
            if i == 3 {
                answer.text! += listOfEnds[3]
            } else {
                listOfNotAnswers[i].text! += listOfEnds[i]
            }
        }
    }
    
    func getNumOfDecimalPlaces(num: String) -> Int {
        var numOfDecimalPlaces = 0
        var reachedDecimal = false
        for i in num {
            if i == "." {
                reachedDecimal = true
            } else if reachedDecimal {
                numOfDecimalPlaces += 1
            }
        }
        if numOfDecimalPlaces == 0 {
            print("MAJOR ERROR")
            return 1
        }
        return numOfDecimalPlaces
    }
    
    func addUnit(listOfLabels: [UILabel], unit: String) {
        for i in listOfLabels {
            i.text! += " \(unit)"
        }
    }
    
    //checks the number of digits before decimal. used to determine whether or not to convert something to sci notat or not...
    func checkPow(value: String) -> Int {
        var sum = 0
        for i in 0...value.count-1 {
            let index = value.index(value.startIndex, offsetBy: i)
            if value[index] == "." {
                return sum
            }
            sum += 1
        }
        return sum
    }
    
    func setUpOtherOptions(filledInLabelNum: Int, unit: String) {
        var listOfLabels = [labelA, labelB, labelC, labelD]
        for i in 0...3 {
            if i != filledInLabelNum {
                if eqName == "gravitational force" {
                    //crashes here
                    listOfLabels[i]?.text = "\(generateRandomOptions(isReal: false))"
                } else {
                    listOfLabels[i]?.text = "\(generateRandomAnswer())"
                }
                
            }
        }
    }
    
    //as of now, this is a temp solution to a grav. force PP crash...
    //E 1/31/19: can probably reduce much of this code as there is a good SI-NOT converter in Helper...
    //E 2/6/19: this is majorly fucked... there is an infinite loop that is happening from start of code to the print B statement. It occurrs because this reads the answer w/o the e
    func generateRandomOptions(isReal: Bool) -> String {
        let answer: PhysicsVariable = PhysicsVariable.init(name: (listOfVars.last?.name)!, value: (listOfVars.last?.value)!)
        if answer.value < 0 {
            answer.value = answer.value * -1
        }
        var randomAns: String = ""
        let end: Int = answer.getRoundedAns().count - 1
        var leftOfDecimalCount = -1
        if answer.getRoundedAns().contains("✕") {
            var isBeyondE = false
            var tempS: String = ""
            var isBeyond10 = false
            for i in 0...end {
                let index = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i)
                
                
                
                //IMPORTANT: BELOW IS BAD CODE... FIX IT!!!!!!!!!!!!! WAS FOR SIG FIGS PREVIOUSLY
                if isBeyondE && answer.getRoundedAns()[index] == "0" && !isBeyond10 {
                    let pastIndex = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i-1)
                    if answer.getRoundedAns()[pastIndex] == "1" {
                        isBeyond10 = true
                    }
                } else if i <= Int(UserDefaults.standard.getDecimalPointNum()) {
                    randomAns.append(answer.getRoundedAns()[index])
                } else if answer.getRoundedAns()[index] == "✕" {
                    isBeyondE = true
                } else if isBeyondE && answer.getRoundedAns()[index] != "-" && answer.getRoundedAns()[index] != "+" && isBeyond10{
                    tempS.append(answer.getRoundedAns()[index])
                }
            }
            tempS = unexpo(str: tempS)
            leftOfDecimalCount = Int(tempS)!
        } else {
            
            //this if statement below does not cause inf loop.
            if (listOfVars.last?.value)! < 1000000.0 && (listOfVars.last?.value)! > -1000000.0 {
                
                if isReal {
                    return (listOfVars.last?.getRoundedAns())!
                }
                return "\(generateRandomAnswer())"
            }
            print("look below")
            print(listOfVars.last?.value)
            print(answer.getRoundedAns())
            print(answer.value)
            //this is where the trouble begisn tho
            
            if answer.getRoundedAns().contains("✕") {
                var counte = 0
                var i = 0
                var reachedDec = false
                while(counte < Int(UserDefaults.standard.getDecimalPointNum())) {
                    let index = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i)
                    if answer.getRoundedAns()[index] == "." {
                        reachedDec = true
                    } else if reachedDec {
                        counte += 1
                    }
                    randomAns.append(answer.getRoundedAns()[index])
                    i += 1
                }
            } else {
                for i in 0...Int(UserDefaults.standard.getDecimalPointNum()) {
                    let index = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i)
                    //this is bad code...
                    /*if answer.getRoundedAns()[index] == "." {
                     if isReal {
                     return (listOfVars.last?.getRoundedAns())!
                     }
                     print(answer.getRoundedAns())
                     print("e2")
                     return "\(generateRandomAnswer())"
                     }
                     */
                    if i == 1 {
                        randomAns += "."
                        randomAns.append(answer.getRoundedAns()[index])
                    } else {
                        randomAns.append(answer.getRoundedAns()[index])
                    }
                    
                }
            }
            
            
            var isLeftOfDecimal = true
            randomAns.removeLast()
            for i in 0...end {
                let index = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i)
                if answer.getRoundedAns()[index] == "." {
                    isLeftOfDecimal = false
                } else if isLeftOfDecimal {
                    leftOfDecimalCount += 1
                }
            }
        }
        
        if isReal {
            randomAns += " ✕ 10^\(leftOfDecimalCount)"
            return Helper.exponentize(str: randomAns)
        }
        
        let toChangePower = arc4random_uniform(UInt32(3))
        switch toChangePower {
        case 0:
            leftOfDecimalCount -= 1
            //10^x-1
        case 1:
            leftOfDecimalCount += 1
        //10^x+1
        default:
            break
            //random base numb
        }
        let a = arc4random_uniform(UInt32(9))
        let b = arc4random_uniform(UInt32(9))
        let c = arc4random_uniform(UInt32(9))
        let d = arc4random_uniform(UInt32(9))
        randomAns = "\(a).\(b)\(c)\(d)"
        randomAns += " ✕ 10^\(leftOfDecimalCount)"
        return Helper.exponentize(str: randomAns)
    }
    
    func unexpo(str: String) -> String {
        var newStr = ""
        for i in str {
            switch i {
            case "\u{207B}":
                newStr.append("-")
            case "\u{2070}":
                newStr.append("0")
            case "\u{00B9}":
                newStr.append("1")
            case "\u{00B2}":
                newStr.append("2")
            case "\u{00B3}":
                newStr.append("3")
            case "\u{2074}":
                newStr.append("4")
            case "\u{2075}":
                newStr.append("5")
            case "\u{2076}":
                newStr.append("6")
            case "\u{2077}":
                newStr.append("7")
            case "\u{2078}":
                newStr.append("8")
            case "\u{2079}":
                newStr.append("9")
                
            default:
                print("error!")
            }
        }
        return newStr
    }
    
    //fix/improved
    func generateRandomAnswer() -> String {
        while(true) {
            var answer: Double = (listOfVars.last?.value)!
            let a = answer < 1 && answer > 0
            let b = answer > -1 && answer < 0
            if a || b {
                let ans: String = (listOfVars.last?.mcAnswer)!
                var randoAns: String = ""
                var isBeyondDecimal = false
                while !randoAns.contains("1") && !randoAns.contains("2") && !randoAns.contains("3") && !randoAns.contains("4") && !randoAns.contains("5") && !randoAns.contains("6") && !randoAns.contains("7") && !randoAns.contains("8") && !randoAns.contains("9") {
                    randoAns.removeAll()
                    isBeyondDecimal = false
                    for i in 0...ans.count - 1 {
                        let index = ans.index(ans.startIndex, offsetBy: i)
                        if isBeyondDecimal {
                            var ran: Int = 0
                            if Int(arc4random_uniform(UInt32(2))) > 0 {
                                ran = Int(arc4random_uniform(UInt32(9)))
                            }
                            randoAns += "\(ran)"
                        } else if ans[index] == "." {
                            randoAns += "."
                            isBeyondDecimal = true
                        } else {
                            randoAns.append(ans[index])
                        }
                    }
                }
                print("HEY. \(randoAns)")
                print(RoundByDecimals.ROUND_BY_DECIMALS(value: randoAns))
                return randoAns
            }
            
            //start off with a ton of sig figs, then round at end
            answer = Helper.ROUND_BY_DECIMAL_POINTS(value: answer, roundBy: round(UserDefaults.standard.getDecimalPointNum()))
            print(answer)
            if abs(answer) > 100000000 {
                return generateRandomOptions(isReal: false)
            }
            let x = Int(abs(answer)) + 1
            var random: Double = Double(arc4random_uniform(UInt32(x * 10)))
            
            let numOfDecimals = arc4random_uniform(UInt32(4))
            if numOfDecimals > 1 {
                let randomDecimal = Double(arc4random_uniform(UInt32(1000)))
                random += (randomDecimal / 10000.0) + 1.0
            } else if numOfDecimals == 1 {
                let randomDecimal = Double(arc4random_uniform(UInt32(100)))
                random += (randomDecimal / 1000.0) + 1.0
            } else {
                let randomDecimal = Double(arc4random_uniform(UInt32(10)))
                random += (randomDecimal / 100.0) + 1.0
            }
            
            for index in 1...10 {
                var kev = 0
                if Int(abs(random)) > x {
                    kev = Int(random) / x
                } else {
                    if Int(random) == 0 {
                        kev = x / 2
                    } else {
                        kev = x / Int(random)
                    }
                }
                
                if abs(kev) * 10 == index {
                    if random != 0 {
                        let neg = Int(arc4random_uniform(UInt32(3)))
                        if neg == 1 && !(listOfVars.last?.isScalar)! {
                            random = random * -1.0
                        }
                        if answer < 1 && answer > 0 {
                            if neg == 1 {
                                random += 1
                            } else {
                                random -= 1
                            }
                            
                        } else if answer < 0 && answer > -1 {
                            if neg == 1 {
                                random -= 1
                            } else {
                                random += 1
                            }
                        }
                        let v: String = "\(random)"
                        if UserDefaults.standard.getEnableSigFigs() {
                            return SigFigCalculator.init(number: v).getRoundedAnswer()
                        } else {
                            return RoundByDecimals.ROUND_BY_DECIMALS(value: v)
                        }
                        
                    }
                }
            }
        }
    }
    
    @objc func pressButtonA(_ sender: UIButton) {
        setButtonTint(button: buttonA)
        checkAnswerBtn.isEnabled = true
    }
    
    @objc func pressButtonB(_ sender: UIButton) {
        setButtonTint(button: buttonB)
        checkAnswerBtn.isEnabled = true
    }
    
    @objc func pressButtonC(_ sender: UIButton) {
        setButtonTint(button: buttonC)
        checkAnswerBtn.isEnabled = true
    }
    
    @objc func pressButtonD(_ sender: UIButton) {
        setButtonTint(button: buttonD)
        checkAnswerBtn.isEnabled = true
    }
    
    func setButtonTint(button: UIButton) {
        let listOfBtns: [UIButton] = [buttonA, buttonB, buttonC, buttonD]
        for i in 0...3 {
            if listOfBtns[i]  == button {
                listOfBtns[i].isEnabled = false
            } else {
                listOfBtns[i].isEnabled = true
            }
        }
        fixBtnImage()
    }
    
    func saveMC() {
        listOfMCOptions.removeAll()
        if answerTextField.isHidden {
            let listOfLabelText: [String] = [labelA.text!, labelB.text!, labelC.text!, labelD.text!]
            for i in listOfLabelText {
                listOfMCOptions.append(i)
            }
        } else {
            listOfMCOptions.append("N/A")
        }
    }
    
    func showAlertLabel(_ isCorrect: Bool) {
        if isCorrect {
            let alertLabel = UIAlertController(title: "Correct", message: "Nice job!!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: ":)", style: .cancel, handler: { (ACTION: UIAlertAction) in
                
            })
            alertLabel.addAction(alertAction)
            present(alertLabel, animated: true)
            didUserFinishProblem = true
        } else {
            let alertLabel = UIAlertController(title: "Incorrect", message: "Nice try! ", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Try again!", style: .cancel, handler: { (ACTION: UIAlertAction) in
                
            })
            alertLabel.addAction(alertAction)
            present(alertLabel, animated: true)
        }
        
    }
    @IBAction func checkAnswerBtnAction(_ sender: UIButton) {
        if answerTextField.isHidden {
            switch true {
            case !buttonA.isEnabled:
                if correctMCLetter == "A" {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            case !buttonB.isEnabled:
                if correctMCLetter == "B" {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            case !buttonC.isEnabled:
                if correctMCLetter == "C" {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            case !buttonD.isEnabled:
                if correctMCLetter == "D" {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            default:
                print("error w/ MC answer checker")
            }
        } else {
            
            guard let x = Double(answerTextField.text!) else { showInvalidErrorAlert(); return }
            //zz is used for checking answer accuracy
            let zz: Double = (listOfVars.last?.value)!
            print(zz)
            let userAns: Double = x
            var units: String = ""
            if !UserDefaults.standard.isUnitsShownPP() {
                units = (listOfVars.last?.getSIUnits())!
            } else {
                units = unitsChosen
            }
            //for rounding differences... might want to find more accurate way to get this range
            let ans: Double = (listOfVars.last?.value)!
            if ans > 0 {
                let ansHighRange = ans + (ans / 100.0)
                let ansLowRange = ans - (ans / 100.0)
                
                if units == (listOfVars.last?.getSIUnits())! && ansHighRange > userAns && userAns > ansLowRange {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            } else {
                let ansLowRange = ans + (ans / 100.0)
                let ansHighRange = ans - (ans / 100.0)
                
                if units == (listOfVars.last?.getSIUnits())! && ansHighRange > userAns && userAns > ansLowRange {
                    isCorrect(isCorrect: true)
                } else {
                    isCorrect(isCorrect: false)
                }
            }
        }
    }
    
    func showInvalidErrorAlert() {
        let errorAlert = UIAlertController(title: "Error!", message: "Input a valid value.", preferredStyle: .alert)
        let errorAlertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
        })
        errorAlert.addAction(errorAlertAction)
        present(errorAlert, animated: true)
    }
    
    func isCorrect(isCorrect: Bool) {
        if isCorrect {
            showAlertLabel(true)
            answerTextField.backgroundColor = UIColor.green
            enableOrDisableMCButtons(toEnable: false)
            checkAnswerBtn.isEnabled = false
        } else {
            showAlertLabel(false)
            answerTextField.backgroundColor = UIColor.red
            hintBtn.isHidden = false
        }
    }
    
    //problem- when i clicked the btn after getting it wrong w/o selecting units but having right answer, it said that i should check decimal. fix!
    @IBAction func getHintBtnAction(_ sender: UIButton) {
        guard let x = Double(answerTextField.text!) else { showHintAlert(4); return }
        
        if listOfVars.last?.value == x && UserDefaults.standard.isUnitsShownPP() {
            showHintAlert(0)
        } else if Int(x) == Int((listOfVars.last?.value)!) {
            showHintAlert(2)
        } else if unitsChosen == listOfVars.last?.unit {
            showHintAlert(1)
        } else if UserDefaults.standard.isUnitsShownPP() {
            showHintAlert(3)
        } else {
            showHintAlert(4)
        }
    }
    
    //Find way to make this work (probably depricated)
    func getAnswer(_ answer: PhysicsVariable) -> Double {
        return (listOfVars.last?.value)!
    }
    
    func showHintAlert(_ typeOfHint: Int) {
        //later change to a switch statement w/ more than 2 options (so it now takes in ints)- one that deals w/ rounding DONE
        var listOfAlertMessages = ["Check your units", "Check your calculations", "Don't forget decimals", "Wrong units and number. Make sure to convert units and select correct units", "Wrong number. Make sure to double check conversions and calculations"]
        let hintAlert = UIAlertController(title: "Hint:", message: listOfAlertMessages[typeOfHint], preferredStyle: .alert)
        let hintAlertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
        })
        hintAlert.addAction(hintAlertAction)
        present(hintAlert, animated: true)
    }
    
    @IBAction func saveProblem(_ sender: Any) {
        let saveQuestionAlert = UIAlertController(title: "Save Problem", message: "Enter name for saved problem...", preferredStyle: .alert)
        
        saveQuestionAlert.addTextField { (field) in
        }
        
        let saveQuestionAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            self.savedName = saveQuestionAlert.textFields?[0].text ?? "Saved Problem \(UserDefaults.standard.getSavedProblemCounter)"
            self.saveTheProblem()
        })
        saveQuestionAlert.addAction(saveQuestionAction)
        
        present(saveQuestionAlert, animated: true)
        
    }
    
    func saveTheProblem() {
        if savedName == "" {
            savedName = "Saved Problem \(Int(UserDefaults.standard.getSavedProblemCounter()))"
        }
        
        var listOfAnswers: [PhysicsVariable] = [PhysicsVariable]()
        var listOfKnowns: [PhysicsVariable] = [PhysicsVariable]()
        if eqName == "kinematics" {
            listOfAnswers.append(listOfVarsForSaved[listOfVarsForSaved.count - 2])
        } else if listOfVarsForSaved.isEmpty {
            listOfVarsForSaved = listOfVars
        }
        listOfAnswers.append(listOfVarsForSaved[listOfVarsForSaved.count - 1])
        for i in 0...listOfVarsForSaved.count - listOfAnswers.count - 1 {
            listOfKnowns.append(listOfVarsForSaved[i])
        }
        let prompt: String = problemTextView.text
        let savedProblem = SavedProblem.init(answers: listOfAnswers, knownValues: listOfKnowns, equation: eqName, savedProblemName: savedName, prompt: prompt)
        
        let userDefaults = UserDefaults.standard
        
        var savedProblems = [SavedProblem]()
        if userDefaults.getSavedProblemCounter() > 1 {
            let decoded  = userDefaults.object(forKey: "savedProblems") as! Data
            savedProblems = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [SavedProblem]
        }
        savedProblems.append(savedProblem)
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedProblems)
        userDefaults.set(encodedData, forKey: "savedProblems")
        userDefaults.synchronize()
        
        UserDefaults.standard.setSavedProblemCounter(value: UserDefaults.standard.getSavedProblemCounter() + 1)
        savedName = "Saved Problem \(Int(UserDefaults.standard.getSavedProblemCounter()))"
        
        let saveAlert = UIAlertController(title: "Problem was saved.", message: "", preferredStyle: .alert)
        present(saveAlert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            saveAlert.dismiss(animated: true, completion: nil)
        }
    }
    
    //uipickerview stuff:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitsPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitsPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitsChosen = unitsPickerData[row] as String
    }
    
    /*func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = unitsPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Menlo", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        var fontSize: CGFloat = 15
        switch true {
        case self.view.frame.height > 600 && self.view.frame.width < 500:
            fontSize = 15
        case self.view.frame.width > 500:
            fontSize = 40
        default:
            fontSize = 13
        }
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Menlo", size: fontSize)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = unitsPickerData[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        switch true {
        case self.view.frame.height > 600 && self.view.frame.width < 500:
            return 22.0
        case self.view.frame.width > 500:
            return 48.0
        default:
            return 22.0
        }
        
    }
    
    //text field restrictions:
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                } else {
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                if string == "-" {
                    let countNegs = textField.text!.components(separatedBy:"-").count - 1
                    if countNegs <= 1 {
                        return true
                    } else {
                        if countNegs > 1 && string == "-" {
                            return false
                        } else {
                            return true
                        }
                    }
                } else {
                    if string == "e" {
                        let countdots = textField.text!.components(separatedBy:"e").count - 1
                        if countdots == 0 {
                            return true
                        } else {
                            if countdots > 0 && string == "e" {
                                return false
                            } else {
                                return true
                            }
                        }
                    } else {
                        return false
                    }
                }
            }
        }
    }
    
    func helpMode() {
        //could use something to tell users that they are in Help Mode...
        //like a label at the top or whereever it would fit that says help mode
        //or it can be a banner at top that can just be dismissed with an x... idk
        titleLabel.text = "Practice Problems- kinematics"
        eqName = "kinematics"
        setUpProblemType()
        generateProblem()
        
        disableEverything()
        addHelpModeBtns()
        setUpInvisibleBtns()
        
        
    }
    
    func addHelpModeBtns() {
        
        var factor: CGFloat = 1
        if self.view.frame.width > 500 {
            factor = 2
        }
        
        let helpView = UIView(frame: CGRect(x: 0, y: self.view.frame.maxY - 50*factor, width: self.view.frame.width*factor, height: 50*factor))
        helpView.backgroundColor = UIColor.gray
        self.view.addSubview(helpView)
        
        moveStuff(minY:helpView.frame.minY)
        
        let leftArrow: UIButton = UIButton(frame: CGRect(x: 50*factor, y: self.view.frame.maxY - 50*factor, width: 50*factor, height: 50*factor))
        leftArrow.setBackgroundImage(UIImage.init(named: "left_arrow.png"), for: .normal)
        leftArrow.addTarget(self, action: #selector(prevView), for: .touchUpInside)
        self.view.addSubview(leftArrow)
        
        let rightArrow: UIButton = UIButton(frame: CGRect(x: self.view.frame.maxX - 100*factor, y: self.view.frame.maxY - 50*factor, width: 50*factor, height: 50*factor))
        rightArrow.setBackgroundImage(UIImage.init(named: "right_arrow.png"), for: .normal)
        rightArrow.addTarget(self, action: #selector(nextView), for: .touchUpInside)
        self.view.addSubview(rightArrow)
        
        let exitBtn: UIButton = UIButton(frame: CGRect(x: self.view.frame.midX - factor*75/2, y: self.view.frame.maxY - 40*factor, width: 75*factor, height: 25*factor))
        exitBtn.setBackgroundImage(UIImage(named: "button_exit-help.gif"), for: .normal)
        //later add a nice picture for this (or just copy the one from quiz)
        exitBtn.addTarget(self, action: #selector(exitHelp), for: .touchUpInside)
        self.view.addSubview(exitBtn)
    }
    
    func moveStuff(minY: CGFloat) {
        if arrowBtn.frame.maxY < minY {
            return
        }
        hintBtn.frame = CGRect(x: hintBtn.frame.minX, y: minY - 5 - hintBtn.frame.height, width: hintBtn.frame.width, height: hintBtn.frame.height)
        arrowBtn.frame = CGRect(x: arrowBtn.frame.minX, y: minY - 5 - arrowBtn.frame.height, width: arrowBtn.frame.width, height: arrowBtn.frame.height)
        saveProblemBtn.frame = CGRect(x: saveProblemBtn.frame.minX, y: minY - 5 - saveProblemBtn.frame.height, width: saveProblemBtn.frame.width, height: saveProblemBtn.frame.height)
        checkAnswerBtn.frame = CGRect(x: checkAnswerBtn.frame.minX, y: saveProblemBtn.frame.minY - 5 - checkAnswerBtn.frame.height, width: checkAnswerBtn.frame.width, height: checkAnswerBtn.frame.height)
    }
    
    func disableEverything() {
        for i in self.view.subviews {
            i.isUserInteractionEnabled = false
        }
    }
    
    func setUpInvisibleBtns() {
        var listOfBtns: [UIButton] = [UIButton]()
        listOfBtns.append(UIButton(frame: titleLabel.frame))
        listOfBtns.append(UIButton(frame: moreBtn.frame))
        listOfBtns.append(UIButton(frame: settingsBtn.frame))
        listOfBtns.append(UIButton(frame: problemTextView.frame))
        listOfBtns.append(UIButton(frame: mcview.frame))
        listOfBtns.append(UIButton(frame: checkAnswerBtn.frame))
        listOfBtns.append(UIButton(frame: hintBtn.frame))
        listOfBtns.append(UIButton(frame: arrowBtn.frame))
        listOfBtns.append(UIButton(frame: saveProblemBtn.frame))

        for i in 0...listOfBtns.count-1 {
            listOfBtns[i].tag = i
            listOfBtns[i].backgroundColor = UIColor.clear
            listOfBtns[i].addTarget(self, action: #selector(openPopup), for: .touchUpInside)
            self.view.addSubview(listOfBtns[i])
        }
    }
    
    @objc func openPopup(_ sender: UIButton) {
        if popUpAlreadyExists() {
            closePopup(self)
            return
        }
        
        var factor:CGFloat = 1
        if self.view.frame.width > 500 {
            factor = 2.5
        }
        let popUp: UITextView = UITextView(frame: CGRect(x: self.view.frame.midX-120*factor, y: self.view.frame.midY - 90*factor, width: 240*factor, height: 180*factor))
        popUp.text = HelpPopups.PRACPRO[sender.tag]
        popUp.tag = -64
        popUp.isEditable = false
        popUp.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        popUp.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE() + 1*factor)
        self.view.addSubview(popUp)
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        
        self.view.addGestureRecognizer(exitGesture)
        /*tag:
         0: titleLabel (select calculator)
         1: returnbtn
         2: showowkrview
         3: previous showwork
         4: next showwork
         5: page number
         */
    }
    
    func popUpAlreadyExists() -> Bool {
        for i in self.view.subviews {
            if i.tag == -64 {
                return true
            }
        }
        return false
    }
    
    @objc func closePopup(_ sender: Any) {
        for i in self.view.subviews {
            if i.tag == -64 {
                if let viewWithTag = self.view.viewWithTag(i.tag) {
                    viewWithTag.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func exitHelp(_ sender: UIButton) {
        exitHelpMode = true
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    @objc func nextView(_ sender: UIButton) {
        performSegue(withIdentifier: "quiz setup", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "unit converter", sender: self)
    }

}
