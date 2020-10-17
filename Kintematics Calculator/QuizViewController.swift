//
//  QuizViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 3/25/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var promptTextView : UITextView!
    @IBOutlet weak var quizView: UIView!

    @IBOutlet weak var currentQuizScoreTitle: UILabel!
    //can combine this label and problem label into one...
    @IBOutlet weak var currentProblemLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonA : UIButton!
    @IBOutlet weak var buttonB : UIButton!
    @IBOutlet weak var buttonC : UIButton!
    @IBOutlet weak var buttonD : UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var mcview: UIView!
    
    @IBOutlet weak var saveProblemBtn: UIButton!
    
    //can also do this with buttons A-D
    var optionA = UILabel()
    var optionB = UILabel()
    var optionC = UILabel()
    var optionD = UILabel()
    var totalNumberOfProblems: Int = -1
    var problemNumber: Int = 1
    var numberOfProblemsLeft : Int = 0
    var unitsPickerData : [String] = [String]()
    var unitsChosen : String = "Select unit..."
    var correctAnswer : PhysicsVariable!
    var numOfWrongAnswers : Int = 0
    var numOfCorrectAnswers : Int = 0
    var toPass: String = ""
    var correctMCOption: String = "N/A"
    var listOfIncorrectProblems: [Int] = [Int]()
    var listOfUserAnswers: [String] = [String]()
    var listOfCorrectAnswers: [PhysicsVariable] = [PhysicsVariable]()
    var typeOfUnits: String = ""
    var typeOfQuestion: String = ""
    var areUnitsEnabled: Bool = false
    //can have a list of prompts & answers and whether or not the user got them correct or not. useful if they wish to review them after they finish the quiz.
    
    var bottomView: UIView!
    var selectUnitBtn: MenuButton!
    
    var savedName = "Saved Problem \(Int(UserDefaults.standard.getSavedProblemCounter()))"

    var exitHelpMode = false
    
    var listOfQuestions: [SavedProblem] = [SavedProblem]()
    
    var isRandomEq: Bool = false
    
    static var THE_ANSWER: PhysicsVariable!
    static var THE_PROMPT: String!
    static var LIST_OF_VARS: [PhysicsVariable]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        quizView.isHidden = false
        answerTextField.delegate = self
        unitsPickerData = ["Select units", "m/s", "s", Helper.exponentize(str: "m/s^2"), "m"]
        formatButtonsAndLabels()
        
        if Helper.MODE == "Help" {
            helpMode()
            return
        }
        
        beginQuiz()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PracticeProblemsViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
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
            let svc = segue.destination as! QuizOverviewViewController
            svc.toPass = toPass
            svc.listOfUserAnswers = listOfUserAnswers
            svc.listOfCorrectAnswers = listOfCorrectAnswers
            svc.listOfWrongProblemNumbers = listOfIncorrectProblems
            svc.numberOfCorrectAnswers = Double(numOfCorrectAnswers)
            svc.listOfQuestions = listOfQuestions
        }
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
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
        answerTextField.layer.cornerRadius = cornerRadius/2
        currentProblemLabel.layer.masksToBounds = true
        currentProblemLabel.layer.cornerRadius = cornerRadius
        currentQuizScoreTitle.layer.masksToBounds = true
        currentQuizScoreTitle.layer.cornerRadius = cornerRadius
        
        if self.view.frame.width > 500 {
            promptTextView.font = UIFont(name: "Menlo", size: 42)
            
        } else {
            answerTextField.font = answerTextField.font?.withSize(14)
        }
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            exitBtn.frame = CGRect(x: exitBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
            nextBtn.frame = CGRect(x: nextBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
        } else {
            exitBtn.frame = CGRect(x: exitBtn.frame.minX, y: exitBtn.frame.minY, width: smallestDimension, height: smallestDimension)
            nextBtn.frame = CGRect(x: nextBtn.frame.minX, y: nextBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        }
        
        if submitBtn.frame.width / 140 > submitBtn.frame.height / 30 {
            let newWidth: CGFloat = submitBtn.frame.height * (140/30)
            submitBtn.frame = CGRect(x: submitBtn.frame.minX, y: submitBtn.frame.minY, width: newWidth, height: submitBtn.frame.height)
        } else {
            let newHeight: CGFloat = submitBtn.frame.width * (30/140)
            submitBtn.frame = CGRect(x: submitBtn.frame.minX, y: submitBtn.frame.minY, width: submitBtn.frame.width, height: newHeight)
        }
        
        if saveProblemBtn.frame.width / 60 > saveProblemBtn.frame.height / 20 {
            let newWidth: CGFloat = saveProblemBtn.frame.height * (60/20)
            saveProblemBtn.frame = CGRect(x: saveProblemBtn.frame.minX, y: saveProblemBtn.frame.minY, width: newWidth, height: saveProblemBtn.frame.height)
        } else {
            let newHeight: CGFloat = saveProblemBtn.frame.width * (20/60)
            saveProblemBtn.frame = CGRect(x: saveProblemBtn.frame.minX, y: saveProblemBtn.frame.minY, width: saveProblemBtn.frame.width, height: newHeight)
        }
        if self.view.frame.width > 500 {
            currentQuizScoreTitle.font = UIFont(name: "Menlo", size: 40)
            currentProblemLabel.font = UIFont(name: "Menlo", size: 40)
        } else {
            currentQuizScoreTitle.font = UIFont(name: "Menlo", size: 20)
            currentProblemLabel.font = UIFont(name: "Menlo", size: 20)
        }
        
    }
    //called everytime a new question appears, but only will run if user selected All (random)
    func randomToPass() {
        if isRandomEq {
            toPass = Helper.GET_LIST_OF_EQS()[Int(arc4random_uniform(UInt32(Helper.GET_LIST_OF_EQS().count)))]
        }
    }
    
    func beginQuiz() {
        if Helper.MODE == "Help" {
            totalNumberOfProblems = 10
            typeOfUnits = "SI (base)"
            toPass = "kinematics"
            typeOfQuestion = "free response"
            areUnitsEnabled = true
        }
        
        if toPass.lowercased() == "all (random)" {
            isRandomEq = true
        }
        randomToPass()
        submitBtn.isEnabled = false
        numberOfProblemsLeft = totalNumberOfProblems - 1
        currentProblemLabel.text = "Problem 1/\(numberOfProblemsLeft + problemNumber)"
        
        PracticeProblemsViewController().generateQuizProblem(typeOfEq: toPass, theTypeOfUnitsShown: typeOfUnits)
        
        promptTextView.text = QuizViewController.THE_PROMPT
        
        correctAnswer = QuizViewController.THE_ANSWER
        
        
        if typeOfQuestion == "multiple choice" {
             enableMCFields()
            generateRandomMCOptions()
            answerTextField.isHidden = true
            hideMCStuff(hide: false)
            
        } else if typeOfQuestion == "free response" {
            mcview.isHidden = true
            if areUnitsEnabled {
                setUpBottomView()
            }
        } else if arc4random_uniform(2) == 1 {
           
            //mc
            
            enableMCFields()
            generateRandomMCOptions()
            answerTextField.isHidden = true
            hideMCStuff(hide: false)
        } else {
            mcview.isHidden = true
            if areUnitsEnabled {
                setUpBottomView()
            }
            //frq
        }
        
        
        listOfCorrectAnswers.append(correctAnswer)
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - Helper.GET_BOTTOM_VIEW_HEIGHT(), width: self.view.frame.width, height: Helper.GET_BOTTOM_VIEW_HEIGHT()))
        bottomView.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        //bottomView.tag = 100
        self.view.addSubview(bottomView)
        bottomView.isHidden = true
        var factor: CGFloat = 1
        if self.view.frame.width > 500 {
            factor = 2
        }
        let z = factor - 1
        selectUnitBtn = MenuButton(frame: CGRect(x: answerTextField.frame.maxX + 10 + 60*z, y: answerTextField.frame.minY, width: 140*factor + 140*z, height: 30*factor))
        selectUnitBtn.setTitle("Select unit...", for: .normal)
        selectUnitBtn.addTarget(self, action: #selector(showBottomView), for: .touchUpInside)
        selectUnitBtn.tag = -50
        self.view.addSubview(selectUnitBtn)
        let bottomPicker:UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: self.bottomView.frame.height))
        bottomPicker.delegate = self
        bottomPicker.dataSource = self
        self.bottomView.addSubview(bottomPicker)
        let doneBtn = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneBtn.tag = -10
        doneBtn.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.bottomView.addSubview(doneBtn)
        self.view.bringSubview(toFront: bottomView)
        switch toPass {
        case "kinematics":
            unitsPickerData = ["Select units...", "meters/second", "seconds", Helper.exponentize(str: "meters/second^2"), "meters"]
        case "forces":
            unitsPickerData = ["Select units...", "Newtons", "kilograms", Helper.exponentize(str: "meters/second^2")]
        case "kinetic energy":
            unitsPickerData = ["Select units...", "Joules", "kilograms", "meters/second"]
        case "gravitational force":
            unitsPickerData = ["Select units...", "Newtons", "kilograms", "meters"]
        default:
            print("error: toPass isn't working")
            unitsPickerData = ["Select units...", "m/s", "s", Helper.exponentize(str: "m/s^2"), "m"]
        }
    }
    
    @objc func showBottomView(_ sender: MenuButton) {
        bottomView.tag = 111
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = false
            }
        }
        bottomView.isHidden = false
    }
    
    @objc func hideBottomView(_ sender: UIButton) {
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = true
            }
        }
        bottomView.isHidden = true
        selectUnitBtn.setTitle(unitsChosen, for: .normal)
    }
    
    //568: SE
    //812: X
    func enableMCFields() {
        
        let btnLength = min(buttonA.frame.width, buttonA.frame.height)
        buttonA.frame = CGRect(x: buttonA.frame.minX, y: buttonA.frame.minY, width: btnLength, height: btnLength)
        buttonB.frame = CGRect(x: buttonB.frame.minX, y: buttonB.frame.minY, width: btnLength, height: btnLength)
        buttonC.frame = CGRect(x: buttonC.frame.minX, y: buttonC.frame.minY, width: btnLength, height: btnLength)
        buttonD.frame = CGRect(x: buttonD.frame.minX, y: buttonD.frame.minY, width: btnLength, height: btnLength)
        var yPos: Double = 0
        let x : Double = Double(mcview.frame.width * 0.2)
        let height: Double = Double(buttonA.frame.height)
        var fontSettings = UIFont(name: "Menlo", size: 16)
        let width: Double = Double(self.view.frame.width) - x - 20
        if self.view.frame.height > 800 {
            fontSettings = UIFont(name: "Menlo", size: 20)
            //width = 300 was 200 for prior one
        }
        if self.view.frame.width > 500 {
            fontSettings = UIFont(name: "Menlo", size: 32)
        }
        
        var newLabelFrame = CGRect(x: x, y:yPos, width:width, height:height)
        optionA.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        optionA.frame = newLabelFrame
        optionA.textColor = UIColor.white
        optionA.font = fontSettings
        
        
        yPos += Double(mcview.frame.height * 0.25)
        optionB.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newLabelFrame = CGRect(x: x, y:yPos, width:width, height:height)
        optionB.frame = newLabelFrame
        optionB.textColor = UIColor.white
        optionB.font = fontSettings
        
        yPos += Double(mcview.frame.height * 0.25)
        optionC.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newLabelFrame = CGRect(x: x, y:yPos, width:width, height:height)
        optionC.frame = newLabelFrame
        optionC.textColor = UIColor.white
        optionC.font = fontSettings
        
        yPos += Double(mcview.frame.height * 0.25)
        optionD.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newLabelFrame = CGRect(x: x, y:yPos, width:width, height:height)
        optionD.frame = newLabelFrame
        
        optionD.textColor = UIColor.white
        optionD.font = fontSettings
        
        self.mcview.addSubview(optionA)
        self.mcview.addSubview(optionB)
        self.mcview.addSubview(optionC)
        self.mcview.addSubview(optionD)
    }
    
    func resetMC() {
        optionA.text?.removeAll()
        optionB.text?.removeAll()
        optionC.text?.removeAll()
        optionD.text?.removeAll()
        buttonA.isEnabled = true
        buttonB.isEnabled = true
        buttonC.isEnabled = true
        buttonD.isEnabled = true
        correctMCOption = "N/A"
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
        case "exitEarly":
            let alert = UIAlertController(title: "Warning:", message: "Your current quiz will not be saved or accessible if left now. Are you sure you wish to proceed? ", preferredStyle: .alert)
            let alertActionYes = UIAlertAction(title: "Leave Quiz", style: .default, handler: { (action) in
                self.leaveQuiz()
            })
            //find out how to make this one actually do something
            let alertActionNo = UIAlertAction(title: "Cancel", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            alert.addAction(alertActionNo)
            alert.addAction(alertActionYes)
            present(alert, animated: true)
        default:
            print("error- cannot find alertAction type")
        }
    }
    
    func leaveQuiz() {
        performSegue(withIdentifier: "options", sender: self)
    }
    
    @IBAction func exitBtnAction(_ sender: UIButton) {
        alertActions("exitEarly")
        
    }
    //saves prior question first before moving on
    @IBAction func nextButtonAction(_ sender: UIButton) {
        var listOfAnswers: [PhysicsVariable] = [PhysicsVariable]()
        var listOfKnowns: [PhysicsVariable] = [PhysicsVariable]()
        if toPass == "kinematics" {
            listOfAnswers.append(QuizViewController.LIST_OF_VARS[QuizViewController.LIST_OF_VARS.count - 2])
        }
        listOfAnswers.append(QuizViewController.LIST_OF_VARS[QuizViewController.LIST_OF_VARS.count - 1])
        for i in 0...QuizViewController.LIST_OF_VARS.count - listOfAnswers.count - 1 {
            listOfKnowns.append(QuizViewController.LIST_OF_VARS[i])
        }
        let prompt: String = promptTextView.text
        let savedProblem = SavedProblem.init(answers: listOfAnswers, knownValues: listOfKnowns, equation: toPass, savedProblemName: "Problem \(problemNumber-1)", prompt: prompt)
        listOfQuestions.append(savedProblem)
        
        answerTextField.isEnabled = true
        promptTextView.textColor = UIColor.black
        nextBtn.isEnabled = false
        answerTextField.text?.removeAll()
        if totalNumberOfProblems - numberOfProblemsLeft != numOfWrongAnswers + numOfCorrectAnswers {
            let problemWarning = UIAlertController(title: "WARNING:", message: "You have not answered the question. Please provide an answer before proceeding.", preferredStyle: .alert)
            let problemWarningAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            })
            problemWarning.addAction(problemWarningAction)
            present(problemWarning, animated: true)
        } else {
            if numberOfProblemsLeft == 0 {
                performSegue(withIdentifier: "overview", sender: self)
                return
            } else {
                numberOfProblemsLeft -= 1
            }
            if numberOfProblemsLeft == 0 {
                nextBtn.setTitle("Finish", for: .normal)
            }
            randomToPass()
            currentProblemLabel.text = "Problem \(totalNumberOfProblems - numberOfProblemsLeft)/\(totalNumberOfProblems)"
            
            PracticeProblemsViewController().generateQuizProblem(typeOfEq: toPass, theTypeOfUnitsShown: typeOfUnits)
            promptTextView.text = QuizViewController.THE_PROMPT
            correctAnswer = QuizViewController.THE_ANSWER
            if typeOfQuestion == "multiple choice" {
                resetMC()
                generateRandomMCOptions()
                buttonA.isUserInteractionEnabled = true
                buttonB.isUserInteractionEnabled = true
                buttonC.isUserInteractionEnabled = true
                buttonD.isUserInteractionEnabled = true
            } else if typeOfQuestion == "free response" {
                
            } else if arc4random_uniform(2) == 1 {
                //mc
                mcview.isHidden = false
                answerTextField.isHidden = true
                if mcview.subviews.count < 8 {
                    enableMCFields()
                } else {
                    resetMC()
                }
                generateRandomMCOptions()
                buttonA.isUserInteractionEnabled = true
                buttonB.isUserInteractionEnabled = true
                buttonC.isUserInteractionEnabled = true
                buttonD.isUserInteractionEnabled = true
                for i in self.view.subviews {
                    if i.tag == -50 {
                        i.isHidden = true
                    }
                }
            } else {
                mcview.isHidden = true
                answerTextField.isHidden = false
                for i in self.view.subviews {
                    if i.tag == -50 {
                        i.isHidden = false
                    }
                }
                //frq
            }

        }
        listOfCorrectAnswers.append(correctAnswer)
    }
    
    func hideMCStuff(hide: Bool) {
        var listOfLabels: [UILabel] = [optionA, optionB, optionC, optionD]
        var listOfBtns: [UIButton] = [buttonA, buttonB, buttonC, buttonD]
        for i in 0...3 {
            listOfLabels[i].isHidden = hide
            listOfBtns[i].isHidden = hide
            if hide {
                listOfLabels[i].text?.removeAll()
            }
            
        }
    }
    //this function is s**t if the option text is in fancy scientific notation... :(
    //EDIT: idk why i have this function... i think it is unneccesary LOL
    //EDIT2: DELETE THIS
    func unwrapOptionText(text: String) -> Double {
        var numb: String = ""
        for i in text {
            if isLetter(i) {
                return Double(numb)!
            } else {
                numb.append(i)
            }
        }
        return Double(numb)!
    }
    
    func isLetter(_ lett: Character) -> Bool {
        let c = String(lett).lowercased()
        let test = "abcdefghijklmnopqrstuvwxyz "
        return test.contains(c)
    }
    
    
    //V 1.1 note: if i mess up, V1.0 is good back up
    @IBAction func submitAnswerBtnAction(_ sender: UIButton) {
        nextBtn.isEnabled = true
        if answerTextField.isHidden {
            switch true {
            case !buttonA.isEnabled:
                listOfUserAnswers.append(optionA.text!)
            case !buttonB.isEnabled:
                listOfUserAnswers.append(optionB.text!)
            case !buttonC.isEnabled:
                listOfUserAnswers.append(optionC.text!)
            case !buttonD.isEnabled:
                listOfUserAnswers.append(optionD.text!)
            default:
                print("FATAL ERROR")
            }
            if !buttonA.isEnabled {
                if correctMCOption == "A" {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                    promptTextView.textColor = UIColor.green
                    disableBtns()
                    problemNumber += 1
                    return
                }
            } else if !buttonB.isEnabled  {
                if correctMCOption == "B" {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                    promptTextView.textColor = UIColor.green
                    disableBtns()
                    problemNumber += 1
                    return
                }
            } else if !buttonC.isEnabled  {
                if correctMCOption == "C" {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                    promptTextView.textColor = UIColor.green
                    disableBtns()
                    problemNumber += 1
                    return
                }
            } else if !buttonD.isEnabled  {
                if correctMCOption == "D" {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                    promptTextView.textColor = UIColor.green
                    disableBtns()
                    problemNumber += 1
                    return
                }
            }
            numOfWrongAnswers += 1
            currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
            switch correctMCOption {
            case "A":
                let txt: String = optionA.text!
                promptTextView.text = "Incorrect! The correct answer is: \(txt) (A)"
                promptTextView.textColor = UIColor.red
            case "B":
                let txt: String = optionB.text!
                promptTextView.text = "Incorrect! The correct answer is: \(txt) (B)"
                promptTextView.textColor = UIColor.red
            case "C":
                let txt: String = optionC.text!
                promptTextView.text = "Incorrect! The correct answer is: \(txt) (C)"
                promptTextView.textColor = UIColor.red
            case "D":
                let txt: String = optionD.text!
                promptTextView.text = "Incorrect! The correct answer is: \(txt) (D)"
                promptTextView.textColor = UIColor.red
            default:
                print("error w/ displaying correct MC option")
            }
            disableBtns()
        } else {
            guard let x = Double(answerTextField.text!) else { invaldAnswer(); return }
            answerTextField.isEnabled = false
            let userAns: Double = x
            var units: String = ""
            if !areUnitsEnabled {
                units = correctAnswer.unit
            } else {
                units = unitsChosen
            }
            let ansAndUnits: String = "\(userAns) \(units)"
            listOfUserAnswers.append(ansAndUnits)
            //for rounding differences... might want to find more accurate way to get this range
            let ans: Double = correctAnswer.value
            if ans > 0 {
                let ansHighRange = ans + (ans / 100.0)
                let ansLowRange = ans - (ans / 100.0)
                print(ansHighRange)
                print(ansLowRange)
                if units == correctAnswer.unit && ansHighRange > userAns && userAns > ansLowRange {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                } else {
                    numOfWrongAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Incorrect! The correct answer is: \(correctAnswer.getRoundedAns()) \(correctAnswer.unit)"
                }
            } else {
                let ansLowRange = ans + (ans / 100.0)
                let ansHighRange = ans - (ans / 100.0)
                print(ansHighRange)
                print(ansLowRange)
                if units == correctAnswer.unit && ansHighRange > userAns && userAns > ansLowRange {
                    numOfCorrectAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Correct!"
                } else {
                    numOfWrongAnswers += 1
                    currentQuizScoreTitle.text = "Score: \(numOfCorrectAnswers) / \(totalNumberOfProblems - numberOfProblemsLeft)."
                    promptTextView.text = "Incorrect! The correct answer is: \(correctAnswer.getRoundedAns()) \(correctAnswer.unit)"
                }
            }
            
        }
        submitBtn.isEnabled = false
        if promptTextView.text.contains("Incorrect") {
            listOfIncorrectProblems.append(problemNumber)
        }
        problemNumber += 1
    }
    
    func invaldAnswer() {
        let alert = UIAlertController(title: "Error!", message: "Invalid number- please input a valid number.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
        })
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func disableBtns() {
        buttonA.isUserInteractionEnabled = false
        buttonB.isUserInteractionEnabled = false
        buttonC.isUserInteractionEnabled = false
        buttonD.isUserInteractionEnabled = false
        submitBtn.isEnabled = false
    }
    
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
    
    func generateRandomMCOptions() {
        let rando = arc4random_uniform(UInt32(4))
        
        var answer: String = "\(QuizViewController.THE_ANSWER.value)"

        let v: String = "\(correctAnswer.value)"
        let u: String = Helper.GET_SHORTENED_UNIT(unitName: correctAnswer.unit)
        
        
        if UserDefaults.standard.getEnableSigFigs() {
            answer = SigFigCalculator.init(number: v).getRoundedAnswer()
        } else {
            answer = RoundByDecimals.ROUND_BY_DECIMALS(value: v)
        }

        if UserDefaults.standard.getCurrentPhysicsEqPP() == "gravitational force" {
            answer = generateRandomOptions(isReal: true)
        } else if UserDefaults.standard.getCurrentPhysicsEqPP() == "kinetic energy" && u == "J" && checkPow(value: answer) > 9 {
            answer = Helper.CONVERT_TO_SCI_NOTATION(value: answer)
        }

        correctAnswer.mcAnswer = answer
        
        //
        /*if answer.contains("e") {
            answer = Helper.FIX_SCIENTIFIC_NOTATION(value: answer)
        }*/

        //generate 3 other random numbers that will also have two random decimal spots so they don't look fishy. And for now, make all units match up w/ the answer's
        var listOfNotAnswerLabels: [UILabel] = [optionA, optionB, optionC, optionD]
        switch rando {
        case 0:
            optionA.text = "\(answer)"
            setUpOtherOptions(filledInLabelNum: 0, unit: u)
            correctMCOption = "A"
            listOfNotAnswerLabels.remove(at: 0)
            configureAnswer(answer: optionA, listOfNotAnswers: listOfNotAnswerLabels)
            
        case 1:
            optionB.text = "\(answer)"
            setUpOtherOptions(filledInLabelNum: 1, unit: u)
            correctMCOption = "B"
            listOfNotAnswerLabels.remove(at: 1)
            configureAnswer(answer: optionB, listOfNotAnswers: listOfNotAnswerLabels)
        case 2:
            optionC.text = "\(answer)"
            setUpOtherOptions(filledInLabelNum: 2, unit: u)
            correctMCOption = "C"
            listOfNotAnswerLabels.remove(at: 2)
            configureAnswer(answer: optionC, listOfNotAnswers: listOfNotAnswerLabels)
        case 3:
            optionD.text = "\(answer)"
            setUpOtherOptions(filledInLabelNum: 3, unit: u)
            correctMCOption = "D"
            listOfNotAnswerLabels.remove(at: 3)
            configureAnswer(answer: optionD, listOfNotAnswers: listOfNotAnswerLabels)
        default:
            print("FATAL ERROR")
        }
        listOfNotAnswerLabels = [optionA, optionB, optionC, optionD]
        addUnit(listOfLabels: listOfNotAnswerLabels, unit: u)
    }
    
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
    
    func setUpOtherOptions(filledInLabelNum: Int, unit: String) {
        var listOfLabels = [optionA, optionB, optionC, optionD]
        for i in 0...3 {
            if i != filledInLabelNum {
                if toPass == "gravitational force" {
                    listOfLabels[i].text = "\(generateRandomOptions(isReal: false))"
                } else {
                    listOfLabels[i].text = "\(generateRandomAnswer())"
                }
            }
        }
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
    
    //INSERT PRACTICE PROBLEM VERSION FOR GRAV FORCE
    
    //fix/improved
    //E. I got an improved version in Practice Problem VC, so use that one!!!!!!
    func generateRandomOptions(isReal: Bool) -> String {
        let answer: PhysicsVariable = PhysicsVariable.init(name: correctAnswer.name, value: correctAnswer.value)
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
            if correctAnswer.value < 1000000.0 {
                if isReal {
                    return correctAnswer.getRoundedAns()
                }
                return "\(generateRandomAnswer())"
            }
            //WAS SIG FIGS... BAD CODE FIX
            for i in 0...Int(UserDefaults.standard.getDecimalPointNum()) {
                let index = answer.getRoundedAns().index(answer.getRoundedAns().startIndex, offsetBy: i)
                
                if answer.getRoundedAns()[index] == "." {
                    if isReal {
                        return correctAnswer.getRoundedAns()
                    }
                    return "\(generateRandomAnswer())"
                }
                
                if i == 1 {
                    randomAns += "."
                    randomAns.append(answer.getRoundedAns()[index])
                } else {
                    randomAns.append(answer.getRoundedAns()[index])
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
    
    //fix/improved
    func generateRandomAnswer() -> String {
        while(true) {
            var answer: Double = correctAnswer.value
            let a = answer < 1 && answer > 0
            let b = answer > -1 && answer < 0
            if a || b {
                let ans: String = correctAnswer.mcAnswer
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
                
                return randoAns
            }
            let decNum = Int(UserDefaults.standard.getDecimalPointNum())
            //start off with a ton of sig figs, then round at end
            answer = Helper.ROUND_BY_DECIMAL_POINTS(value: answer, roundBy: Double(decNum)) //was 5
            
            
            if answer > 1000000000 || answer < -1000000000 {
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
                        if neg == 1 && !correctAnswer.isScalar {
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
    
    /*func generateRandomAnswer() -> Double {
        while(true) {
            let x = Int(abs(QuizViewController.THE_ANSWER.value)) + 1
            var random: Double = Double(arc4random_uniform(UInt32(x * 10)))
            let randomDecimal = Double(arc4random_uniform(UInt32(100)))
            random += (randomDecimal / 100.0) + 1.0
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
                        if neg == 1 && !correctAnswer.isScalar {
                            random = random * -1.0
                        }
                        return random
                    }
                }
            }
        }
        
    }*/
    
    func disableChosenButton(_ button: String) {
        submitBtn.isEnabled = true
        switch button {
        case "A":
            buttonA.isEnabled = false
            buttonB.isEnabled = true
            buttonC.isEnabled = true
            buttonD.isEnabled = true
        case "B":
            buttonA.isEnabled = true
            buttonB.isEnabled = false
            buttonC.isEnabled = true
            buttonD.isEnabled = true
        case "C":
            buttonA.isEnabled = true
            buttonB.isEnabled = true
            buttonC.isEnabled = false
            buttonD.isEnabled = true
        case "D":
            buttonA.isEnabled = true
            buttonB.isEnabled = true
            buttonC.isEnabled = true
            buttonD.isEnabled = false
        default:
            print("error")
        }
    }
    
    @IBAction func buttonAAction(_ sender: UIButton) {
        disableChosenButton("A")
    }
    @IBAction func buttonBAction(_ sender: UIButton) {
        disableChosenButton("B")
    }
    @IBAction func buttonCAction(_ sender: UIButton) {
        disableChosenButton("C")
    }
    @IBAction func buttonDAction(_ sender: UIButton) {
        disableChosenButton("D")
    }
    
    @IBAction func answerTFEndEditing(_ sender: UITextField) {
        submitBtn.isEnabled = true
    }
    
    @IBAction func saveProblemButtonPressed(_ sender: Any) {
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
            savedName = "Saved Problem \(UserDefaults.standard.getSavedProblemCounter())"
        }
        var listOfAnswers: [PhysicsVariable] = [PhysicsVariable]()
        var listOfKnowns: [PhysicsVariable] = [PhysicsVariable]()
        if toPass == "kinematics" {
            listOfAnswers.append(QuizViewController.LIST_OF_VARS[QuizViewController.LIST_OF_VARS.count - 2])
        }
        listOfAnswers.append(QuizViewController.LIST_OF_VARS[QuizViewController.LIST_OF_VARS.count - 1])
        for i in 0...QuizViewController.LIST_OF_VARS.count - listOfAnswers.count - 1 {
            listOfKnowns.append(QuizViewController.LIST_OF_VARS[i])
        }
        let prompt: String = promptTextView.text
        let savedProblem = SavedProblem.init(answers: listOfAnswers, knownValues: listOfKnowns, equation: toPass, savedProblemName: savedName, prompt: prompt)
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
        savedName = "Saved Problem \(UserDefaults.standard.getSavedProblemCounter())"
        
        let saveAlert = UIAlertController(title: "Problem was saved.", message: "", preferredStyle: .alert)
        present(saveAlert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            saveAlert.dismiss(animated: true, completion: nil)
        }
    }
    
    //UIPickerView Stuff:
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
        
        beginQuiz()
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
        
        listOfBtns.append(UIButton(frame: currentQuizScoreTitle.frame))
        listOfBtns.append(UIButton(frame: currentProblemLabel.frame))
        
        listOfBtns.append(UIButton(frame: exitBtn.frame))
        listOfBtns.append(UIButton(frame: nextBtn.frame))
        listOfBtns.append(UIButton(frame: promptTextView.frame))
        listOfBtns.append(UIButton(frame: answerTextField.frame))
        listOfBtns.append(UIButton(frame: selectUnitBtn.frame))
        listOfBtns.append(UIButton(frame: submitBtn.frame))
        listOfBtns.append(UIButton(frame: saveProblemBtn.frame))
        for i in 0...listOfBtns.count - 1 {
            listOfBtns[i].tag = i
            listOfBtns[i].backgroundColor = UIColor.clear
            listOfBtns[i].addTarget(self, action: #selector(openPopup), for: .touchUpInside)
            self.quizView.addSubview(listOfBtns[i])
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
        popUp.text = HelpPopups.QUIZ[sender.tag]
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
    
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "quiz setup", sender: self)
    }
    
}
