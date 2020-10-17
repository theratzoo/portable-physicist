//
//  KinematicsCalculatorViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/1/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

//Hi. Ima delete you soon ;)

import UIKit

class KinematicsCalculatorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var answerOneLabel: UILabel!
    @IBOutlet weak var answerTwoLabel: UILabel!
    
    //below are for the show work feature:
    @IBOutlet weak var showWorkTextView: UITextView!
    @IBOutlet weak var showWorkButton: UIButton!
    @IBOutlet weak var showWorkNavBar: UINavigationBar!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    //V 1.1 New Outlets below:
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var varNamePickerView: UIPickerView!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var inputValueTextField: UITextField! //<-- might need action as well for after user stops typing
    @IBOutlet weak var nextCalculatorBtn: UIBarButtonItem!
    @IBOutlet weak var prevCalculatorBtn: UIBarButtonItem!
    @IBOutlet weak var anotherCalculationBtn: UIButton!
    @IBOutlet weak var practiceProblemsBtn: UIButton!
    @IBOutlet weak var unitConverterBtn: UIButton!
    @IBOutlet weak var calculateNavBar: UINavigationBar!
    
    //test outlet:
    @IBOutlet weak var secondVarNamePickerView : UIPickerView!
    var secondVarNamePickerData : [String] = [String]()
    var secondVarNameChosen : String = "" //probably unneccesary
    
    // ...and the third one .-.
    @IBOutlet weak var thirdVarNamePickerView : UIPickerView!
    var thirdVarNamePickerData : [String] = [String]()
    
    var varNamePickerData : [String] = [String]()
    var varNameChosen : String = ""
    
    //eventually get rid of these for good (below):
    
    //testing out PhysicsVariable class... a big WIP (can work on it for a weekend... need to save backup before doing this)
    var a:PhysicsVariable = PhysicsVariable.init(name: "a")
    var iV:PhysicsVariable = PhysicsVariable.init(name: "iV")
    var fV:PhysicsVariable = PhysicsVariable.init(name: "fV")
    var d:PhysicsVariable = PhysicsVariable.init(name: "d")
    var t:PhysicsVariable = PhysicsVariable.init(name: "t")
    
    //kill below 3
    var showWorkPg : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWorkTextView.isHidden = true
        showWorkNavBar.isHidden = true
        answerOneLabel.isHidden = true
        answerTwoLabel.isHidden = true
        anotherCalculationBtn.isHidden = true
        practiceProblemsBtn.isHidden = true
        unitConverterBtn.isHidden = true
        showWorkButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        //Below needs to be fixed due to V1.1
        /*
         Idea for improvment:
         -In the unit convert view controller, know how many are being converted.
         -Then, based on number of units being converted, eliminate that many "steps"
         Example: if 2 are being converted, put user in page 3 with the 2 converted ones set up already as values.
         */
        prevCalculatorBtn.isEnabled = false
        var count : Int = 0
        var x : String = UnitConverterViewController.GlobalVariable.myString
        if x.contains("a") {
            x.remove(at: x.startIndex)
            a.value = Double(x)!
        } else if x.contains("d") {
            x.remove(at: x.startIndex)
            d.value = Double(x)!
        } else if x.contains("i") {
            x.remove(at: x.startIndex)
            iV.value = Double(x)!
        } else if x.contains("f") {
            x.remove(at: x.startIndex)
            fV.value = Double(x)!
        } else if x.contains("t") {
            x.remove(at: x.startIndex)
            t.value = Double(x)!
        } else {
            print("x- empty")
            count -= 1
        }
        count += 1
        var y : String = UnitConverterViewController.GlobalVariable.secondConversion
        if y.contains("a") {
            y.remove(at: y.startIndex)
            a.value = Double(y)!
        } else if y.contains("d") {
            y.remove(at: y.startIndex)
            d.value = Double(y)!
        } else if y.contains("i") {
            y.remove(at: y.startIndex)
            iV.value = Double(y)!
        } else if y.contains("f") {
            y.remove(at: y.startIndex)
            fV.value = Double(y)!
        } else if y.contains("t") {
            y.remove(at: y.startIndex)
            t.value = Double(y)!
        } else {
            print("y- empty")
            count -= 1
        }
        count += 1
        
        //Below: V 1.1
        
        self.varNamePickerView.delegate = self
        self.varNamePickerView.dataSource = self
        inputValueTextField.delegate = self
        varNamePickerData = ["Select Variable:", "Initial Velocity", "Final Velocity", "Time", "Displacement", "Acceleration"]
        
        //1.1 second picker view testings:
        self.secondVarNamePickerView.delegate = self
        self.secondVarNamePickerView.dataSource = self
        secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Time", "Displacement", "Acceleration"]
        
        //third picker view ;-;
        self.thirdVarNamePickerView.delegate = self
        self.thirdVarNamePickerView.dataSource = self
        thirdVarNamePickerData = ["Select Variable:", "Initial Velocity", "Time", "Displacement"]
        
        varNamePickerView.tag = 1
        secondVarNamePickerView.tag = 2
        thirdVarNamePickerView.tag = 3
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //1.1 as well (testing)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var listOfVars : [PhysicsVariable] = [PhysicsVariable]()
        var isSetUp : Bool = false
        while(!isSetUp) {
            switch true {
            case iV.isValueSet:
                listOfVars.append(iV)
                iV.isValueSet = false
            case fV.isValueSet:
                listOfVars.append(fV)
                fV.isValueSet = false
            case t.isValueSet:
                listOfVars.append(t)
                t.isValueSet = false
            case a.isValueSet:
                listOfVars.append(a)
                a.isValueSet = false
            case d.isValueSet:
                listOfVars.append(d)
                d.isValueSet = false
            default:
                isSetUp = true
            }
        }
        
        if (segue.identifier == "options") {
            let svc = segue.destination as! OptionsViewController;
            if(countingLabel.isHidden) {
                svc.toPass = "Answer"
                
            } else {
                svc.toPass = "\(countingLabel.text!) kinematics"
            }
            if !listOfVars.isEmpty {
                svc.listOfVars = listOfVars
            }
        }
        
    }
    
    //depricated
    @IBAction func settingAction(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "options", sender: self)
    }
    
    //1.1 second pickerview test:
    
    func setUpThirdPickerView(_ varName: String, _ pgNumber: Int) {
        if pgNumber != 3 {
            print("not time for 3rd page")
            return
        }
        //print("hey, its a \(varName)")
        thirdVarNamePickerData.removeAll()
        for x in secondVarNamePickerData {
            if x != varName {
                thirdVarNamePickerData.append(x)
            }
        }
        thirdVarNamePickerView.reloadAllComponents()
        thirdVarNamePickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func setUpSecondPickerView(_ varName: String, _ pgNumber: Int) {
        if pgNumber != 2 {
            print("oops")
            return
        }
        print("hey, its a \(varName)")
        switch varName {
        case "Initial Velocity":
            secondVarNamePickerData = ["Select Variable:", "Final Velocity", "Time", "Displacement", "Acceleration"]
        case "Final Velocity":
            secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Time", "Displacement", "Acceleration"]
        case "Time":
            secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Final Velocity", "Displacement", "Acceleration"]
        case "Acceleration":
            secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Final Velocity", "Time", "Displacement"]
        case "Displacement":
            secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Final Velocity", "Time", "Acceleration"]
        default:
            print("error- cannot setUp secondPickerView properly")
            secondVarNamePickerData = ["Select Variable:", "Initial Velocity", "Final Velocity", "Time", "Displacement", "Acceleration"]
        }
        secondVarNamePickerView.reloadAllComponents()
        secondVarNamePickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    
    //this is also 1.1 but w/e
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //**Start of V 1.1 Code**
    
    func loadPrevPage(_ pgNumber: Int) {
        switch pgNumber {
        case fV.varNumber:
            inputValueTextField.text = String(fV.value)
            varNamePickerView.selectRow(2, inComponent: 0, animated: true)
        case iV.varNumber:
            inputValueTextField.text = String(iV.value)
            varNamePickerView.selectRow(1, inComponent: 0, animated: true)
        case t.varNumber:
            inputValueTextField.text = String(t.value)
            varNamePickerView.selectRow(3, inComponent: 0, animated: true)
        case d.varNumber:
            inputValueTextField.text = String(d.value)
            varNamePickerView.selectRow(4, inComponent: 0, animated: true)
        case a.varNumber:
            inputValueTextField.text = String(a.value)
            varNamePickerView.selectRow(5, inComponent: 0, animated: true)
        default:
            inputValueTextField.text?.removeAll()
        }
    }
    
    func setUpPage(_ pgNumber: Int) {
        //WIP
        switch pgNumber {
        case 1:
            varNamePickerView.isHidden = false
            secondVarNamePickerView.isHidden = true
            thirdVarNamePickerView.isHidden = true
            countingLabel.text = "1st Value"
            prevCalculatorBtn.isEnabled = false
        case 2:
            varNamePickerView.isHidden = true
            secondVarNamePickerView.isHidden = false
            thirdVarNamePickerView.isHidden = true
            countingLabel.text = "2nd Value"
            prevCalculatorBtn.isEnabled = true
            nextCalculatorBtn.title = "Next"
        case 3:
            varNamePickerView.isHidden = true
            secondVarNamePickerView.isHidden = true
            thirdVarNamePickerView.isHidden = false
            countingLabel.text = "3rd Value"
            nextCalculatorBtn.title = "Calculate"
            nextCalculatorBtn.isEnabled = true
        case 4:
            varNamePickerView.isHidden = true
            secondVarNamePickerView.isHidden = true
            thirdVarNamePickerView.isHidden = true
            countingLabel.isHidden = true
            nextCalculatorBtn.isEnabled = false
            varNamePickerView.isHidden = true
            inputValueTextField.isHidden = true
            
            answerOneLabel.isHidden = false
            answerTwoLabel.isHidden = false
            anotherCalculationBtn.isHidden = false
            practiceProblemsBtn.isHidden = false
            unitConverterBtn.isHidden = false
            showWorkButton.isHidden = false
            var kinematicsVarArray: [PhysicsVariable] = [PhysicsVariable]()
            //WIP
            if iV.varNumber == -1 {
                iV.isUnknown = true
            } else {
                kinematicsVarArray.append(iV)
            }
            if fV.varNumber == -1 {
                fV.isUnknown = true
            } else {
                kinematicsVarArray.append(fV)
            }
            if t.varNumber == -1 {
                t.isUnknown = true
            } else {
                kinematicsVarArray.append(t)
            }
            if a.varNumber == -1 {
                t.isUnknown = true
            } else {
                kinematicsVarArray.append(a)
            }
            if d.varNumber == -1 {
                d.isUnknown = true
            } else {
                kinematicsVarArray.append(d)
            }
            let calculate:KinematicsEquations = KinematicsEquations.init(listOfKnowns: kinematicsVarArray)
            calculate.doKinemtaicsEquation()
            /*let uOne : PhysicsVariable = findFirstUnknown()
            let uTwo : PhysicsVariable = findSecondUnknown()*/
            //HERE: PUT SOME VARIABLES, METHODS, ETC. TO FIND AND SET UP THE TWO UNKNOWN KINEMATICS VARIABLES SO BELOW METHOD WOULD WORK
            setFirstUnknown(calculate)
            setSecondUnknown(calculate)
            answerLabels()
        default:
            print("berp")
        }
        loadPrevPage(pgNumber)
        
    }
    //for prev button: can have a label that shows the unit and value of the past one...
    @IBAction func prevBtnAction(_ sender: UIBarButtonItem) { //will suck to implement this :(
        var pgNumber = 0
        if(countingLabel.text?.contains("1"))! {
            pgNumber = 0
            prevCalculatorBtn.isEnabled = false
        } else if(countingLabel.text?.contains("2"))! {
            pgNumber = 1
        } else {
            pgNumber = 2
        }
        setUpSecondPickerView(varNameChosen, pgNumber)
        setUpThirdPickerView(varNameChosen, pgNumber)
        setUpPage(pgNumber)
    }
    @IBAction func nextButtonAction(_ sender: UIBarButtonItem) {
        if (inputValueTextField.text?.isEmpty)! {
            alertAction(type: "blank")
            return
        } else if varNameChosen == "Select Variable:" || varNameChosen == ""{
            alertAction(type: "select var")
            return
        }
        varNamePickerView.selectRow(0, inComponent: 0, animated: true)
        var pgNumber = 0
        if(countingLabel.text?.contains("1"))! { // bad check, think of better one later
            pgNumber = 1
        } else if(countingLabel.text?.contains("2"))! {
            pgNumber = 2
        } else {
            pgNumber = 3
        }
        //print(t.varNumber)
        switch varNameChosen {
        case "Initial Velocity":
            if iV.varNumber != pgNumber && iV.varNumber != -1 {
                alertAction(type: "repeat units")
                return
            } else {
                checkIfRepeatVars("iV", pgNumber)
                iV.value = Double(inputValueTextField.text!)!
                iV.varNumber = pgNumber
            }
        case "Final Velocity":
            if fV.varNumber != pgNumber && fV.varNumber != -1 {
                alertAction(type: "repeat units")
                return
            } else {
                checkIfRepeatVars("fV", pgNumber)
                fV.value = Double(inputValueTextField.text!)!
                fV.varNumber = pgNumber
            }
        case "Time":
            if t.varNumber != pgNumber && t.varNumber != -1 {
                return
            } else {
                checkIfRepeatVars("t", pgNumber)
                t.value = Double(inputValueTextField.text!)!
                t.varNumber = pgNumber
            }
        case "Displacement":
            if d.varNumber != pgNumber && d.varNumber != -1 {
                alertAction(type: "repeat units")
                return
            } else {
                checkIfRepeatVars("d", pgNumber)
                d.value = Double(inputValueTextField.text!)!
                d.varNumber = pgNumber
            }
        case "Acceleration":
            if a.varNumber != pgNumber && a.varNumber != -1 {
                alertAction(type: "repeat units")
                return
            } else {
                checkIfRepeatVars("a", pgNumber)
                a.value = Double(inputValueTextField.text!)!
                a.varNumber = pgNumber
            }
        default:
            print("error")
        }
        pgNumber += 1
        setUpSecondPickerView(varNameChosen, pgNumber)
        setUpThirdPickerView(varNameChosen, pgNumber)
        setUpPage(pgNumber)
        
    }
    
    func checkIfRepeatVars(_ varName: String, _ pgNumber: Int) {
        switch pgNumber {
        case fV.varNumber:
            if fV.name != varName {
                fV.totalReset()
            }
        case iV.varNumber:
            if iV.name != varName {
                iV.totalReset()
            }
        case d.varNumber:
            if d.name != varName {
                d.totalReset()
            }
        case a.varNumber:
            if a.name != varName {
                a.totalReset()
            }
        case t.varNumber:
            if t.name != varName {
                t.totalReset()
            }
        default:
            print("could not find anotherOne")
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return varNamePickerData.count
        case 2:
            return secondVarNamePickerData.count
        case 3:
            return thirdVarNamePickerData.count
        default:
            print("error- cannot find tag of pickerView")
            return varNamePickerData.count
        }
        
        /*
         var pgNumber: Int = 0
         if countingLabel.text.contains("1") {
         pgNumber = 1
         } else if countingLabel.text.contains("2") {
         pgNumber = 2
         }
         switch pgNumber {
         case 1:
         return 6
         case 2:
         return 5
         default:
         <#code#>
         }
        */
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return varNamePickerData[row]
        case 2:
            return secondVarNamePickerData[row]
        case 3:
            return thirdVarNamePickerData[row]
        default:
            return varNamePickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            varNameChosen = varNamePickerData[row] as String
        case 2:
            varNameChosen = secondVarNamePickerData[row] as String //might want to instead use secondVarNameChosen but idk yet...
        case 3:
            varNameChosen = thirdVarNamePickerData[row] as String
        default:
            varNameChosen = varNamePickerData[row] as String
        }
        
    }
    
    func alertAction(type: String) {
        switch type {
        case "blank":
            let alert = UIAlertController(title: "Error!", message: "You must input a number into the calculator!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case "repeat units":
            let alert = UIAlertController(title: "Error!", message: "You have already inputed this unit. Please select a different one or change the one prior.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case "select var":
            let alert = UIAlertController(title: "Error!", message: "You must select a variable before proceeding.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            print("error: alertAction type not found")
        }
    }
    
    //**end of V 1.1**
    
    //Show Work Stuff
    
    @IBAction func previousBtnAction(_ sender: UIBarButtonItem) {
        nextButton.isEnabled = true
        nextButton.tintColor = UIColor.blue
        if showWorkPg == 0 {
            previousButton.tintColor = UIColor.gray
            previousButton.isEnabled = false
        }
        else {
            previousButton.isEnabled = true
            showWorkPg = showWorkPg - 1
            if showWorkPg == 0 {
                previousButton.isEnabled = false
            }
        }
        showWorkPageView(showWorkPg)
    }
    
    @IBAction func nextBtnAction(_ sender: UIBarButtonItem) {
        previousButton.isEnabled = true
        previousButton.tintColor = UIColor.blue
        //find way to fucking fix this...
        if showWorkPg == 7 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
            showWorkPg = showWorkPg + 1
            if showWorkPg == 7 {
                nextButton.isEnabled = false
            } else if showWorkPg == 3 && answerTwoLabel.text == "a2"{
                nextButton.isEnabled = false
            }
        }
        showWorkPageView(showWorkPg)
    }
    
    func setSecondUnknown(_ eq: KinematicsEquations) {
        switch 2 {
        case eq.iV.unknownNumber:
            iV = eq.iV
        case eq.fV.unknownNumber:
            fV = eq.fV
        case eq.t.unknownNumber:
            t = eq.t
        case eq.a.unknownNumber:
            a = eq.a
        case eq.d.unknownNumber:
            d = eq.d
        default:
            print("error- cannot set secondUnknown")
        }
    }
    
    func setFirstUnknown(_ eq: KinematicsEquations) {
        switch 1 {
        case eq.iV.unknownNumber:
            iV = eq.iV
        case eq.fV.unknownNumber:
            fV = eq.fV
        case eq.t.unknownNumber:
            t = eq.t
        case eq.a.unknownNumber:
            a = eq.a
        case eq.d.unknownNumber:
            d = eq.d
        default:
            print("error- cannot set firstUnknown")
        }
    }
    
    func findSecondUnknown() -> PhysicsVariable {
        switch 2 {
        case iV.unknownNumber:
            return iV
        case fV.unknownNumber:
            return fV
        case t.unknownNumber:
            return t
        case d.unknownNumber:
            return d
        case a.unknownNumber:
            return a
        default:
            print("error: cannot find secondUnknown")
            return d
        }
        
    }
    
    func findFirstUnknown() -> PhysicsVariable {
        switch 1 {
        case iV.unknownNumber:
            return iV
        case fV.unknownNumber:
            return fV
        case t.unknownNumber:
            return t
        case d.unknownNumber:
            return d
        case a.unknownNumber:
            return a
        default:
            print("error: cannot find firstUnknown")
        }
        return a
    }
    
    func showWorkPageView(_ pgNumber: Int) {
        // new shit
        let firstUnknown : PhysicsVariable = findFirstUnknown()
        //end of new shit
        if pgNumber == 3 {
            showWorkTextView.text = answerOneLabel.text
        } else {
            if firstUnknown.unknownEq.contains("A") {
                switch pgNumber {
                case 1:
                    showWorkTextView.text = "fV = iV + a * t" + "\n" + "\n" + "(fV = final velocity; iV=initial velocity; a=acceleration; t=time)"
                default:
                    checkVar(equation: "A", pgNumber)
                }
            } else if firstUnknown.unknownEq.contains("B") {
                if pgNumber == 1 {
                    showWorkTextView.text = "d = iV * t + 1/2 * a * t^2" + "\n" + "\n" + " (d = diplacement; iV = initial velocity; a = acceleration; t = time)"
                } else {
                    checkVar(equation: "B", pgNumber)
                }
            } else if firstUnknown.unknownEq.contains("C") {
                if pgNumber == 1 {
                    showWorkTextView.text = "fV^2 = iV^2 + 2 * a * d" + "\n" + "\n" + " (fV = final velocity; iV = initial velocity; a = acceleration; t = time)"
                } else {
                    checkVar(equation: "C", pgNumber)
                }
            } else if firstUnknown.unknownEq.contains("D") {
                if pgNumber == 1 {
                    showWorkTextView.text = "d = t * (iV + fV) / 2" + "\n" + "\n" + "(d = displacement; t = time; iV = initial velocity; fV = final velocity)"
                } else {
                    checkVar(equation: "D", pgNumber)
                }
                //eventually change the second part of the text here (the part where it says the values of the vars) to be in a separate textbox that also shows their values OR!!! OR Change it so that whenever a user hovers over the variable it displays its full name somehow
            } else {
                print("error- no unknown A equation")
            }
        }
    }
    
    //so for this function... have a button appear that after clicking it it reveals another step... maybe can include explanations for each step and the button makes the work dissapear after each step but there would be a back button.
    @IBAction func showWorkAction(_ sender: UIButton) {
        //NOTES:
        //later add feature that if u click anywhere outside the textview than it hides it.
        //reveal the order of kinematic equations used and show first and second equation. Show steps used to find answer, starting with just the equation and eventually getting the answer.
        //EDIT: dont need to make a difference between the first and second equation used. just set a global to find out what the two unknowns were (along with the equations used?), than use it to decide which equations to post and how.
        //EDIT 2: also put the letter of the equation used after the unknown value (correspondidly fix this in the switch statement) in order to know which equation was used to know which one to show for which variable. DONE
        //one day turn below into a switch statement
        if showWorkTextView.isHidden == false {
            showWorkButton.setTitle("Show Work", for: UIControlState.normal)
            showWorkTextView.isHidden = true
            showWorkNavBar.isHidden = true
            calculateNavBar.isHidden = false
            titleLabel.isHidden = false
            return
        }
        titleLabel.isHidden = true
        calculateNavBar.isHidden = true
        showWorkNavBar.isHidden = false
        showWorkTextView.isHidden = false
        showWorkButton.setTitle("Hide Work", for: UIControlState.normal)
        showWorkPageView(showWorkPg)
        
    }
    //show work ideas: maybe have it be interactive... so click buttons to proceed step by step to understand the work and reasoning.
    
    func checkVar(equation: String, _ pgNumber : Int) {
        let firstUnknown : PhysicsVariable = findFirstUnknown()
        if firstUnknown.name.contains("fV") {
            if pgNumber == 0 {
                showWorkTextView.text = "First unknown to solve for: final velocity (fV)"
            } else {
                switch equation {
                case "A":
                    switch pgNumber {
                    case 2:
                        showWorkTextView.text =  "fV = \(iV.value) + \(a.value) * \(t.value)"
                    default:
                        equationTwo(pgNumber)
                    }
                    //another line that shows plugging in 3 known values, than another line that shows what fV equals.
                    //maybe make a box that shows the 3 known values and then plug them in??
                    
                //IDEA: make it like an animation... have it writing each equation... than highlight the known values with them in the box and replace them...
                case "C":
                    if pgNumber == 2 {
                        showWorkTextView.text = "fV^2 = \(iV.value)^2 + (2 * \(a.value) * \(d.value))"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "D":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(d.value) = \(t.value) * (\(iV.value) + fV) / 2"
                    } else {
                        equationTwo(pgNumber)
                    }
                default:
                    print("Error")
                }
            }
        } else if firstUnknown.name.contains("iV") {
            if pgNumber == 0 {
                showWorkTextView.text = "First unknown to solve for: initial velocity (iV)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value) = iV + \(a.value) * \(t.value)"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "B":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(d.value) = iV * \(t.value) + 1/2 * \(a.value) * \(t.value)^2"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "C":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value)^2 = iV^2 + (2 * \(a.value) * \(d.value))"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "D":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\n" + "\(d.value) = \(t.value) * (iV + \(fV.value)) / 2"
                    } else {
                        equationTwo(pgNumber)
                    }
                default:
                    print("Error")
                }
            }
            
        } else if firstUnknown.name.contains("t") {
            if pgNumber == 0 {
                showWorkTextView.text = "First unknown to solve for: time (t)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value) = \(iV.value) + \(a.value) * t"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "B":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(d.value) = \(iV.value) * t + 1/2 * \(a.value) * t^2"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "D":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(d.value) = t * (\(iV.value) + \(fV.value)) / 2"
                    } else {
                        equationTwo(pgNumber)
                    }
                default:
                    print("Error")
                }
            }
        } else if firstUnknown.name.contains("d") {
            if pgNumber == 0 {
                showWorkTextView.text = "First unknown to solve for: displacement (d)"
            } else {
                switch equation {
                case "B":
                    if pgNumber == 2 {
                        showWorkTextView.text = "d = \(iV.value) * \(t.value) + 1/2 * \(a.value) * \(t.value)^2"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "C":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value)^2 = \(iV.value)^2 + (2 * \(a.value) * d)"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "D":
                    if pgNumber == 2 {
                        showWorkTextView.text = "d = \(t.value) * (\(iV.value) + \(fV.value)) / 2"
                    } else {
                        equationTwo(pgNumber)
                    }
                    
                default:
                    print("Error")
                }
            }
            
        } else if firstUnknown.name.contains("a") {
            if pgNumber == 0 {
                showWorkTextView.text = "First unknown to solve for: acceleration (a)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value) = \(iV.value) + a * \(t.value)"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "B":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(d.value) = \(iV.value) * \(t.value) + 1/2 * a * \(t.value)^2"
                    } else {
                        equationTwo(pgNumber)
                    }
                case "C":
                    if pgNumber == 2 {
                        showWorkTextView.text = "\(fV.value)^2 = \(iV.value)^2 + (2 * a * \(d.value))"
                    } else {
                        equationTwo(pgNumber)
                    }
                default:
                    print("Error")
                }
            }
        } else {
            print("Error- no unknown A value")
            return
        }
    }
    
    func equationTwo(_ pgNumber: Int) {
        let secondUnknown : PhysicsVariable = findSecondUnknown()
        if pgNumber == 7 {
            showWorkTextView.text = answerTwoLabel.text
        } else {
            if secondUnknown.unknownEq.contains("A") {
                switch pgNumber {
                case 5:
                    showWorkTextView.text = "fV = iV + a * t" + "\n" + "\n" + "(fV = final velocity; iV=initial velocity; a=acceleration; t=time)"
                default:
                    checkVarForB("A", pgNumber)
                }
            } else if secondUnknown.unknownEq.contains("B") {
                if pgNumber == 5 {
                    showWorkTextView.text = "d = iV * t + 1/2 * a * t^2" + "\n" + "\n" + " (d = diplacement; iV = initial velocity; a = acceleration; t = time)"
                } else {
                    checkVarForB("B", pgNumber)
                }
            } else if secondUnknown.unknownEq.contains("C") {
                if pgNumber == 5 {
                    showWorkTextView.text = "fV^2 = iV^2 + 2 * a * d" + "\n" + "\n" + "(fV = final velocity; iV = initial velocity; a = acceleration; d = displacement)"
                } else {
                    checkVarForB("C", pgNumber)
                }
            } else if secondUnknown.unknownEq.contains("D") {
                if pgNumber == 5 {
                    showWorkTextView.text = "d = t * (iV + fV) / 2" + "\n" + "\n" + "(d = displacement; t = time; iV = initial velocity; fV = final velocity)"
                } else {
                    checkVarForB("D", pgNumber)
                }
                //eventually change the second part of the text here (the part where it says the values of the vars) to be in a separate textbox that also shows their values OR!!! OR Change it so that whenever a user hovers over the variable it displays its full name somehow
            } else {
                print("error- no unknown B equation")
            }
        }
    }
    func checkVarForB(_ equation: String, _ pgNumber: Int) {
        let secondUnknown : PhysicsVariable = findSecondUnknown()
        if secondUnknown.name.contains("fV") {
            if pgNumber == 4 {
                showWorkTextView.text = "Second unknown to solve for: final velocity (fV)"
            } else {
                switch equation {
                case "A":
                    switch pgNumber {
                    case 6:
                        showWorkTextView.text =  "fV = \(iV.value) + \(a.value) * \(t.value)"
                    default:
                        return
                    }
                    //another line that shows plugging in 3 known values, than another line that shows what fV equals.
                    //maybe make a box that shows the 3 known values and then plug them in??
                    
                //IDEA: make it like an animation... have it writing each equation... than highlight the known values with them in the box and replace them...
                case "C":
                    if pgNumber == 6{
                        showWorkTextView.text = "fV^2 = \(iV.value)^2 + (2 * \(a.value) * \(d.value))"
                    } else {
                        return
                    }
                case "D":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(d.value) = \(t.value) * (\(iV.value) + fV) / 2"
                    } else {
                        return
                    }
                default:
                    print("Error")
                }
            }
        } else if secondUnknown.name.contains("iV") {
            if pgNumber == 4 {
                showWorkTextView.text = "Second unknown to solve for: initial velocity (iV)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value) = iV + \(a.value) * \(t.value)"
                    } else {
                        return
                    }
                case "B":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(d.value) = iV * \(t.value) + 1/2 * \(a.value) * \(t.value)^2"
                    } else {
                        return
                    }
                case "C":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value)^2 = iV^2 + (2 * \(a.value) * \(d.value))"
                    } else {
                        return
                    }
                case "D":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\n" + "\(d.value) = \(t.value) * (iV + \(fV.value)) / 2"
                    } else {
                        return
                    }
                default:
                    print("Error")
                }
            }
            
        } else if secondUnknown.name.contains("t") {
            if pgNumber == 4 {
                showWorkTextView.text = "Second unknown to solve for: time (t)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value) = \(iV.value) + \(a.value) * t"
                    } else {
                        return
                    }
                case "B":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(d.value) = \(iV.value) * t + 1/2 * \(a.value) * t^2"
                    } else {
                        return
                    }
                case "D":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(d.value) = t * (\(iV.value) + \(fV.value)) / 2"
                    } else {
                        return
                    }
                default:
                    print("Error")
                }
            }
        } else if secondUnknown.name.contains("d") {
            if pgNumber == 4 {
                showWorkTextView.text = "Second unknown to solve for: displacement (d)"
            } else {
                switch equation {
                case "B":
                    if pgNumber == 6 {
                        showWorkTextView.text = "d = \(iV.value) * \(t.value) + 1/2 * \(a.value) * \(t.value)^2"
                    } else {
                        return
                    }
                case "C":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value)^2 = \(iV.value)^2 + (2 * \(a.value) * d)"
                    } else {
                        return
                    }
                case "D":
                    if pgNumber == 6 {
                        showWorkTextView.text = "d = \(t.value) * (\(iV.value) + \(fV.value)) / 2"
                    } else {
                        return
                    }
                    
                default:
                    print("Error")
                }
            }
            
        } else if secondUnknown.name.contains("a") {
            if pgNumber == 4 {
                showWorkTextView.text = "Second unknown to solve for: acceleration (a)"
            } else {
                switch equation {
                case "A":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value) = \(iV.value) + a * \(t.value)"
                    } else {
                        return
                    }
                case "B":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(d.value) = \(iV.value) * \(t.value) + 1/2 * a * \(t.value)^2"
                    } else {
                        return
                    }
                case "C":
                    if pgNumber == 6 {
                        showWorkTextView.text = "\(fV.value)^2 = \(iV.value)^2 + (2 * a * \(d.value))"
                    } else {
                        return
                    }
                default:
                    print("Error")
                }
            }
        } else {
            print("Error- no unknown A value")
            return
        }
    }
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
                }else{
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            }
            else{
                if string == "-" {
                    let countNegs = textField.text!.components(separatedBy:"-").count - 1
                    if countNegs == 0 && !textField.hasText{
                        return true
                    }else{
                        if countNegs > 0 && string == "-" {
                            return false
                        } else {
                            if textField.hasText == false {
                                return true
                            } else {
                                return false
                            }
                        }
                    }
                }
                else{
                    return false
                }
            }
        }
    }
    //Another Calculation!
    @IBAction func resetButtonAction(_ sender: UIButton) {
        //Need to make a MAJOR change for V 1.1
        answerOneLabel.isHidden = true
        answerTwoLabel.isHidden = true
        showWorkTextView.isHidden = true
        showWorkTextView.text = ""
        showWorkPg = 0
        nextButton.isEnabled = true
        previousButton.isEnabled = false
        nextCalculatorBtn.isEnabled = true
        prevCalculatorBtn.isEnabled = false
        nextCalculatorBtn.title = "Next"
        varNamePickerView.isHidden = false
        countingLabel.isHidden = false
        anotherCalculationBtn.isHidden = true
        unitConverterBtn.isHidden = true
        practiceProblemsBtn.isHidden = true
        showWorkButton.isHidden = true
        countingLabel.text = "Enter 1st Value:"
        iV.totalReset()
        fV.totalReset()
        t.totalReset()
        d.totalReset()
        a.totalReset()
        inputValueTextField.isHidden = false
    }
    
    
    func answerLabels() {
        let firstUnknown : PhysicsVariable = findFirstUnknown()
        let secondUnknown : PhysicsVariable = findSecondUnknown()
        switch true {
        case firstUnknown.name.contains("t"):
            answerOneLabel.text = "Time: \(t.value) seconds"
        case firstUnknown.name.contains("d"):
            answerOneLabel.text = "Displacement: \(d.value) meters"
        case firstUnknown.name.contains("fV"):
            answerOneLabel.text = "Final Velocity: \(fV.value) meters/sec"
        case firstUnknown.name.contains("iV"):
            answerOneLabel.text = "Initial Velocity: \(iV.value) meters/sec"
        case firstUnknown.name.contains("a"):
            answerOneLabel.text = "Acceleration: \(a.value) meters/sec^2"
        default:
            print("error-a1")
        }
        switch true {
        case secondUnknown.name.contains("t"):
            answerTwoLabel.text = "Time: \(t.value) seconds"
        case secondUnknown.name.contains("d"):
            answerTwoLabel.text = "Displacement: \(d.value) meters"
        case secondUnknown.name.contains("fV"):
            answerTwoLabel.text = "Final Velocity: \(fV.value) meters/sec"
        case secondUnknown.name.contains("iV"):
            answerTwoLabel.text = "Initial Velocity: \(iV.value) meters/sec"
        case secondUnknown.name.contains("a"):
            answerTwoLabel.text = "Acceleration: \(a.value) meters/sec^2"
        default:
            print("error-a2")
        }
        answerOneLabel.isHidden = false
        answerTwoLabel.isHidden = false
    }
    
    func chooseKinematicsEquationRandom(_ a: PhysicsVariable, _ b: PhysicsVariable, _ c: PhysicsVariable, _ u : String) -> PhysicsVariable {
        let aa = setUpVar(a)
        let bb = setUpVar(b)
        let cc = setUpVar(c)
        let listOfVars : [PhysicsVariable] = [aa, bb, cc]
        let calculate = KinematicsEquations.init(listOfVars, u)
        calculate.doKinemtaicsEquation()
        //below setFirst and setSecond unknown: don't need to call both, in future improve this pls...
        setFirstUnknown(calculate)
        setSecondUnknown(calculate)
        let unknown : PhysicsVariable = checkU(u)
        return unknown
    }
    func checkU(_ unknown: String) -> PhysicsVariable {
        switch unknown {
        case "fV":
            return fV
        case "iV":
            return iV
        case "t":
            return t
        case "d":
            return d
        case "a":
            return a
        default:
            print("error- cannot find U")
            return a
        }
    }
    
    func setUpVar(_ pVar: PhysicsVariable) -> PhysicsVariable {
        switch pVar.name {
        case "fV":
            fV = pVar
            return fV
        case "iV":
            iV = pVar
            return iV
        case "t":
            t = pVar
            return t
        case "a":
            a = pVar
            return a
        case "d":
            d = pVar
            return d
        default:
            print("error- cannot set up var")
            return a
        }
    }
    
    func checkRandomTime() -> Bool {
        if t.value <= 0 {
            return false
        } else {
            return true
        }
    }
    
    func checkTime() {
        if t.value < 0 {
            let alert = UIAlertController(title: "Error!", message: "Time is negative: solution is impossible!", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            if answerOneLabel.text?.contains("Time") == true{
                answerOneLabel.text = "Time: Error"
            } else {
                answerTwoLabel.text = "Time : Error"
            }
            print("Error- Time Negative")
            return
        } else {
            return
        }
    }

    //need to implement functionality for random equations here or practiceproblem
    
    /*func checkEquation(_ equation: String) -> Bool {
        if unknown.contains(equation) {
            print("false")
            return false
        } else {
            return true
        }
    }*/

}
