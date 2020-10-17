//
//  KineticEnergyViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/25/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class KineticEnergyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var kineticETextField: UITextField!
    @IBOutlet weak var massTextField: UITextField!
    @IBOutlet weak var velocityTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var calculateResetButton: UIButton!
    @IBOutlet weak var showHideEqButton: UIButton!
    
    var calc: KineticEnergyEquations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kineticETextField.delegate = self
        massTextField.delegate = self
        velocityTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        calculateResetButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "options") {
            var svc = segue.destination as! OptionsViewController;
            svc.toPass = "kineticenergy"
        }
        
    }
    
    @IBAction func kineticEFieldEndEditing(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    @IBAction func massFieldEndEditing(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    @IBAction func velocityFieldEndEditing(_ sender: UITextField) {
        checkFieldStatus()
    }
    
    
    @IBAction func calculateOrReset(_ sender: UIButton) {
        if calculateResetButton.title(for: UIControlState.normal) == "Calculate" {
            switch false {
            case kineticETextField.isEnabled:
                let m: PhysicsVariable = PhysicsVariable.init(name: "m", value: Double(massTextField.text!)!)
                let v: PhysicsVariable = PhysicsVariable.init(name: "v", value: Double(velocityTextField.text!)!)
                let listOfVars: [PhysicsVariable] = [m, v]
                calc = KineticEnergyEquations.init(listOfKnowns: listOfVars)
                calc.solve()
            case massTextField.isEnabled:
                let k: PhysicsVariable = PhysicsVariable.init(name: "k", value: Double(kineticETextField.text!)!)
                let v: PhysicsVariable = PhysicsVariable.init(name: "v", value: Double(velocityTextField.text!)!)
                let listOfVars: [PhysicsVariable] = [k, v]
                calc = KineticEnergyEquations.init(listOfKnowns: listOfVars)
                calc.solve()
            case velocityTextField.isEnabled:
                let k: PhysicsVariable = PhysicsVariable.init(name: "k", value: Double(kineticETextField.text!)!)
                let m: PhysicsVariable = PhysicsVariable.init(name: "m", value: Double(massTextField.text!)!)
                let listOfVars: [PhysicsVariable] = [k, m]
                calc = KineticEnergyEquations.init(listOfKnowns: listOfVars)
                calc.solve()
            default:
                print("error w/ calculating")
            }
            answerLabel.text = "\(calc.getUnknown().value) \(calc.getUnknown().unit)"
            answerLabel.isHidden = false
            calculateResetButton.setTitle("Another Calculation", for: .normal)
        } else {
            calc.reset()
            kineticETextField.isEnabled = true
            massTextField.isEnabled = true
            velocityTextField.isEnabled = true
            calculateResetButton.isEnabled = false
            answerLabel.isHidden = true
            kineticETextField.text?.removeAll()
            massTextField.text?.removeAll()
            velocityTextField.text?.removeAll()
            calculateResetButton.setTitle("Calculate", for: .normal)
        }
    }
    
    func checkFieldStatus() {
        switch false {
        case (massTextField.text?.isEmpty)! || (velocityTextField.text?.isEmpty)!:
            calculateResetButton.isEnabled = true
            kineticETextField.isEnabled = false
        case (massTextField.text?.isEmpty)! || (kineticETextField.text?.isEmpty)!:
            calculateResetButton.isEnabled = true
            velocityTextField.isEnabled = false
        case (kineticETextField.text?.isEmpty)! || (velocityTextField.text?.isEmpty)!:
            calculateResetButton.isEnabled = true
            massTextField.isEnabled = false
        default:
            calculateResetButton.isEnabled = false
            print("field status is derp")
        }
    }
    
    @IBAction func showOrHideEquation(_ sender: UIButton) {
        if showHideEqButton.title(for: .normal) == "Show eq" {
            showHideEqButton.setTitle("Hide eq", for: .normal)
        } else {
            showHideEqButton.setTitle("Show eq", for: .normal)
        }
    }
    
    //Textfield shit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
