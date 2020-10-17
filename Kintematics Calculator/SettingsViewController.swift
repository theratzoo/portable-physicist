//
//  SettingsViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 1/3/19.
//  Copyright © 2019 Luke Deratzou. All rights reserved.
//
//
//
//TAG SYSTEM:
//1: pickerA PP
//2: pickerB PP
//3: pickerC PP
//4: switchA PP
//5: switchA CALC
//6: switchA GEN
//7: fieldA GEN
//8: switchB GEN
//9: fieldB GEN

//Can add a help option that can bring user to help screen... that shows a list of the different things in my app and how to navigate them... like a list and they can press arrows to view diffeerent view controllers which show instructions how to use those parts of the calculator.. would love to animate that stuff and make it look professional but simple text walls that look nice is fine too...

//Idea: help thing shows the view controller, but it highlights on a specific element and explains it briefly how to use it and what it does and such with a popup that the user must tap on to continue with tutorial... can exit the help screen whenever or hit arrow key to go to different view controller...

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl! //might not need this
    
    @IBOutlet weak var helpBtn: UIButton!
    
    
    var toPass: String = ""
    var tempEnableSigFigValue: Bool = false
    let listOfPhysicsProblems = Helper.GET_LIST_OF_EQS_FOR_SETTINGS()
    let listOfQuestionTypes = ["Select question type...", "Free Response", "Multiple Choice", "Both (random)"]
    let listOfTypesOfUnitsShown = ["Select unit type...", "SI (base)", "Metric", "Customary", "All"]
    var view5: UIView!
    
    var physicsProblemChoice: String = "Select problem type..."
    var questionTypeChoice: String = "Select question type..."
    var unitTypeChoice: String = "Select unit type..."
    var listOfSelectionBtns: [MenuButton] = [MenuButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toPass == "" && Helper.PREHELP_TOPASS != "empty" {
            toPass = Helper.PREHELP_TOPASS
        }
        formatObjects()
        setUpView()
        self.hideKeyboardWhenTappedAround()
        
        if Helper.MODE == "Help" {
            initiateHelpMode()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if UserDefaults.standard.getMode() == "Help" {
            return
        }
        switch segue.identifier {
        case "calculator":
            let svc = segue.destination as! CalculatorViewController;
            svc.toPass = toPass
            //svc.listOfVars = listOfVars
        case "home":
            let svc = segue.destination as! ViewController;
            svc.toPass = toPass
        case "unitconverter":
            let svc = segue.destination as! UnitConverterViewController;
            svc.toPass = toPass
        case "practiceproblems":
            let svc = segue.destination as! PracticeProblemsViewController;
            svc.toPass = toPass
        default:
            print("error w/ preparing for segue")
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        for i in self.view4.subviews {
            if i.tag == 9 && i.isFirstResponder {
                self.view.frame.origin.y = -100 // Move view 150 points upward
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func formatObjects() {
        saveBtn.isEnabled = false
        var cornerRadius: CGFloat = 10
        if self.view.frame.width > 500 {
            cornerRadius = 25
        }
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = cornerRadius
        
        var buttonY = returnBtn.frame.minY
        if(Helper.IS_IPHONE_X()) {
            buttonY = 42
        }
        let buttonLength: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: buttonY, width: buttonLength, height: buttonLength)
        if saveBtn.frame.width / 120 > saveBtn.frame.height / 30 {
            let newWidth: CGFloat = saveBtn.frame.height * (120/30)
            saveBtn.frame = CGRect(x: self.view.frame.width/2 - newWidth/2, y: saveBtn.frame.minY, width: newWidth, height: saveBtn.frame.height)
        } else {
            let newHeight: CGFloat = saveBtn.frame.width * (30/120)
            saveBtn.frame = CGRect(x: saveBtn.frame.minX, y: saveBtn.frame.minY, width: saveBtn.frame.width, height: newHeight)
        }
        if helpBtn.frame.width / 60 > helpBtn.frame.height / 20 {
            let newWidth: CGFloat = helpBtn.frame.height * (60/20)
            helpBtn.frame = CGRect(x: self.view.frame.width/2 - newWidth/2, y: helpBtn.frame.minY, width: newWidth, height: helpBtn.frame.height)
        } else {
            let newHeight: CGFloat = helpBtn.frame.width * (20/60)
            helpBtn.frame = CGRect(x: helpBtn.frame.minX, y: helpBtn.frame.minY, width: helpBtn.frame.width, height: newHeight)
        }
        if self.view.frame.width > 500 {
            titleLabel.font = UIFont(name: "Menlo", size: 40)
        } else {
            titleLabel.font = UIFont(name: "Menlo", size: 20)
        }
    }
    
    func setUpView() {
        if toPass == "practiceproblems" {
            questionTypeChoice = UserDefaults.standard.getProblemTypePP()
            physicsProblemChoice = UserDefaults.standard.getCurrentPhysicsEqPP()
            unitTypeChoice = UserDefaults.standard.getProblemUnitsPP()
            showPracticeProblemSettings(firstSetup: true)
            titleLabel.isHidden = true
        } else {
            showGeneralSettings(firstSetup: true)
            segmentControl.isHidden = true
        }
    }
    
    /*func showCalculatorSettings(firstSetup: Bool) {
        if firstSetup {
            let labelWidth: CGFloat = self.view1.frame.width * 0.55
            let labelHeight: CGFloat = 50
            let switchWidth: CGFloat = 75
            let switchHeight: CGFloat = 40
            
            let showUnitsLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
            showUnitsLabel.textColor = UIColor.white
            showUnitsLabel.font = UIFont(name: "Menlo", size: 13)
            showUnitsLabel.text = "Show units:"
            showUnitsLabel.numberOfLines = 3
            self.view1.addSubview(showUnitsLabel)
            let showUnitsSwitch: UISwitch = UISwitch(frame: CGRect(x: showUnitsLabel.frame.maxX + 30, y: showUnitsLabel.frame.midY/2, width: switchWidth, height: switchHeight))
            showUnitsSwitch.isOn = UserDefaults.standard.getShowUnitsCalc()
            showUnitsSwitch.addTarget(self, action: #selector(action1), for: .valueChanged)
            showUnitsSwitch.tag = 5
            self.view1.addSubview(showUnitsSwitch)
            
        } else {
            showAndHideSubviews()
        }
    }*/
    func showPracticeProblemSettings(firstSetup: Bool) {
        //first bit is to prevent the bug where 4th view never shows...
        view4.isHidden = false
        
        
        if firstSetup {
            var multiplier: CGFloat = 1
            if self.view.frame.width > 500 {
                multiplier += 1
            }
            let labelWidth: CGFloat = self.view1.frame.width * 0.40
            let labelHeight: CGFloat = self.view1.frame.height - 10*multiplier
            let buttonWidth: CGFloat = self.view1.frame.width * 0.52
            let buttonHeight: CGFloat = self.view.frame.height * 0.04 //bad code
            //can be a third of fourth or some other fraction of label height... at least for SE
            
            let fontSize:CGFloat = 13 * multiplier
            
            let physicsProblemLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 5*multiplier, width: labelWidth, height: labelHeight))
            physicsProblemLabel.textColor = UIColor.white
            physicsProblemLabel.font = UIFont(name: "Menlo", size: fontSize)
            physicsProblemLabel.text = "Type of Physics problem:"
            physicsProblemLabel.numberOfLines = 3
            self.view1.addSubview(physicsProblemLabel)
            let physicsProblemDragDownBtn: MenuButton = MenuButton(frame: CGRect(x: physicsProblemLabel.frame.maxX, y: 5*multiplier, width: buttonWidth, height: buttonHeight))
            physicsProblemDragDownBtn.setTitle("Select problem...", for: .normal)
            //change this to a background image in the future
            physicsProblemDragDownBtn.addTarget(self, action: #selector(pressPickerBtn), for: .touchUpInside)
            physicsProblemDragDownBtn.tag = -1
            self.view1.addSubview(physicsProblemDragDownBtn)
            let physicsProblemSavedLabel: UILabel = UILabel(frame: CGRect(x: physicsProblemDragDownBtn.frame.minX, y: physicsProblemDragDownBtn.frame.maxY, width: physicsProblemDragDownBtn.frame.width, height: self.view1.frame.height - 5*multiplier - physicsProblemDragDownBtn.frame.maxY))
            physicsProblemSavedLabel.textColor = UIColor.white
            physicsProblemSavedLabel.font = UIFont(name: "Menlo", size: fontSize)
            physicsProblemSavedLabel.text = "Saved: \(UserDefaults.standard.getCurrentPhysicsEqPP())"
            physicsProblemSavedLabel.tag = 51
            physicsProblemSavedLabel.numberOfLines = 2
            self.view1.addSubview(physicsProblemSavedLabel)
            //include a label with the current saved one for each that changes after u saved
            
         
            
            let problemTypeLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 5*multiplier, width: labelWidth, height: labelHeight))
            problemTypeLabel.textColor = UIColor.white
            problemTypeLabel.font = UIFont(name: "Menlo", size: fontSize)
            problemTypeLabel.text = "Type of question:"
            problemTypeLabel.numberOfLines = 3
            self.view2.addSubview(problemTypeLabel)
            let problemTypeDragDownBtn: MenuButton = MenuButton(frame: CGRect(x: problemTypeLabel.frame.maxX, y: 5*multiplier, width: buttonWidth, height: buttonHeight))
            problemTypeDragDownBtn.setTitle("Select question...", for: .normal)
            //change this to a background image in the future
            problemTypeDragDownBtn.addTarget(self, action: #selector(pressPickerBtn), for: .touchUpInside)
            problemTypeDragDownBtn.tag = -2
            self.view2.addSubview(problemTypeDragDownBtn)
            let problemTypeSavedLabel: UILabel = UILabel(frame: CGRect(x: problemTypeDragDownBtn.frame.minX, y: problemTypeDragDownBtn.frame.maxY, width: problemTypeDragDownBtn.frame.width, height: self.view2.frame.height - 5*multiplier - problemTypeDragDownBtn.frame.maxY))
            problemTypeSavedLabel.textColor = UIColor.white
            problemTypeSavedLabel.font = UIFont(name: "Menlo", size: fontSize)
            problemTypeSavedLabel.text = "Saved: \(UserDefaults.standard.getProblemTypePP())"
            problemTypeSavedLabel.tag = 52
            problemTypeSavedLabel.numberOfLines = 2
            self.view2.addSubview(problemTypeSavedLabel)
            
            let unitTypeLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 5*multiplier, width: labelWidth, height: labelHeight))
            unitTypeLabel.textColor = UIColor.white
            unitTypeLabel.font = UIFont(name: "Menlo", size: fontSize)
            unitTypeLabel.text = "Type of units shown:"
            unitTypeLabel.numberOfLines = 3
            self.view3.addSubview(unitTypeLabel)
            let unitTypeDragDownBtn: MenuButton = MenuButton(frame: CGRect(x: unitTypeLabel.frame.maxX, y: 5*multiplier, width: buttonWidth, height: buttonHeight))
            unitTypeDragDownBtn.setTitle("Select unit...", for: .normal)
            //change this to a background image in the future
            unitTypeDragDownBtn.addTarget(self, action: #selector(pressPickerBtn), for: .touchUpInside)
            unitTypeDragDownBtn.tag = -3
            self.view3.addSubview(unitTypeDragDownBtn)
            
            let unitTypeSavedLabel: UILabel = UILabel(frame: CGRect(x: unitTypeDragDownBtn.frame.minX, y: unitTypeDragDownBtn.frame.maxY, width: unitTypeDragDownBtn.frame.width, height: view3.frame.height - 5*multiplier - unitTypeDragDownBtn.frame.maxY))
            unitTypeSavedLabel.textColor = UIColor.white
            unitTypeSavedLabel.font = UIFont(name: "Menlo", size: fontSize)
            unitTypeSavedLabel.text = "Saved: \(UserDefaults.standard.getProblemUnitsPP())"
            unitTypeSavedLabel.tag = 53
            unitTypeSavedLabel.numberOfLines = 2
            self.view3.addSubview(unitTypeSavedLabel)
            let enableUnitLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 5*multiplier, width: labelWidth, height: labelHeight))
            enableUnitLabel.textColor = UIColor.white
            enableUnitLabel.font = UIFont(name: "Menlo", size: fontSize)
            enableUnitLabel.text = "Enable units for answer:"
            enableUnitLabel.numberOfLines = 3
            self.view4.addSubview(enableUnitLabel)
            let enableUnitSwitch: UISwitch = UISwitch(frame: CGRect(x: enableUnitLabel.frame.maxX + 30, y: enableUnitLabel.frame.midY - 15.5, width: 51, height: 31))
            enableUnitSwitch.isOn = UserDefaults.standard.isUnitsShownPP()
            enableUnitSwitch.addTarget(self, action: #selector(action1), for: .valueChanged)
            enableUnitSwitch.tag = 4
            self.view4.addSubview(enableUnitSwitch)
            enableUnitSwitch.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
            listOfSelectionBtns.append(physicsProblemDragDownBtn)
            listOfSelectionBtns.append(problemTypeDragDownBtn)
            listOfSelectionBtns.append(unitTypeDragDownBtn)
        } else {
            showAndHideSubviews()
        }
        if questionTypeChoice == "Multiple Choice" {
            view4.isHidden = true
        }
        
    }
    func showGeneralSettings(firstSetup: Bool) {
        if titleLabel.isHidden {
            showAndHideSubviews()
        }
        if firstSetup {
            let fontSize:CGFloat = Helper.GET_FONT_SIZE()
            //these are the values of ALL labels/fields
            //eventually, have a func for each to get them
            //based on the user's device...
            let labelWidth: CGFloat = self.view1.frame.width * 0.45
            let labelHeight: CGFloat = self.view1.frame.height - 20
            let textfieldWidth: CGFloat = self.view1.frame.width * 0.30
            var textfieldHeight: CGFloat = labelHeight / 2.6
            var multiplier: CGFloat = 1
            if self.view.frame.width > 500 {
                multiplier += 1
                textfieldHeight = textfieldHeight / 1.15
            }
            
            //FIRST is scientific notation switch
            let scientificNoationLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
            scientificNoationLabel.textColor = UIColor.white
            scientificNoationLabel.font = UIFont(name: "Menlo", size: fontSize)
            scientificNoationLabel.text = "Enable Scientific Notation:"
            scientificNoationLabel.numberOfLines = 3
            self.view1.addSubview(scientificNoationLabel)
            let scientificNotationSwitch: UISwitch = UISwitch(frame: CGRect(x: scientificNoationLabel.frame.maxX + 30, y: scientificNoationLabel.frame.midY - 15.5, width: 51, height: 31))
            scientificNotationSwitch.isOn = UserDefaults.standard.getEnableSciNot()
            scientificNotationSwitch.tag = 6
            scientificNotationSwitch.addTarget(self, action: #selector(action1), for: .valueChanged)
            self.view1.addSubview(scientificNotationSwitch)
            
            let decimalLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
            decimalLabel.textColor = UIColor.white
            decimalLabel.font = UIFont(name: "Menlo", size: fontSize)
            if UserDefaults.standard.getDecimalPointNum() == 6.1 {
                decimalLabel.text = "Number of decimal points shown (default- 6):"
            } else {
                decimalLabel.text = "Number of decimal points shown (currently- \(Int(UserDefaults.standard.getDecimalPointNum()))):"
            }
            
            decimalLabel.numberOfLines = 3
            self.view2.addSubview(decimalLabel)
            let decimalTextField: UITextField = UITextField(frame: CGRect(x: decimalLabel.frame.maxX + 10, y: decimalLabel.frame.midY - textfieldHeight/2, width: textfieldWidth, height: textfieldHeight))
            decimalTextField.textColor = UIColor.black
            decimalTextField.font = UIFont(name: "Menlo", size: fontSize)
            decimalTextField.backgroundColor = UIColor.white
            decimalTextField.addTarget(self, action: #selector(action1), for: .editingDidEnd)
            decimalTextField.tag = 7
            decimalTextField.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE())
            decimalTextField.keyboardType = UIKeyboardType.numberPad
            self.view2.addSubview(decimalTextField)
            
            let enableSigFigsLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
            enableSigFigsLabel.textColor = UIColor.white
            enableSigFigsLabel.font = UIFont(name: "Menlo", size: fontSize)
            enableSigFigsLabel.text = "Enable Significant Figures:"
            enableSigFigsLabel.numberOfLines = 3
            self.view3.addSubview(enableSigFigsLabel)
            let enableSigFigsSwitch: UISwitch = UISwitch(frame: CGRect(x: enableSigFigsLabel.frame.maxX + 30, y: enableSigFigsLabel.frame.midY - 15.5, width: 51, height: 31))
            enableSigFigsSwitch.isOn = UserDefaults.standard.getEnableSigFigs()
            tempEnableSigFigValue = UserDefaults.standard.getEnableSigFigs()
            enableSigFigsSwitch.addTarget(self, action: #selector(action1), for: .valueChanged)
            enableSigFigsSwitch.tag = 8
            self.view3.addSubview(enableSigFigsSwitch)
            scientificNotationSwitch.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
            enableSigFigsSwitch.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
            
            
            if UserDefaults.standard.getEnableSigFigs() {
                let sigFigLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
                sigFigLabel.textColor = UIColor.white
                sigFigLabel.font = UIFont(name: "Menlo", size: fontSize)
                if UserDefaults.standard.getSigFigNum() == 4.1 {
                    sigFigLabel.text = "Number of sig figs shown (default- 4):"
                } else {
                    sigFigLabel.text = "Number of sig figs shown (currently- \(Int(UserDefaults.standard.getSigFigNum()))):"
                }
                
                sigFigLabel.numberOfLines = 3
                self.view4.addSubview(sigFigLabel)
                let sigFigTextField: UITextField = UITextField(frame: CGRect(x: sigFigLabel.frame.maxX + 10, y: sigFigLabel.frame.midY - textfieldHeight/2, width: textfieldWidth, height: textfieldHeight))
                sigFigTextField.textColor = UIColor.black
                sigFigTextField.font = UIFont(name: "Menlo", size: 12)
                sigFigTextField.backgroundColor = UIColor.white
                sigFigTextField.tag = 9
                sigFigTextField.addTarget(self, action: #selector(action1), for: .editingDidEnd)
                sigFigTextField.keyboardType = UIKeyboardType.numberPad
                self.view4.addSubview(sigFigTextField)
            }
            
            
        }
        if !tempEnableSigFigValue {
            print("ghost")
            view4.isHidden = true
        } else {
            //testing this else statement, but looks like it works!
            view4.isHidden = false
        }
    }
    
    
    func showAndHideSubviews() {
        for i in view1.subviews {
            i.isHidden = !i.isHidden
            //to determine which is which when saving... remeber that the hidden ones
            //are the ones that the tab is not on (segmentControl.currentTab)
        }
        for i in view2.subviews {
            i.isHidden = !i.isHidden
        }
        for i in view3.subviews {
            i.isHidden = !i.isHidden
        }
        for i in view4.subviews {
            i.isHidden = !i.isHidden
        }
        //depricated code
        if view2.subviews.count == 0 && view1.subviews.count == 4 {
            view2.isHidden = !view2.isHidden
            view3.isHidden = !view3.isHidden
            view4.isHidden = !view4.isHidden
        }
    }
    
    @objc func action1(_ sender: Any) {
        saveBtn.isEnabled = true
        if (sender as AnyObject).tag == 8 {
            tempEnableSigFigValue = !tempEnableSigFigValue
            if (sender as AnyObject).isOn {
               var isAlreadyBuilt: Bool = false
                view4.isHidden = false
                for i in view4.subviews {
                    if i.tag == 9 {
                        isAlreadyBuilt = true
                    }
                }
                if !isAlreadyBuilt {
                    let fontSize:CGFloat = Helper.GET_FONT_SIZE()
                    let labelWidth: CGFloat = self.view1.frame.width * 0.45
                    let labelHeight: CGFloat = self.view1.frame.height - 20
                    let textfieldWidth: CGFloat = self.view1.frame.width * 0.30
                    var textfieldHeight: CGFloat = labelHeight / 2.6
                    if self.view.frame.width > 500 {
                        textfieldHeight = textfieldHeight / 1.15
                    }
                    
                    let sigFigLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: labelWidth, height: labelHeight))
                    sigFigLabel.textColor = UIColor.white
                    sigFigLabel.font = UIFont(name: "Menlo", size: fontSize)
                    sigFigLabel.numberOfLines = 3
                    if UserDefaults.standard.getSigFigNum() == 4.1 {
                        sigFigLabel.text = "Number of sig figs shown (default- 4):"
                    } else {
                        sigFigLabel.text = "Number of sig figs shown (currently- \(Int(UserDefaults.standard.getSigFigNum()))):"
                    }
                    sigFigLabel.numberOfLines = 3
                    self.view4.addSubview(sigFigLabel)
                    let sigFigTextField: UITextField = UITextField(frame: CGRect(x: sigFigLabel.frame.maxX, y: sigFigLabel.frame.midY - textfieldHeight/2, width: textfieldWidth, height: textfieldHeight))
                    sigFigTextField.textColor = UIColor.black
                    sigFigTextField.font = UIFont(name: "Menlo", size: fontSize)
                    sigFigTextField.backgroundColor = UIColor.white
                    sigFigTextField.tag = 9
                    sigFigTextField.addTarget(self, action: #selector(action1), for: .editingDidEnd)
                    sigFigTextField.keyboardType = UIKeyboardType.numberPad
                    self.view4.addSubview(sigFigTextField)
                }
            } else {
                view4.isHidden = true
            }
        }
    }
    //this and function below are for new format of pickerViews...
    @objc func pressPickerBtn(_ sender: AnyObject) {
        if view5 == nil {
            setUpView5()
        }
        
        view5.isHidden = false
        for i in view5.subviews {
            if i.tag == sender.tag * -1 {
                i.isHidden = false
            } else if i.tag == -10 {
                i.isHidden = false
            } else {
                i.isHidden = true
            }
        }
    }
    
    @objc func closePickerView(_ sender: AnyObject) {
        hideView5Stuff()
        for i in listOfSelectionBtns {
            switch i.tag {
            case -1:
                i.setTitle(physicsProblemChoice, for: .normal)
            case -2:
                i.setTitle(questionTypeChoice, for: .normal)
            case -3:
                i.setTitle(unitTypeChoice, for: .normal)
            default:
                print("FATAL ERROR")
            }
        }
        if segmentControl.selectedSegmentIndex == 0 && !segmentControl.isHidden {
            view4.isHidden = questionTypeChoice == "Multiple Choice"
        }
    }
    
    func hideView5Stuff() {
        if view5 == nil {
            return
        }
        for i in view5.subviews {
            i.isHidden = true
        }
        view5.isHidden = true
    }

    //sets up bottom picker view
    func setUpView5() {
        view5 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - Helper.GET_BOTTOM_VIEW_HEIGHT(), width: self.view.frame.width, height: Helper.GET_BOTTOM_VIEW_HEIGHT()))
        view5.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        self.view.addSubview(view5)
        
        let physicsProblemPicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view5.frame.height))
        physicsProblemPicker.delegate = self
        physicsProblemPicker.dataSource = self
        physicsProblemPicker.tag = 1
        self.view5.addSubview(physicsProblemPicker)
        physicsProblemPicker.isHidden = true
        
        let problemTypePicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view5.frame.height))
        problemTypePicker.delegate = self
        problemTypePicker.dataSource = self
        problemTypePicker.tag = 2
        self.view5.addSubview(problemTypePicker)
        physicsProblemPicker.isHidden = true
        
        let unitTypePicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view5.frame.height))
        unitTypePicker.delegate = self
        unitTypePicker.dataSource = self
        unitTypePicker.tag = 3
        self.view5.addSubview(unitTypePicker)
        unitTypePicker.isHidden = true
        
        let doneButton: DoneButton = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneButton.addTarget(self, action: #selector(closePickerView), for: .touchUpInside)
        doneButton.tag = -10
        self.view5.addSubview(doneButton)
        //create button here with tag of -10 and action of closePickerView
    }
    //shows a different settings view whenever user selects another
    @IBAction func segmentTabChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let isFirstSetup = view1.subviews.count == 3
            showGeneralSettings(firstSetup: isFirstSetup)
            hideView5Stuff()
        } else {
            showPracticeProblemSettings(firstSetup: false)
        }
    }
    //saves the user entered settings forever!
    @IBAction func saveSettings(_ sender: UIButton) {
        
        for i in view1.subviews {
            if i.tag != 0 {
                saveValue(valueObject: i, tag: i.tag)
            }
        }
        for i in view2.subviews {
            if i.tag != 0 {
                saveValue(valueObject: i, tag: i.tag)
            }
        }
        for i in view3.subviews {
            if i.tag != 0 {
                saveValue(valueObject: i, tag: i.tag)
            }
        }
        for i in view4.subviews {
            if i.tag != 0 {
                saveValue(valueObject: i, tag: i.tag)
            }
        }
        //first save the stuff
        
        saveBtn.isEnabled = false
        let saveAlert = UIAlertController(title: "Changes were saved", message: "", preferredStyle: .alert)
        present(saveAlert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            saveAlert.dismiss(animated: true, completion: nil)
        }
        
        if !segmentControl.isHidden {
            let fontSize:CGFloat = Helper.GET_FONT_SIZE()
            var frames: CGRect!
            for i in view1.subviews {
                if i.tag == 51 {
                    frames = i.frame
                    if let viewWithTag = self.view1.viewWithTag(i.tag) {
                        viewWithTag.removeFromSuperview()
                    }
                    let drroig: UILabel = UILabel(frame: frames)
                    drroig.textColor = UIColor.white
                    drroig.font = UIFont(name: "Menlo", size: fontSize)
                    drroig.text = "Saved: \(UserDefaults.standard.getCurrentPhysicsEqPP())"
                    drroig.tag = 51
                    self.view1.addSubview(drroig)
                }
            }
            for i in view2.subviews {
                if i.tag == 52 {
                    frames = i.frame
                    if let viewWithTag = self.view2.viewWithTag(i.tag) {
                        viewWithTag.removeFromSuperview()
                    }
                    let unitTypeSavedLabel: UILabel = UILabel(frame: frames)
                    unitTypeSavedLabel.textColor = UIColor.white
                    unitTypeSavedLabel.font = UIFont(name: "Menlo", size: fontSize)
                    unitTypeSavedLabel.text = "Saved: \(UserDefaults.standard.getProblemTypePP())"
                    unitTypeSavedLabel.tag = 52
                    self.view2.addSubview(unitTypeSavedLabel)
                }
            }
            for i in view3.subviews {
                 if i.tag == 53 {
                    frames = i.frame
                    if let viewWithTag = self.view3.viewWithTag(i.tag) {
                        viewWithTag.removeFromSuperview()
                    }
                    let unitTypeSavedLabel: UILabel = UILabel(frame: frames)
                    unitTypeSavedLabel.textColor = UIColor.white
                    unitTypeSavedLabel.font = UIFont(name: "Menlo", size: fontSize)
                    unitTypeSavedLabel.text = "Saved: \(UserDefaults.standard.getProblemUnitsPP())"
                    unitTypeSavedLabel.tag = 53
                    self.view3.addSubview(unitTypeSavedLabel)
                }
            }
        }
        
    }
    
    func saveValue(valueObject: AnyObject, tag: Int) {
        switch tag {
        case -1:
            var value = physicsProblemChoice
            if value.contains("...") {
                value = UserDefaults.standard.getCurrentPhysicsEqPP()
            }
            UserDefaults.standard.setCurrentPhysicsEqPP(value: value)
        case -2:
            var value = questionTypeChoice
            if value.contains("...") {
                value = UserDefaults.standard.getProblemTypePP()
            }
            UserDefaults.standard.setProblemTypePP(value: value)
        case -3:
            var value = unitTypeChoice
            if value.contains("...") {
                value = UserDefaults.standard.getProblemUnitsPP()
            }
            UserDefaults.standard.setProblemUnitsPP(value: value)
        case 4:
            let value: Bool = valueObject.isOn
            UserDefaults.standard.setShowUnitsPP(value: value)
        case 6:
            let value: Bool = valueObject.isOn
            UserDefaults.standard.setEnableSciNot(value: value)
        case 7:
            var value: Double = Double(valueObject.text) ?? UserDefaults.standard.getDecimalPointNum()
            if value >= 20 {
                presentError(type: "Overflow error: too large. Please enter a number below 20.")
                value = UserDefaults.standard.getDecimalPointNum()
            }
            UserDefaults.standard.setDecimalPointNum(value: value)
        case 8:
            let value: Bool = valueObject.isOn
            UserDefaults.standard.setEnableSigFigs(value: value)
        case 9:
            var value: Double = Double(valueObject.text) ?? UserDefaults.standard.getSigFigNum()
            if value >= 20 {
                presentError(type: "Overflow error: too large. Please enter a number below 20.")
                value = UserDefaults.standard.getDecimalPointNum()
            } else if value == 0 {
                presentError(type: "Invalid number: zero significant figures are not possible. Please enter a value greater than zero.")
                value = UserDefaults.standard.getDecimalPointNum()
            }
            UserDefaults.standard.setSigFigNum(value: value)
        default:
            print("ERRAR!")
        }
    }
    
    func presentError(type: String) {
        let errorAlert = UIAlertController(title: "Error!", message: type, preferredStyle: .alert)
        let errorAlertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
        })
        errorAlert.addAction(errorAlertAction)
        present(errorAlert, animated: true)
    }
    
    @IBAction func leaveSettings(_ sender: UIButton) {
        var tempToPass: String = toPass
        if tempToPass.contains("calculator") {
            tempToPass = "calculator"
        }
        switch tempToPass {
        case "home":
            performSegue(withIdentifier: "home", sender: self)
        case "unitconverter":
            performSegue(withIdentifier: "unitconverter", sender: self)
        case "calculator":
            performSegue(withIdentifier: "calculator", sender: self)
        case "practiceproblems":
            performSegue(withIdentifier: "practiceproblems", sender: self)
        default:
            print("ERROR W LEAVING")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return listOfPhysicsProblems.count
        case 2:
            return listOfQuestionTypes.count
        case 3:
            return listOfTypesOfUnitsShown.count
        default:
            print("error!")
            return listOfPhysicsProblems.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return listOfPhysicsProblems[row]
        case 2:
            return listOfQuestionTypes[row]
        case 3:
            return listOfTypesOfUnitsShown[row]
        default:
            print("error!")
            return listOfPhysicsProblems[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            physicsProblemChoice = listOfPhysicsProblems[row]
        case 2:
            questionTypeChoice = listOfQuestionTypes[row]
        case 3:
            unitTypeChoice = listOfTypesOfUnitsShown[row]
        default:
            print("FATAL ERROR")
        }
        saveBtn.isEnabled = true
    }
    
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
        switch pickerView.tag {
        case 1:
            pickerLabel?.text = listOfPhysicsProblems[row]
        case 2:
            pickerLabel?.text = listOfQuestionTypes[row]
        case 3:
            pickerLabel?.text = listOfTypesOfUnitsShown[row]
        default:
            print("FATAL ERROR!")
        }
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
    
    //NEW STUFF FOR HELPER!!!
    
    @IBAction func pressHelpBtn(_ sender: UIButton) {
        Helper.PREHELP_TOPASS = toPass
        initiateHelpMode()
        
    }
    
    func initiateHelpMode() {
        helpBtn.isHidden = true
        disableEverything()
        Helper.MODE = "Help"
        //create bar navigation... jk nav bars suck
        //can later turn this into a navbar... have navbar at bottom
        //and have three items: left- prev arrow; mid- exit btn; right- next arrow
        
        addHelpModeBtns()
        var factor: CGFloat = 1
        if self.view.frame.width > 500 {
            factor = 2
        }
        let explainationLabel: PaddingLabel = PaddingLabel(frame: CGRect(x: self.view.frame.midX - 90*factor, y: saveBtn.frame.minY - 60*factor, width: 180*factor, height: 50*factor))
        explainationLabel.text = "Click anything to learn more about it"
        explainationLabel.numberOfLines = 4
        explainationLabel.tag = -99
        explainationLabel.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE())
        explainationLabel.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        explainationLabel.textAlignment = .center
        self.view.addSubview(explainationLabel)
        setUpInvisibleBtns()
    }
    
    func addHelpModeBtns() {
        
        var factor: CGFloat = 1
        if self.view.frame.width > 500 {
            factor = 2
        }
        
        let helpView = UIView(frame: CGRect(x: 0, y: self.view.frame.maxY - 50*factor, width: self.view.frame.width, height: 50*factor))
        helpView.backgroundColor = UIColor.gray
        helpView.tag = -99
        self.view.addSubview(helpView)
        
        let rightArrow: UIButton = UIButton(frame: CGRect(x: self.view.frame.maxX - 100*factor, y: self.view.frame.maxY - 50*factor, width: 50*factor, height: 50*factor))
        rightArrow.setBackgroundImage(UIImage.init(named: "right_arrow.png"), for: .normal)
        rightArrow.addTarget(self, action: #selector(nextView), for: .touchUpInside)
        rightArrow.tag = -99
        self.view.addSubview(rightArrow)
        
        let exitBtn: UIButton = UIButton(frame: CGRect(x: self.view.frame.midX - factor*75/2, y: self.view.frame.maxY - 40*factor, width: 75*factor, height: 25*factor))
        exitBtn.setBackgroundImage(UIImage(named: "button_exit-help.gif"), for: .normal)
        //later add a nice picture for this (or just copy the one from quiz)
        exitBtn.addTarget(self, action: #selector(exitHelp), for: .touchUpInside)
        exitBtn.tag = -99
        self.view.addSubview(exitBtn)
    }
    
    func disableEverything() {
        for i in self.view.subviews {
            i.isUserInteractionEnabled = false
        }
    }
    
    func setUpInvisibleBtns() {
        var listOfBtns: [UIButton] = [UIButton]()
        listOfBtns.append(UIButton(frame: titleLabel.frame))
        listOfBtns.append(UIButton(frame: returnBtn.frame))
        listOfBtns.append(UIButton(frame: view1.frame))
        listOfBtns.append(UIButton(frame: view2.frame))
        listOfBtns.append(UIButton(frame: view3.frame))
        listOfBtns.append(UIButton(frame: view4.frame))
        listOfBtns.append(UIButton(frame: saveBtn.frame))

        for i in 0...6 {
            listOfBtns[i].tag = i
            listOfBtns[i].backgroundColor = UIColor.clear
            listOfBtns[i].addTarget(self, action: #selector(openPopup), for: .touchUpInside)
            if i == 5 && view4.isHidden == true {
                
            } else {
                self.view.addSubview(listOfBtns[i])
            }
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
        if segmentControl.selectedSegmentIndex == 0 && !segmentControl.isHidden {
            popUp.text = HelpPopups.PPSET[sender.tag]
        } else {
            popUp.text = HelpPopups.SETTINGS[sender.tag]
        }
        popUp.tag = -64
        popUp.isEditable = false
        popUp.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        popUp.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE() + 1*factor)
        self.view.addSubview(popUp)
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        
        self.view.addGestureRecognizer(exitGesture)
        /*tag:
         0: titleLabel
         1: returnBtn
         2: enableSciNotView
         3: decimalPntNumView
         4: enableSigFigView
         5: sigFigNumView
         6: saveBtn
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
        for i in self.view.subviews {
            if i.tag == -99 {
                if let viewWithTag = self.view.viewWithTag(i.tag) {
                    viewWithTag.removeFromSuperview()
                }
            } else if i.tag == -64 {
                closePopup(self)
            } else if i.backgroundColor == UIColor.clear {
                i.removeFromSuperview()
            } else {
                i.isUserInteractionEnabled = true
            }
            
        }
        helpBtn.isHidden = false
        Helper.MODE = "Normal"
        if self.view.gestureRecognizers == nil {
            return
        }
        for i in (self.view?.gestureRecognizers)! {
            self.view.removeGestureRecognizer(i)
        }
        
    }
    
    @objc func nextView(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "next", sender: self)
        //move to next view
    }
    
}
