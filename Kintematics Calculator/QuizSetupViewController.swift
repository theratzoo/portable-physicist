//
//  QuizSetupViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 7/23/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

//var difficultyPickerData : [String] = [String]()
//var difficultyChosen : String = ""
//difficultyPickerData = ["Select difficulty", "easy", "normal", "hard", "AP"] later...

//ADD A "MIX" OPTION FOR BOTH FRQ AND MC QUESTIONS. Add an Any option, that then randomly sets toPass equal to an equation name for each problem.

import UIKit

class QuizSetupViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var toPass: String = ""
    
    @IBOutlet weak var numOfProblemsTxtField: UITextField!
   
    @IBOutlet weak var unitEnabledSwitch: UISwitch!
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var quizOptionLabel: PaddingLabel!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var readyToQuiz: UIButton!
    @IBOutlet weak var quizView: UIView!
    
    
    
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var selectQuestionTypeBtn: UIButton!
    @IBOutlet weak var selectUnitTypeBtn: UIButton!
    @IBOutlet weak var selectProblemTypeBtn: UIButton!
    
    @IBOutlet weak var numOfProblemsLabel: PaddingLabel!
    @IBOutlet weak var questionTypeLabel: PaddingLabel!
    @IBOutlet weak var unitTypeShownLabel: PaddingLabel!
    @IBOutlet weak var physicsProbTypeLabel: PaddingLabel!
    
    var typeOfUnitsData: [String] = [String]()
    var typeOfUnitsChosen: String = "Select unit type..."
    var questionTypesData : [String] = [String]()
    var questionTypeChosen : String = "Select question type..."
    var typeOfPhysicsProblemData: [String] = [String]()
    var physicsProblemTypeChosen: String = "Select physics concept..."
    
    var helpView: UIView = UIView()
    var bottomView: UIView!
    
    var exitHelpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //temp fix
        selectProblemTypeBtn.titleLabel?.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE() - 1)
        
        numOfProblemsTxtField.delegate = self
        formatButtonsAndLabels()
        unitView.isHidden = true
        
        if Helper.MODE == "Help" {
            helpMode()
            return
        }
        
        readyToQuiz.isEnabled = false
        typeOfUnitsData = ["Select unit type...", "SI (base)", "Metric", "Customary", "All"]
        questionTypesData = ["Select question type...", "multiple choice", "free response", "both (random)"]
        typeOfPhysicsProblemData = Helper.GET_LIST_OF_EQS_FOR_SETTINGS()

        helpView = UIView(frame: self.view.frame)
        setUpBottomView()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Helper.MODE == "Help" {
            if exitHelpMode {
                Helper.MODE = "Normal"
            }
            return
        }
        if segue.identifier == "options" {
            let svc = segue.destination as! OptionsViewController
            svc.toPass = toPass
        } else {
            let svc = segue.destination as! QuizViewController
            svc.toPass = physicsProblemTypeChosen
            print(physicsProblemTypeChosen)
            svc.totalNumberOfProblems = Int(numOfProblemsTxtField.text!)!
            svc.typeOfUnits = typeOfUnitsChosen
            svc.typeOfQuestion = questionTypeChosen
            svc.areUnitsEnabled = unitEnabledSwitch.isOn
        }
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
        numOfProblemsTxtField.layer.masksToBounds = true
        numOfProblemsTxtField.layer.cornerRadius = cornerRadius
        quizView.layer.masksToBounds = true
        quizView.layer.cornerRadius = 25
        quizOptionLabel.layer.masksToBounds = true
        quizOptionLabel.layer.cornerRadius = cornerRadius
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
            helpBtn.frame = CGRect(x: helpBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
        } else {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: returnBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            helpBtn.frame = CGRect(x: helpBtn.frame.minX, y: helpBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        }
        
        if readyToQuiz.frame.width / 120 > readyToQuiz.frame.height / 30 {
            let newWidth: CGFloat = readyToQuiz.frame.height * (120/30)
            readyToQuiz.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: readyToQuiz.frame.minY, width: newWidth, height: readyToQuiz.frame.height)
        } else {
            let newHeight: CGFloat = readyToQuiz.frame.width * (30/120)
            readyToQuiz.frame = CGRect(x: readyToQuiz.frame.minX, y: readyToQuiz.frame.minY, width: readyToQuiz.frame.width, height: newHeight)
        }
        
        if self.view.frame.width > 500 {
            unitEnabledSwitch.transform = CGAffineTransform(scaleX: 2.25, y: 2.25)
        }
        numOfProblemsTxtField.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE())
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - Helper.GET_BOTTOM_VIEW_HEIGHT(), width: self.view.frame.width, height: Helper.GET_BOTTOM_VIEW_HEIGHT()))
        bottomView.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        //bottomView.tag = 100
        self.view.addSubview(bottomView)
        bottomView.isHidden = true
        selectQuestionTypeBtn.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        selectUnitTypeBtn.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        selectProblemTypeBtn.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        selectQuestionTypeBtn.tag = 1
        selectUnitTypeBtn.tag = 2
        selectProblemTypeBtn.tag = 3
    }
    
    @objc func showPickerView(_ sender: UIButton) {
        bottomView.tag = 111
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = false
            }
        }
        bottomView.isHidden = false
        createPickerView(tag: sender.tag)
        let doneBtn = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.tag = -10
        doneBtn.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.bottomView.addSubview(doneBtn)
        doneBtn.isHidden = false
        
    }
    
    func createPickerView(tag: Int) {
        let bottomPicker:UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: self.bottomView.frame.height))
        bottomPicker.delegate = self
        bottomPicker.dataSource = self
        bottomPicker.tag = tag * -1
        self.bottomView.addSubview(bottomPicker)
    }
    
    @objc func hideBottomView(_ sender: UIButton) {
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = true
            }
        }
        bottomView.isHidden = true
        for i in bottomView.subviews {
            if let viewWithTag = self.bottomView.viewWithTag(i.tag) {
                viewWithTag.removeFromSuperview()
            }
        }
        setUpButtonTitles()
        checkFields()
    }
    
    func setUpButtonTitles() {
        selectUnitTypeBtn.setTitle(typeOfUnitsChosen, for: .normal)
        selectProblemTypeBtn.setTitle(physicsProblemTypeChosen, for: .normal)
        selectQuestionTypeBtn.setTitle(questionTypeChosen, for: .normal)
        /*if typeOfUnitsChosen != "" && typeOfUnitsChosen != "Select unit type..." {
            
        }*/
    }
    
    
    @IBAction func numOfProblemTFEndEditing(_ sender: UITextField) {
        checkFields()
    }
    
    @IBAction func beginQuizButton(_ sender: UIButton) {
        if (numOfProblemsTxtField.text?.isEmpty)! {
            alertActions("emtpyNumProb")
            return
        }
        if questionTypeChosen == "Select type of question" {
            alertActions("pickQType")
            return
        }
        if numOfProblemsTxtField.text == "0" {
            alertActions("valid input")
            return
        }
        if Double(numOfProblemsTxtField.text!)! > 200 {
            alertActions("overflow")
            return
        }
        performSegue(withIdentifier: "quiz", sender: self)
    }
    
    func checkFields() {
        let listOfChoices: [String] = [physicsProblemTypeChosen, questionTypeChosen, typeOfUnitsChosen]
        for i in listOfChoices {
            if i.contains("...") {
                readyToQuiz.isEnabled = false
                return
            }
        }
        if (numOfProblemsTxtField.text?.isEmpty)! {
            readyToQuiz.isEnabled = false
            return
        } else {
            readyToQuiz.isEnabled = true
        }
    }
    
    func alertActions(_ type: String) {
        switch type {
        case "emtpyNumProb":
            let alert = UIAlertController(title: "Error!", message: "Must input a value before proceeding", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            alert.addAction(alertAction)
            present(alert, animated: true)
        case "pickQType":
            let alert = UIAlertController(title: "Error!", message: "Must select a question type before proceeding", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            alert.addAction(alertAction)
            present(alert, animated: true)
        case "valid input":
            let alert = UIAlertController(title: "Error!", message: "Must select a non-zero number of problems", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            alert.addAction(alertAction)
            present(alert, animated: true)
        case "overflow":
            let alert = UIAlertController(title: "Error!", message: "Must select a number of problems less than or equal to 200.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            alert.addAction(alertAction)
            present(alert, animated: true)
        default:
            print("error")
        }
    }
    
    //UIPickerView Stuff:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case -1:
            return questionTypesData.count
        case -2:
            return typeOfUnitsData.count
        case -3:
            return typeOfPhysicsProblemData.count
        default:
            print("error!")
            return typeOfPhysicsProblemData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case -1:
            return questionTypesData[row]
        case -2:
            return typeOfUnitsData[row]
        case -3:
            return typeOfPhysicsProblemData[row]
        default:
            print("error!")
            return typeOfPhysicsProblemData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case -1:
            questionTypeChosen = questionTypesData[row]
            if questionTypeChosen != "multiple choice" {
                unitView.isHidden = false
            } else {
                unitView.isHidden = true
            }
        case -2:
            typeOfUnitsChosen = typeOfUnitsData[row]
        case -3:
            physicsProblemTypeChosen = typeOfPhysicsProblemData[row]
        default:
            print("error!")
        }
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
        case -1:
            pickerLabel?.text = questionTypesData[row]
        case -2:
            pickerLabel?.text = typeOfUnitsData[row]
        case -3:
            pickerLabel?.text = typeOfPhysicsProblemData[row]
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
    
    //text field restrictions:
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
           return false
        }
    }
    
    @IBAction func help(_ sender: UIButton) {
        quizView.isHidden = true
        readyToQuiz.isHidden = true
        self.view.addSubview(helpView)
        let width: CGFloat = 0.875 * self.view.frame.width
        var height: CGFloat = 0.234375 * self.view.frame.height
        var yPos: CGFloat = quizOptionLabel.frame.maxY
        var fontSize: CGFloat = Helper.GET_FONT_SIZE()
        var factor: CGFloat = 1
        if self.view.frame.width > 500 {
            fontSize = 25
            factor = 2
        }
        let physicsProblem: UILabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.0625, y: yPos, width: width, height: height))
        physicsProblem.textColor = UIColor.white
        physicsProblem.font = UIFont(name: "Menlo", size: fontSize)
        physicsProblem.text = "Type of physics problem refers to the equation required to solve the problems."
        physicsProblem.numberOfLines = 5
        yPos += (0.13204225352 * self.view.frame.height)
        let question: UILabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.0625, y: yPos, width: width, height: height))
        question.textColor = UIColor.white
        question.font = UIFont(name: "Menlo", size: fontSize)
        question.text = "Type of question refers to the format of answering the problem."
        question.numberOfLines = 5
        height = 0.3125 * self.view.frame.height
        yPos += (0.13204225352 * self.view.frame.height)
        let unitsShown: UILabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.0625, y: yPos, width: width, height: height))
        height = 0.234375 * self.view.frame.height
        unitsShown.textColor = UIColor.white
        unitsShown.font = UIFont(name: "Menlo", size: fontSize)
        unitsShown.text = "Type of units shown refers to the units presented in each question. For non-SI options, converting will be required to reach the correct answer."
        unitsShown.numberOfLines = 5
        height = 0.40625 * self.view.frame.height
        yPos += (self.view.frame.height * 0.17605633802)
        let unitsEnabled: UILabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.0625, y: yPos, width: width, height: height))
        unitsEnabled.textColor = UIColor.white
        unitsEnabled.font = UIFont(name: "Menlo", size: fontSize)
        unitsEnabled.text = "Enable units for answer refers to whether or not you will be required to select a unit for your answer. This feature is only available for Free-Response Questions."
        unitsEnabled.numberOfLines = 6
        let hideHelp: UIButton = UIButton(type: .system)
        
        let helpwidth: CGFloat = 0.375 * self.view.frame.width
        yPos = self.view.frame.height - helpwidth/5 - 50
        hideHelp.frame = CGRect(x: 0.3125 * self.view.frame.width, y: yPos, width:helpwidth, height: helpwidth/5)
        hideHelp.setBackgroundImage(UIImage(named:"button_hide-help.gif"), for: .normal)
        hideHelp.addTarget(self, action: #selector(hideHelpAction), for: .touchUpInside)
        self.helpView.addSubview(physicsProblem)
        self.helpView.addSubview(question)
        self.helpView.addSubview(unitsShown)
        self.helpView.addSubview(unitsEnabled)
        self.helpView.addSubview(hideHelp)
        quizOptionLabel.text = "Help:"
        quizOptionLabel.adjustsFontSizeToFitWidth = false
        quizOptionLabel.font = UIFont(name: "Menlo", size: 20*factor)
        quizOptionLabel.topInset = 20
        //type of physics problem
        //type of question
        //type of units shown
        //enable units for answer
    }
    
    @objc func hideHelpAction(_ sender: UIButton) {
        for v in self.helpView.subviews {
            v.removeFromSuperview()
        }
        helpView.removeFromSuperview()
        quizView.isHidden = false
        readyToQuiz.isHidden = false
        quizOptionLabel.text = "Problem Settings"
        quizOptionLabel.adjustsFontSizeToFitWidth = true
    }
    
    func helpMode() {
        //could use something to tell users that they are in Help Mode...
        //like a label at the top or whereever it would fit that says help mode
        //or it can be a banner at top that can just be dismissed with an x... idk
        unitView.isHidden = false
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
    
    func disableEverything() {
        for i in self.view.subviews {
            i.isUserInteractionEnabled = false
        }
        quizView.isUserInteractionEnabled = true
        for i in quizView.subviews {
            i.isUserInteractionEnabled = false
        }
    }
    
    func setUpInvisibleBtns() {
        var listOfBtns: [UIButton] = [UIButton]()
        
        listOfBtns.append(UIButton(frame: quizOptionLabel.frame))
        listOfBtns.append(UIButton(frame: returnBtn.frame))
        listOfBtns.append(UIButton(frame: helpBtn.frame))
        listOfBtns.append(UIButton(frame: CGRect(x: numOfProblemsLabel.frame.minX, y: numOfProblemsLabel.frame.minY, width: quizView.frame.width, height: numOfProblemsLabel.frame.height)))
        listOfBtns.append(UIButton(frame: CGRect(x: questionTypeLabel.frame.minX, y: questionTypeLabel.frame.minY, width: quizView.frame.width, height: questionTypeLabel.frame.height)))
        listOfBtns.append(UIButton(frame: CGRect(x: unitTypeShownLabel.frame.minX, y: unitTypeShownLabel.frame.minY, width: quizView.frame.width, height: unitTypeShownLabel.frame.height)))
        listOfBtns.append(UIButton(frame: CGRect(x: physicsProbTypeLabel.frame.minX, y: physicsProbTypeLabel.frame.minY, width: quizView.frame.width, height: physicsProbTypeLabel.frame.height)))
        listOfBtns.append(UIButton(frame: unitView.frame))
        listOfBtns.append(UIButton(frame: readyToQuiz.frame))
        
        for i in 0...listOfBtns.count - 1 {
            listOfBtns[i].tag = i
            listOfBtns[i].backgroundColor = UIColor.clear
            listOfBtns[i].addTarget(self, action: #selector(openPopup), for: .touchUpInside)
            if i > 2 && i < 8 {
                quizView.addSubview(listOfBtns[i])
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
        popUp.text = HelpPopups.PREQUIZ[sender.tag]
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
        performSegue(withIdentifier: "quiz", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "practice problems", sender: self)
    }

}
