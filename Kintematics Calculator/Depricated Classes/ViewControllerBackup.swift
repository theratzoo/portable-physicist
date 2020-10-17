// ONLY USE  IF SHIT GETS BAD
//  ViewControllerBackup.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/1/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//



 
 
 
 
 
 //
 //  ViewController.swift
 //  Kintematics Calculator
 //
 //  Created by Luke Deratzou on 1/22/18.
 //  Copyright © 2018 Luke Deratzou. All rights reserved.
 
 // Upon clicking enter button, it will take in the data. Check which two are empty, and then use a switch? statement to determine which equation to use. Set label input as variables (make sure to make them doubles and also use guard let or if let to avoid nil. Then when answers are gained set them equal to the text of the label (INCLUDING OG INPUT).
 //Switch statement can determine which equation to use (each equation can be a separate function).
 
 //Have a helper function determine which values are nil and which are not nil... then have it return the values so that my other functions can use the information to make the app run smoother.
 
 
 
 //Things to do after main app is finished:
 //Bugs:
 //Deal with entering nothing DONE
 //Deal with entering in letters DONE
 //Round answers (either to a few dec places (DONE) or to highest # of sig figs (latter pref)
 //QOL improvements: make stuff easier, less code, more efficient, etc.
 //Additional features:
 //Unit converter- separate page?? almost DONE
 //X vs. Y (angles???)
 //place to save your values (name them, then view them whenever you want to)
 //reset button! DONE
 //The 5 labels on the right are depricated... eventually put 5 labels on left that specify what the input texts are. Then delete those 5 labels! DONE
 //Eventually make it known error whenever time is negative.. like have a popup that says "ERROR: TIME CANNOT BE NEGATIVE": make it be an alert. Check if t is less than 0 after the button is pushed and after the equations are used than if it is have that popup appear. DONE
 //random practice problems
 //transform each kinematic variable into its own class (or make each one an instance of a class)- the class's properties will include the variable's name, the variable's value, whether it is an unknown or not (is the textField nil/ is it equal to 5.39), and if its unknown A or B.
 /*
 import UIKit
 
 class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
 
 @IBOutlet weak var answerOneLabel: UILabel!
 @IBOutlet weak var answerTwoLabel: UILabel!
 
 
 //below are for the show work feature:
 @IBOutlet weak var showWorkTextView: UITextView!
 @IBOutlet weak var showWorkButton: UIButton!
 @IBOutlet weak var showWorkNavBar: UINavigationBar!
 @IBOutlet weak var previousButton: UIBarButtonItem!
 @IBOutlet weak var nextButton: UIBarButtonItem!
 
 //V 1.1 New Outlets below:
 
 @IBOutlet weak var varNamePickerView: UIPickerView!
 @IBOutlet weak var countingLabel: UILabel!
 @IBOutlet weak var inputValueTextField: UITextField! //<-- might need action as well for after user stops typing
 @IBOutlet weak var nextCalculatorBtn: UIBarButtonItem!
 @IBOutlet weak var prevCalculatorBtn: UIBarButtonItem!
 
 var varNamePickerData : [String] = [String]()
 var varNameChosen : String = ""
 
 //eventually get rid of these for good (below):
 
 struct GlobalVariable{
 static var a : Double = 0
 static var iV : Double = 0
 static var fV : Double = 0
 static var t : Double = 0
 static var d : Double = 0
 }
 //testing out kinematicsvariable class... a big WIP (can work on it for a weekend... need to save backup before doing this)
 var a:KinematicsVariable = KinematicsVariable.init(name: "a")
 var iV:KinematicsVariable = KinematicsVariable.init(name: "iV")
 var fV:KinematicsVariable = KinematicsVariable.init(name: "fV")
 var d:KinematicsVariable = KinematicsVariable.init(name: "d")
 var t:KinematicsVariable = KinematicsVariable.init(name: "t")
 
 var isEmptyOrNotNumber : Bool = false
 /*    var firstEquation : String?
 var secondEquation : String?
 */
 var unknownA : String = "NA"
 var unknownB : String = "NA"
 var unknown : String = ""
 var showWorkPg : Int = 0
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 answerOneLabel.isHidden = true
 answerTwoLabel.isHidden = true
 showWorkTextView.isHidden = true
 showWorkNavBar.isHidden = true
 self.hideKeyboardWhenTappedAround()
 var count : Int = 0
 var x : String = UnitConverterViewController.GlobalVariable.myString
 //Below needs to be fixed due to V1.1
 /*
 Idea for improvment:
 -In the unit convert view controller, know how many are being converted.
 -Then, based on number of units being converted, eliminate that many "steps"
 Example: if 2 are being converted, put user in page 3 with the 2 converted ones set up already as values.
 */
 if x.contains("a") {
 x.remove(at: x.startIndex)
 a.setValue = Double(x)!
 } else if x.contains("d") {
 x.remove(at: x.startIndex)
 d.setValue = Double(x)!
 } else if x.contains("i") {
 x.remove(at: x.startIndex)
 iV.setValue = Double(x)!
 } else if x.contains("f") {
 x.remove(at: x.startIndex)
 fV.setValue = Double(x)!
 } else if x.contains("t") {
 x.remove(at: x.startIndex)
 t.setValue = Double(x)!
 } else {
 print("x- empty")
 count -= 1
 }
 count += 1
 var y : String = UnitConverterViewController.GlobalVariable.secondConversion
 if y.contains("a") {
 y.remove(at: y.startIndex)
 a.setValue = Double(y)!
 } else if y.contains("d") {
 y.remove(at: y.startIndex)
 d.setValue = Double(y)!
 } else if y.contains("i") {
 y.remove(at: y.startIndex)
 iV.setValue = Double(y)!
 } else if y.contains("f") {
 y.remove(at: y.startIndex)
 fV.setValue = Double(y)!
 } else if y.contains("t") {
 y.remove(at: y.startIndex)
 t.setValue = Double(y)!
 } else {
 print("y- empty")
 count -= 1
 }
 count += 1
 
 //Below: V 1.1
 
 self.varNamePickerView.delegate = self
 self.varNamePickerView.dataSource = self
 inputValueTextField.delegate = self
 varNamePickerData = ["Initial Velocity", "Final Velocity", "Time", "Displacement", "Acceleration"]
 // Do any additional setup after loading the view, typically from a nib.
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 //this is also 1.1 but w/e
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 self.view.endEditing(true)
 return false
 }
 
 //**Start of V 1.1 Code**
 
 func loadPrevPage(_ pgNumber: Int) {
 switch pgNumber {
 case fV.varNumb:
 inputValueTextField.text = String(fV.getValue)
 case iV.varNumb:
 inputValueTextField.text = String(iV.getValue)
 case t.varNumb:
 inputValueTextField.text = String(t.getValue)
 case d.varNumb:
 inputValueTextField.text = String(d.getValue)
 case a.varNumb:
 inputValueTextField.text = String(a.getValue)
 default:
 inputValueTextField.text?.removeAll()
 }
 }
 
 func setUpPage(_ pgNumber: Int) {
 //WIP
 switch pgNumber {
 case 1:
 countingLabel.text = "1st Value"
 prevCalculatorBtn.isEnabled = false
 case 2:
 countingLabel.text = "2nd Value"
 prevCalculatorBtn.isEnabled = true
 nextCalculatorBtn.title = "Next"
 case 3:
 countingLabel.text = "3rd Value"
 nextCalculatorBtn.title = "Calculate"
 nextCalculatorBtn.isEnabled = true
 case 4:
 countingLabel.isHidden = true
 nextCalculatorBtn.isEnabled = false
 var kinematicsVarArray: [KinematicsVariable] = [KinematicsVariable]()
 //WIP
 if iV.setVarNumb == -1 {
 iV.itIsUnknown()
 } else {
 kinematicsVarArray.append(iV)
 }
 if fV.setVarNumb == -1 {
 fV.itIsUnknown()
 } else {
 kinematicsVarArray.append(fV)
 }
 if t.setVarNumb == -1 {
 t.itIsUnknown()
 } else {
 kinematicsVarArray.append(t)
 }
 if a.setVarNumb == -1 {
 t.itIsUnknown()
 } else {
 kinematicsVarArray.append(a)
 }
 if d.setVarNumb == -1 {
 d.itIsUnknown()
 } else {
 kinematicsVarArray.append(d)
 }
 let calculate:KinematicsEquations = KinematicsEquations.init(kinematicsVarArray)
 calculate.doKinemtaicsEquation()
 default:
 print("berp")
 }
 loadPrevPage(pgNumber)
 
 }
 //for prev button: can have a label that shows the unit and value of the past one...
 @IBAction func prevBtnAction(_ sender: UIBarButtonItem) { //will suck to implement this :(
 var pgNumber = 0
 if(countingLabel.text?.contains("1"))! {
 pgNumber = 1
 prevCalculatorBtn.isEnabled = false
 } else if(countingLabel.text?.contains("2"))! {
 pgNumber = 2
 } else {
 pgNumber = 3
 }
 pgNumber -= 1
 setUpPage(pgNumber)
 }
 @IBAction func nextButtonAction(_ sender: UIBarButtonItem) {
 if (inputValueTextField.text?.isEmpty)! {
 alertAction(type: "blank")
 return
 }
 var pgNumber = 0
 if(countingLabel.text?.contains("1"))! { // bad check, think of better one later
 pgNumber = 1
 } else if(countingLabel.text?.contains("2"))! {
 pgNumber = 2
 } else {
 pgNumber = 3
 }
 switch varNameChosen {
 case "Initial Velocity":
 iV.setValue = Double(inputValueTextField.text!)!
 iV.setVarNumb = pgNumber
 case "Final Velocity":
 fV.setValue = Double(inputValueTextField.text!)!
 fV.setVarNumb = pgNumber
 case "Time":
 t.setValue = Double(inputValueTextField.text!)!
 t.setVarNumb = pgNumber
 case "Displacement":
 d.setValue = Double(inputValueTextField.text!)!
 d.setVarNumb = pgNumber
 case "Acceleration":
 a.setValue = Double(inputValueTextField.text!)!
 a.setVarNumb = pgNumber
 default:
 print("error")
 }
 pgNumber += 1
 setUpPage(pgNumber)
 
 }
 
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
 return 1
 }
 
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 return varNamePickerData.count
 }
 
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 return varNamePickerData[row]
 }
 
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 varNameChosen = varNamePickerData[row] as String
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
 default:
 print("error")
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
 
 func findSecondUnknown() -> KinematicsVariable {
 switch 2 {
 case iV.unknown.getSetUNumb:
 return iV
 case fV.unknown.getSetUNumb:
 return fV
 case t.unknown.getSetUNumb:
 return t
 case d.unknown.getSetUNumb:
 return d
 case a.unknown.getSetUNumb:
 return a
 default:
 return a
 }
 
 }
 
 func findFirstUnknown() -> KinematicsVariable {
 switch 1 {
 case iV.unknown.getSetUNumb:
 return iV
 case fV.unknown.getSetUNumb:
 return fV
 case t.unknown.getSetUNumb:
 return t
 case d.unknown.getSetUNumb:
 return d
 case a.unknown.getSetUNumb:
 return a
 default:
 print("error")
 }
 return a
 }
 
 func showWorkPageView(_ pgNumber: Int) {
 // new shit
 let firstUnknown : KinematicsVariable = findFirstUnknown()
 //end of new shit
 if pgNumber == 3 {
 showWorkTextView.text = answerOneLabel.text
 } else {
 if firstUnknown.unknown.getSetUEquation.contains("A") {
 switch pgNumber {
 case 1:
 showWorkTextView.text = "fV = iV + a * t" + "\n" + "\n" + "(fV = final velocity; iV=initial velocity; a=acceleration; t=time)"
 default:
 checkVar(equation: "A", pgNumber)
 }
 } else if unknownA.contains("B") {
 if pgNumber == 1 {
 showWorkTextView.text = "d = iV * t + 1/2 * a * t^2" + "\n" + "\n" + " (d = diplacement; iV = initial velocity; a = acceleration; t = time)"
 } else {
 checkVar(equation: "B", pgNumber)
 }
 } else if unknownA.contains("C") {
 if pgNumber == 1 {
 showWorkTextView.text = "fV^2 = iV^2 + 2 * a * d" + "\n" + "\n" + " (fV = final velocity; iV = initial velocity; a = acceleration; t = time)"
 } else {
 checkVar(equation: "C", pgNumber)
 }
 } else if unknownA.contains("D") {
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
 return
 }
 showWorkNavBar.isHidden = false
 showWorkTextView.isHidden = false
 showWorkButton.setTitle("Hide Work", for: UIControlState.normal)
 showWorkPageView(showWorkPg)
 
 }
 //show work ideas: maybe have it be interactive... so click buttons to proceed step by step to understand the work and reasoning.
 
 func checkVar(equation: String, _ pgNumber : Int) {
 if unknownA.contains("fV") {
 if pgNumber == 0 {
 showWorkTextView.text = "First unknown to solve for: final velocity (fV)"
 } else {
 switch equation {
 case "A":
 switch pgNumber {
 case 2:
 showWorkTextView.text =  "fV = \(GlobalVariable.iV) + \(GlobalVariable.a) * \(GlobalVariable.t)"
 default:
 equationTwo(pgNumber)
 }
 //another line that shows plugging in 3 known values, than another line that shows what fV equals.
 //maybe make a box that shows the 3 known values and then plug them in??
 
 //IDEA: make it like an animation... have it writing each equation... than highlight the known values with them in the box and replace them...
 case "C":
 if pgNumber == 2 {
 showWorkTextView.text = "fV^2 = \(GlobalVariable.iV)^2 + (2 * \(GlobalVariable.a) * \(GlobalVariable.d))"
 } else {
 equationTwo(pgNumber)
 }
 case "D":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.t) * (\(GlobalVariable.iV) + fV) / 2"
 } else {
 equationTwo(pgNumber)
 }
 default:
 print("Error")
 }
 }
 } else if unknownA.contains("iV") {
 if pgNumber == 0 {
 showWorkTextView.text = "First unknown to solve for: initial velocity (iV)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV) = iV + \(GlobalVariable.a) * \(GlobalVariable.t)"
 } else {
 equationTwo(pgNumber)
 }
 case "B":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.d) = iV * \(GlobalVariable.t) + 1/2 * \(GlobalVariable.a) * \(GlobalVariable.t)^2"
 } else {
 equationTwo(pgNumber)
 }
 case "C":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = iV^2 + (2 * \(GlobalVariable.a) * \(GlobalVariable.d))"
 } else {
 equationTwo(pgNumber)
 }
 case "D":
 if pgNumber == 2 {
 showWorkTextView.text = "\n" + "\(GlobalVariable.d) = \(GlobalVariable.t) * (iV + \(GlobalVariable.fV)) / 2"
 } else {
 equationTwo(pgNumber)
 }
 default:
 print("Error")
 }
 }
 
 } else if unknownA.contains("t") {
 if pgNumber == 0 {
 showWorkTextView.text = "First unknown to solve for: time (t)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV) = \(GlobalVariable.iV) + \(GlobalVariable.a) * t"
 } else {
 equationTwo(pgNumber)
 }
 case "B":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.iV) * t + 1/2 * \(GlobalVariable.a) * t^2"
 } else {
 equationTwo(pgNumber)
 }
 case "D":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.d) = t * (\(GlobalVariable.iV) + \(GlobalVariable.fV)) / 2"
 } else {
 equationTwo(pgNumber)
 }
 default:
 print("Error")
 }
 }
 } else if unknownA.contains("d") {
 if pgNumber == 0 {
 showWorkTextView.text = "First unknown to solve for: displacement (d)"
 } else {
 switch equation {
 case "B":
 if pgNumber == 2 {
 showWorkTextView.text = "d = \(GlobalVariable.iV) * \(GlobalVariable.t) + 1/2 * \(GlobalVariable.a) * \(GlobalVariable.t)^2"
 } else {
 equationTwo(pgNumber)
 }
 case "C":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = \(GlobalVariable.iV)^2 + (2 * \(GlobalVariable.a) * d)"
 } else {
 equationTwo(pgNumber)
 }
 case "D":
 if pgNumber == 2 {
 showWorkTextView.text = "d = \(GlobalVariable.t) * (\(GlobalVariable.iV) + \(GlobalVariable.fV)) / 2"
 } else {
 equationTwo(pgNumber)
 }
 
 default:
 print("Error")
 }
 }
 
 } else if unknownA.contains("a") {
 if pgNumber == 0 {
 showWorkTextView.text = "First unknown to solve for: acceleration (a)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV) = \(GlobalVariable.iV) + a * \(GlobalVariable.t)"
 } else {
 equationTwo(pgNumber)
 }
 case "B":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.iV) * \(GlobalVariable.t) + 1/2 * a * \(GlobalVariable.t)^2"
 } else {
 equationTwo(pgNumber)
 }
 case "C":
 if pgNumber == 2 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = \(GlobalVariable.iV)^2 + (2 * a * \(GlobalVariable.d))"
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
 if pgNumber == 7 {
 showWorkTextView.text = answerTwoLabel.text
 } else {
 if unknownB.contains("A") {
 switch pgNumber {
 case 5:
 showWorkTextView.text = "fV = iV + a * t" + "\n" + "\n" + "(fV = final velocity; iV=initial velocity; a=acceleration; t=time)"
 default:
 checkVarForB("A", pgNumber)
 }
 } else if unknownB.contains("B") {
 if pgNumber == 5 {
 showWorkTextView.text = "d = iV * t + 1/2 * a * t^2" + "\n" + "\n" + " (d = diplacement; iV = initial velocity; a = acceleration; t = time)"
 } else {
 checkVarForB("B", pgNumber)
 }
 } else if unknownB.contains("C") {
 if pgNumber == 5 {
 showWorkTextView.text = "fV^2 = iV^2 + 2 * a * d" + "\n" + "\n" + "(fV = final velocity; iV = initial velocity; a = acceleration; d = displacement)"
 } else {
 checkVarForB("C", pgNumber)
 }
 } else if unknownB.contains("D") {
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
 if unknownB.contains("fV") {
 if pgNumber == 4 {
 showWorkTextView.text = "Second unknown to solve for: final velocity (fV)"
 } else {
 switch equation {
 case "A":
 switch pgNumber {
 case 6:
 showWorkTextView.text =  "fV = \(GlobalVariable.iV) + \(GlobalVariable.a) * \(GlobalVariable.t)"
 default:
 return
 }
 //another line that shows plugging in 3 known values, than another line that shows what fV equals.
 //maybe make a box that shows the 3 known values and then plug them in??
 
 //IDEA: make it like an animation... have it writing each equation... than highlight the known values with them in the box and replace them...
 case "C":
 if pgNumber == 6{
 showWorkTextView.text = "fV^2 = \(GlobalVariable.iV)^2 + (2 * \(GlobalVariable.a) * \(GlobalVariable.d))"
 } else {
 return
 }
 case "D":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.t) * (\(GlobalVariable.iV) + fV) / 2"
 } else {
 return
 }
 default:
 print("Error")
 }
 }
 } else if unknownB.contains("iV") {
 if pgNumber == 4 {
 showWorkTextView.text = "Second unknown to solve for: initial velocity (iV)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV) = iV + \(GlobalVariable.a) * \(GlobalVariable.t)"
 } else {
 return
 }
 case "B":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.d) = iV * \(GlobalVariable.t) + 1/2 * \(GlobalVariable.a) * \(GlobalVariable.t)^2"
 } else {
 return
 }
 case "C":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = iV^2 + (2 * \(GlobalVariable.a) * \(GlobalVariable.d))"
 } else {
 return
 }
 case "D":
 if pgNumber == 6 {
 showWorkTextView.text = "\n" + "\(GlobalVariable.d) = \(GlobalVariable.t) * (iV + \(GlobalVariable.fV)) / 2"
 } else {
 return
 }
 default:
 print("Error")
 }
 }
 
 } else if unknownB.contains("t") {
 if pgNumber == 4 {
 showWorkTextView.text = "Second unknown to solve for: time (t)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV) = \(GlobalVariable.iV) + \(GlobalVariable.a) * t"
 } else {
 return
 }
 case "B":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.iV) * t + 1/2 * \(GlobalVariable.a) * t^2"
 } else {
 return
 }
 case "D":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.d) = t * (\(GlobalVariable.iV) + \(GlobalVariable.fV)) / 2"
 } else {
 return
 }
 default:
 print("Error")
 }
 }
 } else if unknownB.contains("d") {
 if pgNumber == 4 {
 showWorkTextView.text = "Second unknown to solve for: displacement (d)"
 } else {
 switch equation {
 case "B":
 if pgNumber == 6 {
 showWorkTextView.text = "d = \(GlobalVariable.iV) * \(GlobalVariable.t) + 1/2 * \(GlobalVariable.a) * \(GlobalVariable.t)^2"
 } else {
 return
 }
 case "C":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = \(GlobalVariable.iV)^2 + (2 * \(GlobalVariable.a) * d)"
 } else {
 return
 }
 case "D":
 if pgNumber == 6 {
 showWorkTextView.text = "d = \(GlobalVariable.t) * (\(GlobalVariable.iV) + \(GlobalVariable.fV)) / 2"
 } else {
 return
 }
 
 default:
 print("Error")
 }
 }
 
 } else if unknownB.contains("a") {
 if pgNumber == 4 {
 showWorkTextView.text = "Second unknown to solve for: acceleration (a)"
 } else {
 switch equation {
 case "A":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV) = \(GlobalVariable.iV) + a * \(GlobalVariable.t)"
 } else {
 return
 }
 case "B":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.d) = \(GlobalVariable.iV) * \(GlobalVariable.t) + 1/2 * a * \(GlobalVariable.t)^2"
 } else {
 return
 }
 case "C":
 if pgNumber == 6 {
 showWorkTextView.text = "\(GlobalVariable.fV)^2 = \(GlobalVariable.iV)^2 + (2 * a * \(GlobalVariable.d))"
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
 
 @IBAction func resetButtonAction(_ sender: UIButton) {
 //Need to make a MAJOR change for V 1.1
 answerOneLabel.isHidden = true
 answerTwoLabel.isHidden = true
 showWorkTextView.isHidden = true
 showWorkTextView.text = ""
 unknown = ""
 unknownA = "NA"
 unknownB = "NA"
 showWorkPg = 0
 nextButton.isEnabled = true
 previousButton.isEnabled = false
 }
 
 
 func answerLabels() {
 switch true {
 case unknownA.contains("t"):
 answerOneLabel.text = "Time: " + String(GlobalVariable.t) + " seconds"
 case unknownA.contains("d"):
 answerOneLabel.text = "Displacement: " + String(GlobalVariable.d) + " meters"
 case unknownA.contains("fV"):
 answerOneLabel.text = "Final Velocity: " + String(GlobalVariable.fV) + " meters/sec"
 case unknownA.contains("iV"):
 answerOneLabel.text = "Initial Velocity: " + String(GlobalVariable.iV) + " meters/sec"
 case unknownA.contains("a"):
 answerOneLabel.text = "Acceleration: " + String(GlobalVariable.a) + " meters/sec^2"
 default:
 print("error-a1")
 }
 switch true {
 case unknownB.contains("t"):
 answerTwoLabel.text = "Time: " + String(GlobalVariable.t) + " seconds"
 case unknownB.contains("d"):
 answerTwoLabel.text = "Displacement: " + String(GlobalVariable.d) + " meters"
 case unknownB.contains("fV"):
 answerTwoLabel.text = "Final Velocity: " + String(GlobalVariable.fV) + " meters/sec"
 case unknownB.contains("iV"):
 answerTwoLabel.text = "Initial Velocity: " + String(GlobalVariable.iV) + " meters/sec"
 case unknownB.contains("a"):
 answerTwoLabel.text = "Acceleration: " + String(GlobalVariable.a) + " meters/sec^2"
 default:
 print("error-a2")
 }
 answerOneLabel.isHidden = false
 answerTwoLabel.isHidden = false
 }
 
 func checkRandomTime() -> Bool {
 if GlobalVariable.t <= 0 {
 return false
 } else {
 return true
 }
 }
 
 func checkTime() {
 if GlobalVariable.t < 0 {
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
 func checkUnknown() {
 if unknownA.contains("NA") {
 unknownA = unknown
 } else if unknownB.contains("NA") {
 unknownB = unknown
 } else {
 return
 }
 }
 
 //this func is very tenative and will probably be deleted later
 func chooseKinematicsEquationRandom() {
 print(String(GlobalVariable.iV))
 //FUTURE IMPLEMENTATION MAYBE: have parameters be two strings for each unknown (or an array), than have a switch statement check which two unknowns there are and then do equations based on those. Also set the textfield values equal to actual text, and unknown variables equal to 0 (only if necessary).
 
 
 /* if GlobalVariable.fV != 5.39 {
 finalVTxtField.text = String(GlobalVariable.fV)
 }
 if GlobalVariable.iV != 5.39 {
 let m = String(GlobalVariable.iV)
 initialVTxtField.text = "Hi I am a test!"
 }
 if GlobalVariable.t != 5.39 {
 timeTxtField.text = String(GlobalVariable.t)
 }
 if GlobalVariable.a != 5.39 {
 accelerationTxtField.text = String(GlobalVariable.a)
 
 }
 if GlobalVariable.d != 5.39 {
 displacementTxtField.text = String(GlobalVariable.d)
 
 }
 */
 if GlobalVariable.fV == 5.39 {
 
 randomKinematicsEquationC()
 randomKinematicsEquationA()
 randomKinematicsEquationD()
 randomKinematicsEquationB()
 randomKinematicsEquationC()
 randomKinematicsEquationA()
 randomKinematicsEquationD()
 
 return
 } else if GlobalVariable.t == 5.39 {
 randomKinematicsEquationC()
 randomKinematicsEquationA()
 randomKinematicsEquationB()
 return
 } else if GlobalVariable.d == 5.39 {
 randomKinematicsEquationA()
 randomKinematicsEquationB()
 randomKinematicsEquationC()
 return
 } else if GlobalVariable.iV == 5.39 && GlobalVariable.a == 5.39 {
 randomKinematicsEquationD()
 randomKinematicsEquationC()
 randomKinematicsEquationA()
 randomKinematicsEquationB()
 return
 } else {
 print("k")
 }
 }
 
 
 func checkEquation(_ equation: String) -> Bool {
 if unknown.contains(equation) {
 print("false")
 return false
 } else {
 return true
 }
 }
 
 func randomKinematicsEquationA() {
 print("A")
 //later maybe add a for loop to find out which one is nil
 unknown = ""
 if GlobalVariable.fV == 5.39 {
 if checkEquation("A") == false {
 return
 } else {
 unknown = "fV A"
 }
 }
 if GlobalVariable.iV == 5.39 {
 if checkEquation("A") == false {
 return
 } else {
 unknown = "iV A"
 }
 }
 if GlobalVariable.a == 5.39 {
 if checkEquation("A") == false {
 return
 } else {
 unknown = "a A"
 }
 }
 if GlobalVariable.t == 5.39 {
 if checkEquation("A") == false {
 return
 } else {
 unknown = "t A"
 }
 }
 if !unknown.contains("A") {
 print("error - A is blank")
 return
 }
 
 switch unknown {
 case "fV A":
 GlobalVariable.fV = GlobalVariable.iV + GlobalVariable.a * GlobalVariable.t
 GlobalVariable.fV = round(100 * GlobalVariable.fV) / 100
 print(GlobalVariable.fV)
 checkUnknown()
 return
 case "iV A":
 GlobalVariable.iV = GlobalVariable.fV - (GlobalVariable.a * GlobalVariable.t)
 GlobalVariable.iV = round(100 * GlobalVariable.iV) / 100
 print(GlobalVariable.iV)
 checkUnknown()
 return
 case "a A":
 GlobalVariable.a = (GlobalVariable.fV - GlobalVariable.iV) / GlobalVariable.t
 GlobalVariable.a = round(100 * GlobalVariable.a) / 100
 print(GlobalVariable.a)
 checkUnknown()
 return
 case "t A":
 GlobalVariable.t = (GlobalVariable.fV - GlobalVariable.iV) / GlobalVariable.a
 GlobalVariable.t = round(100 * GlobalVariable.t) / 100
 print(GlobalVariable.t)
 checkUnknown()
 return
 default:
 print("bug")
 }
 //vf = vi + at
 }
 //put switch into this, put the three known values as parameters, and eventually ill know what im doing//func solveEquationA() { }
 
 func randomKinematicsEquationB() {
 print("B")
 // if i can never find out how to set up equation to equal t, than code it so it never has t as the unknown
 unknown = ""
 if GlobalVariable.d == 5.39 {
 if checkEquation("B") == false {
 return
 } else {
 unknown = "d B"
 }
 }
 if GlobalVariable.iV == 5.39 {
 if checkEquation("B") == false {
 return
 } else {
 unknown = "iV B"
 }
 }
 if GlobalVariable.a == 5.39 {
 if checkEquation("B") == false {
 return
 } else {
 unknown = "a B"
 }
 }
 if GlobalVariable.t == 5.39 {
 if checkEquation("B") == false {
 return
 } else {
 unknown = "t B"
 }
 }
 if !unknown.contains("B") {
 print("error - B is blank")
 return
 }
 switch unknown {
 case "d B":
 GlobalVariable.d = GlobalVariable.iV * GlobalVariable.t + 0.5 * GlobalVariable.a * (GlobalVariable.t * GlobalVariable.t)
 GlobalVariable.d = round(100 * GlobalVariable.d) / 100
 print(GlobalVariable.d)
 checkUnknown()
 return
 case "iV B":
 GlobalVariable.iV = (GlobalVariable.d - (0.5 * GlobalVariable.a * (GlobalVariable.t * GlobalVariable.t))) / GlobalVariable.t
 GlobalVariable.iV = round(100 * GlobalVariable.iV) / 100
 checkUnknown()
 return
 case "a B":
 GlobalVariable.a = 2 * (GlobalVariable.d - (GlobalVariable.iV * GlobalVariable.t)) / (GlobalVariable.t * GlobalVariable.t)
 GlobalVariable.a = round(100 * GlobalVariable.a) / 100
 checkUnknown()
 return
 case "t B":
 // find out how to set up t right HINT HINT QUADRATIC EQUATION
 //GlobalVariable.t = round(100 * GlobalVariable.t) / 100
 print("Error- time B")
 //timeTxtField.text = String(t)
 //checkUnknown()
 return
 default:
 print("bug")
 }
 //d = vit + .5at^2
 }
 
 func randomKinematicsEquationC() {
 print("C")
 unknown = ""
 if GlobalVariable.d == 5.39 {
 unknown = "d C"
 }
 if GlobalVariable.iV == 5.39 {
 if checkEquation("C") == false {
 return
 } else {
 unknown = "iV C"
 }
 }
 if GlobalVariable.a == 5.39 {
 if checkEquation("C") == false {
 return
 } else {
 unknown = "a C"
 }
 unknown = "a C"
 }
 if GlobalVariable.fV == 5.39 {
 if checkEquation("C") == false {
 return
 } else {
 unknown = "fV C"
 }
 }
 if !unknown.contains("C") {
 print("error - C is blank")
 return
 }
 switch unknown {
 case "d C":
 GlobalVariable.d = (0.5 * ((GlobalVariable.fV * GlobalVariable.fV) - (GlobalVariable.iV * GlobalVariable.iV))) / GlobalVariable.a
 GlobalVariable.d = round(100 * GlobalVariable.d) / 100
 checkUnknown()
 return
 case "iV C":
 GlobalVariable.iV = sqrt(GlobalVariable.fV * GlobalVariable.fV - 2.0 * GlobalVariable.a * GlobalVariable.d)
 GlobalVariable.iV = round(100 * GlobalVariable.iV) / 100
 checkUnknown()
 return
 case "a C":
 GlobalVariable.a = (0.5 * ((GlobalVariable.fV * GlobalVariable.fV) - (GlobalVariable.iV * GlobalVariable.iV))) / GlobalVariable.d
 GlobalVariable.a = round(100 * GlobalVariable.a) / 100
 checkUnknown()
 return
 case "fV C":
 GlobalVariable.fV = sqrt(GlobalVariable.iV * GlobalVariable.iV + 2.0 * GlobalVariable.a * GlobalVariable.d)
 GlobalVariable.fV = round(100 * GlobalVariable.fV) / 100
 checkUnknown()
 return
 default:
 print("bug")
 }
 //vf^2 = vi^2 + 2ad
 }
 func randomKinematicsEquationD() {
 print("D")
 unknown = ""
 if GlobalVariable.d == 5.39 {
 if checkEquation("D") == false {
 return
 } else {
 unknown = "d D"
 }
 }
 if GlobalVariable.iV == 5.39 {
 if checkEquation("D") == false {
 return
 } else {
 unknown = "iV D"
 }
 }
 if GlobalVariable.t == 5.39 {
 if checkEquation("D") == false {
 return
 } else {
 unknown = "t D"
 }
 }
 if GlobalVariable.fV == 5.39 {
 if checkEquation("D") == false {
 return
 } else {
 unknown = "fV D"
 }
 }
 if !unknown.contains("D") {
 print("error - D is blank")
 return
 }
 switch unknown {
 case "d D":
 GlobalVariable.d = (GlobalVariable.t * (GlobalVariable.iV + GlobalVariable.fV)) / 2.0
 GlobalVariable.d = round(100 * GlobalVariable.d) / 100
 checkUnknown()
 return
 case "iV D":
 GlobalVariable.iV = ((2.0 * GlobalVariable.d ) / GlobalVariable.t ) - GlobalVariable.fV
 GlobalVariable.iV = round(100 * GlobalVariable.iV) / 100
 checkUnknown()
 return
 case "t D":
 GlobalVariable.t = (2.0 * GlobalVariable.d) / (GlobalVariable.iV + GlobalVariable.fV)
 GlobalVariable.t = round(100 * GlobalVariable.t) / 100
 checkUnknown()
 return
 case "fV D":
 GlobalVariable.fV = ((2.0 * GlobalVariable.d ) / GlobalVariable.t ) - GlobalVariable.iV
 GlobalVariable.fV = round(100 * GlobalVariable.fV) / 100
 checkUnknown()
 return
 default:
 print("bug")
 }
 //d = t(vo + v) /2
 }
 
 }
 

 
 
 
 
 
 
 
 
 */
 */*/
