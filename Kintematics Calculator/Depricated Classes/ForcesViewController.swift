//
//  ForcesViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/6/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class ForcesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var forceField: UITextField!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var massField: UITextField!
    @IBOutlet weak var accelLabel: UILabel!
    @IBOutlet weak var accelField: UITextField!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var anotherCalcBtn: UIButton!
    @IBOutlet weak var showWorkBtn: UIButton!
    
    var calc: ForceEquations!
    
    //static var isPopupEnabled: Bool = true
    
    struct ForceGlobals {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        forceField.delegate = self
        accelField.delegate = self
        massField.delegate = self
        answerLabel.isHidden = true
        anotherCalcBtn.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "options") {
            var svc = segue.destination as! OptionsViewController;
            svc.toPass = "forces"
        }
        
    }
    
    @IBAction func forceFieldEdit(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    @IBAction func massFieldEdit(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    @IBAction func accelFieldEdit(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    @IBAction func calculateForce(_ sender: UIButton) {
        switch false {
        case forceField.isEnabled:
            let a: PhysicsVariable = PhysicsVariable.init(name: "a", value: Double(accelField.text!)!)
            let m: PhysicsVariable = PhysicsVariable.init(name: "m", value: Double(massField.text!)!)
            let list: [PhysicsVariable] = [a, m]
            calc = ForceEquations.init(listOfVars: list)
            calc.doEquation()
            answerLabel.text = "\(calc.getUnknown().value) N"
        case accelField.isEnabled:
            let f: PhysicsVariable = PhysicsVariable.init(name: "f", value: Double(forceField.text!)!)
            let m: PhysicsVariable = PhysicsVariable.init(name: "m", value: Double(massField.text!)!)
            let list: [PhysicsVariable] = [f, m]
            calc = ForceEquations.init(listOfVars: list)
            calc.doEquation()
            answerLabel.text = "\(calc.getUnknown().value) m/s^2"
        case massField.isEnabled:
            let a: PhysicsVariable = PhysicsVariable.init(name: "a", value: Double(accelField.text!)!)
            let f: PhysicsVariable = PhysicsVariable.init(name: "f", value: Double(forceField.text!)!)
            let list: [PhysicsVariable] = [f, a]
            calc = ForceEquations.init(listOfVars: list)
            calc.doEquation()
            answerLabel.text = "\(calc.getUnknown().value) kg"
        default:
            print("error- cannot calc force eq")
        }
        answerLabel.isHidden = false
        forceField.isEnabled = false
        accelField.isEnabled = false
        massField.isEnabled = false
        anotherCalcBtn.isHidden = false
        calculateBtn.isEnabled = false
    }
    
    func checkFieldStatus() {
        switch true {
        case !(massField.text?.isEmpty)! && !(accelField.text?.isEmpty)!:
            calculateBtn.isEnabled = true
            forceField.isEnabled = false
            forceLabel.backgroundColor = UIColor.darkGray
        case !(massField.text?.isEmpty)! && !(forceField.text?.isEmpty)!:
            calculateBtn.isEnabled = true
            accelField.isEnabled = false
            accelLabel.backgroundColor = UIColor.darkGray
        case !(forceField.text?.isEmpty)! && !(accelField.text?.isEmpty)!:
            calculateBtn.isEnabled = true
            massField.isEnabled = false
            massLabel.backgroundColor = UIColor.darkGray
        default:
            calculateBtn.isEnabled = false
            print("only one field filled out!")
            
        }
    }
    @IBAction func doAnotherCalc(_ sender: UIButton) {
        answerLabel.isHidden = true
        forceField.isEnabled = true
        accelField.isEnabled = true
        massField.isEnabled = true
        anotherCalcBtn.isHidden = true
        forceField.text?.removeAll()
        accelField.text?.removeAll()
        massField.text?.removeAll()
        calc.reset()
    }
    
    @IBAction func showWorkAction(_ sender: UIButton) {
        //wip!
    }
    
    
    
    @IBAction func quickHelpPopup(_ sender: UIButton) {
        let alert = UIAlertController(title: "Instructions:", message: "Enter two values into the boxes. Make sure the units match the SI units!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //Textfield shit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        
        //need to get actual keyboard height... WIP
                           
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        //var movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        //var movementDuration:TimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }*/
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
