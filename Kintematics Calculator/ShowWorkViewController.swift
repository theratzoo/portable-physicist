//
//  ShowWorkViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 6/9/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//
//  Style this... it is ugly as hell, make it pretty =)
//
//Can add an option to show the most recent calculations (whether they are derived from Calculator, PracticeProblems, or Quiz ViewController)... Like have an option to pick 5 most recent problems... can also have an option to save a PP, Quiz Question, or calculation from Calculator ViewController, and then access it at the ShowWork ViewController...

// When user click here, if they have no saved problems, have a message explaining that and how to get saved problems! And if they do, show a list of those in a pickerview, and once one is selected, the games begin...

import UIKit

class ShowWorkViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var toPass: String = ""
    var listOfVars: [PhysicsVariable] = [PhysicsVariable]()

    
    @IBOutlet weak var showWorkTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var titleLabel: PaddingLabel!
    
    @IBOutlet weak var showWorkNavBar: UINavigationBar!
    
    @IBOutlet weak var selectSaveProblemBtn: UIButton!
    
    var nextButton = UIButton(type: .system)
    var previousButton = UIButton(type: .system)
    
    var savedProblems = [SavedProblem]()
    
    var pgNumber: Int = 1
    var listOfImages: [UIImage] = [UIImage(named: "force.gif")!, UIImage(named: "kineticenergyeq.gif")!, UIImage(named: "gravitationalforceeq.gif")!]
    var listOfKImages: [UIImage] = [UIImage(named: "kinematics1.gif")!, UIImage(named: "kinematics2.gif")!, UIImage(named: "kinematics3.gif")!, UIImage(named: "kinematics4.gif")!, UIImage(named: "kinematics5.gif")!]
    var n: Int = -1
    
    var bottomView: UIView!
    
    var chosenSavedProblem: SavedProblem!
    
    var exitHelpMode = false
    
    var derpToPass: String = ""
    
    //quiz overview stuff!
    var listOfCorrectAnswers: [PhysicsVariable] = [PhysicsVariable]()
    var listOfUserAnswers: [String] = [String]()
    var listOfWrongProblemNumbers: [Int] = [Int]()
    var numberOfCorrectAnswers: Double = -1
    var listOfQuestions:[SavedProblem] = [SavedProblem]() //for show work!
    var quizChosenProblem: SavedProblem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatButtonsAndLabels()
        nextButton.setImage(UIImage(named: "right_arrow.png"), for: .normal)
        previousButton.setImage(UIImage(named: "left_arrow.png"), for: .normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: previousButton)
        self.navigationItem.title = "Page 1/5"
        
        showWorkNavBar.setItems([self.navigationItem], animated: true)
        if Helper.MODE == "Help" {
            if self.view.frame.width > 500 {
                showWorkNavBar.frame = CGRect(x: showWorkNavBar.frame.minX, y: self.view.frame.height - 110 - showWorkNavBar.frame.height, width: showWorkNavBar.frame.width, height: showWorkNavBar.frame.height)
            }
            helpMode()
            return
        }
        if toPass == "overview" {
            derpToPass = toPass
            selectSaveProblemBtn.isHidden = true
            chosenSavedProblem = quizChosenProblem
            setUpConfigurations()
            startUp()
            return
        }
        showWorkNavBar.isHidden = true
        let userDefaults = UserDefaults.standard
        if userDefaults.getSavedProblemCounter() == 1 {
            return
        }
        let decoded  = userDefaults.object(forKey: "savedProblems") as! Data
        savedProblems = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [SavedProblem]
        chosenSavedProblem = savedProblems[0]
        setUpBottomView()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.getSavedProblemCounter() == 1 && Helper.MODE != "Help" && toPass != "overview" && derpToPass != "overview" {
            denyMode()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Helper.MODE == "Help" {
            if exitHelpMode {
                Helper.MODE = "Normal"
            }
            return
        }
        if segue.identifier == "quizoverview" {
            let svc = segue.destination as! QuizOverviewViewController
            svc.toPass = toPass
            svc.listOfUserAnswers = listOfUserAnswers
            svc.listOfCorrectAnswers = listOfCorrectAnswers
            svc.listOfWrongProblemNumbers = listOfWrongProblemNumbers
            svc.numberOfCorrectAnswers = numberOfCorrectAnswers
            svc.listOfQuestions = listOfQuestions
            svc.problemChosen = quizChosenProblem
        } else {
            let svc = segue.destination as! OptionsViewController
            svc.toPass = toPass
        }
    }
    
    func formatButtonsAndLabels() {
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension:CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
        } else {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: returnBtn.frame.minY, width: smallestDimension, height: smallestDimension)
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
        let doneBtn = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneBtn.setTitle("Done", for: .normal)
        //doneBtn.tag = sender.tag
        doneBtn.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.bottomView.addSubview(doneBtn)
        
        
    }
    
    @IBAction func showBottomView(_ sender: UIButton) {
        bottomView.tag = 111
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = false
            }
        }
        for i in bottomView.subviews {
            i.isHidden = false
        }
        bottomView.isHidden = false
    }
    
    @objc func hideBottomView(_ sender: UIButton) {
        for i in self.view.subviews {
            if i.tag != 111 {
                i.isUserInteractionEnabled = true
            }
        }
        for i in bottomView.subviews {
            i.isHidden = true
        }
        bottomView.isHidden = true
        showWorkNavBar.isHidden = false
        setUpConfigurations()
        startUp()
        imageView.isHidden = true
        
    }
    
    func setUpConfigurations() {
        showWorkTextView.frame.size.height = showWorkNavBar.frame.minY - showWorkTextView.frame.minY - 40
        if self.view.frame.width < 500 {
            selectSaveProblemBtn.frame = CGRect(x: selectSaveProblemBtn.frame.minX, y: showWorkNavBar.frame.maxY + 10, width: selectSaveProblemBtn.frame.width, height: selectSaveProblemBtn.frame.height)
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE()+4)
        } else {
            showWorkTextView.font = UIFont(name: "Menlo", size: 40)
            selectSaveProblemBtn.frame = CGRect(x: selectSaveProblemBtn.frame.minX, y: showWorkNavBar.frame.minY - 100, width: selectSaveProblemBtn.frame.width, height: selectSaveProblemBtn.frame.height)
        }
    }
    
    @IBAction func leaveShowWork(_ sender: UIButton) {
        if derpToPass == "overview" {
            performSegue(withIdentifier: "quizoverview", sender: self)
        } else {
            performSegue(withIdentifier: "options", sender: self)
        }
    }
    
    func startUp() {
        
        toPass = chosenSavedProblem.getEquationName()
        listOfVars = chosenSavedProblem.getListOfVariables()
        
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        
        previousButton.isEnabled = false
        nextButton.isEnabled = true
        pgNumber = 1
        var pgCount = 0
        if chosenSavedProblem.getPrompt() != "na" {
            pgCount = 2
        }
        switch toPass {
        case "kinematics":
            self.navigationItem.title = "Page \(pgNumber)/\(13 + pgCount)"
            //find way to refresh this?
        case "forces":
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
            n = 0
        case "kinetic energy":
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
            n = 1
        case "gravitational force":
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
            n = 2
        default:
            print("error w/ setting up the page")
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
            n = -1
        }
        if chosenSavedProblem.getPrompt() != "na" {
            promptPage1()
        } else {
            page1()
        }
        
        
    }
    //move stuff from @IBAction to these two funcs...
    //plus delete the outlets and storyboard elements for those 2 arrows
    //and the item that has the counter
    //fix the counter... annoying but it has to be done :P
    @objc func nextStep(_ sender: Any) {
        pgNumber += 1
        var pgCount = 0
        if chosenSavedProblem.getPrompt() != "na" {
            pgCount = 2
        }
        if toPass == "kinematics" {
            self.navigationItem.title = "Page \(pgNumber)/\(13 + pgCount)"
        } else {
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
        }
        if chosenSavedProblem.getPrompt() == "na" {
            loadPage()
        } else {
            loadPromptPage()
        }
    }
    
    @objc func previousStep(_ sender: Any) {
        pgNumber -= 1
        var pgCount = 0
        if chosenSavedProblem.getPrompt() != "na" {
            pgCount = 2
        }
        if toPass == "kinematics" {
            self.navigationItem.title = "Page \(pgNumber)/\(13 + pgCount)"
        } else {
            self.navigationItem.title = "Page \(pgNumber)/\(8 + pgCount)"
        }
        if chosenSavedProblem.getPrompt() == "na" {
            loadPage()
        } else {
            loadPromptPage()
        }
    }
    
    //Make this flexible- needs to easily work with many different equations!
    //IDEA: can have different versions of loadPage that are dependent on the # of vars/ # of unknowns
    //Can also have it work like this: can have it check which page number it is in loadPage, then run a function for that specific page number. In said function, it will find out what to load based on # of vars and # of unknowns.
    //
    func areTheyPreConverted() -> Bool {
        var areTheyPreConverted = true
        for i in listOfVars {
            if i.unit != i.getSIUnits() {
                areTheyPreConverted = false
            }
        }
        return areTheyPreConverted
    }
    
    func loadPromptPage() {
        switch pgNumber {
        case 1:
            promptPage1()
            previousButton.isEnabled = false
        case 2:
            promptPage2()
            previousButton.isEnabled = true
        case 3:
            page1()
        case 4:
            page1_5()
        case 5:
            page2()
        case 6:
            page3()
        //can also have an image as the equation; imageView can display equations whenever they are needed, etc.
        case 7:
            page4()
        case 8:
            page5()
        case 9:
            page6()
        case 10:
            page7()
        case 11:
            page8()
        case 12:
            page9()
        case 13:
            page10()
        case 14:
            page11()
            nextButton.isEnabled = true
        case 15:
            page12()
            nextButton.isEnabled = false
            
        default:
            print("error w/ loadPage")
        }
    }
    
    func loadPage() {
        switch pgNumber {
        case 1:
            page1()
            previousButton.isEnabled = false
        case 2:
            page1_5()
            previousButton.isEnabled = true
        case 3:
            page2()
        case 4:
            page3()
        //can also have an image as the equation; imageView can display equations whenever they are needed, etc.
        case 5:
            page4()
        case 6:
            page5()
        case 7:
            page6()
        case 8:
            page7()
        case 9:
            page8()
        case 10:
            page9()
        case 11:
            page10()
        case 12:
            page11()
            nextButton.isEnabled = true
        case 13:
            page12()
            nextButton.isEnabled = false
        default:
            print("error w/ loadPage")
        }
    }
    
    
    func promptPage1() {
        if self.view.frame.width < 500 {
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE()+4)
        }
        showWorkTextView.text = "Step 1: Read the prompt to identify the knowns and unknown (what to solve for). When looking for variables in a prompt, identify numbers, units, and variable titles. For each match found, write them down. At the end of the prompt, the variable that you are solving for will be stated. Write down its name along with a question mark to visualize it as the unknown. The prompt will be on the next page. Try to identify the knowns and unknown. If stuck, the variables will be listed after the prompt page."
    }
    
    func promptPage2() {
        showWorkTextView.text = chosenSavedProblem.getPrompt()
    }
    
    func page1() {
        if self.view.frame.width < 500 {
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE()+4)
        }
        switch true {
        case toPass == "kinematics":
            print(listOfVars.count)
            showWorkTextView.text = "Step \(pgNumber): Identify the knowns and unknowns and match them with numbers and units." + "\n" + "In this case, here are the known variables:" + "\n" + "•\(listOfVars[0].getRealName()) = \(listOfVars[0].unConvertedValue) \(listOfVars[0].unit)" + "\n" + "•\(listOfVars[1].getRealName()) = \(listOfVars[1].unConvertedValue) \(listOfVars[1].unit)" + "\n" + "•\(listOfVars[2].getRealName()) = \(listOfVars[2].unConvertedValue) \(listOfVars[2].unit)" + "\n" + "The variables that will be solved for (unknowns) include:" + "\n" + "•\(listOfVars[3].getRealName()) = ?" + "\n" + "•\(listOfVars[4].getRealName()) = ?"
        case toPass == "forces" || toPass == "kinetic energy":
            showWorkTextView.text = "Step \(pgNumber): Identify the knowns and unknown and match them with numbers and units." + "\n" + "In this case, here are the known variables:" + "\n" + "•\(listOfVars[0].getRealName()) = \(listOfVars[0].unConvertedValue) \(listOfVars[0].unit)" + "\n" + "•\(listOfVars[1].getRealName()) = \(listOfVars[1].unConvertedValue) \(listOfVars[1].unit)" + "\n" + "The variable that will be solved for (unknown) is:" + "\n" + "•\(listOfVars[2].getRealName()) = ?"
        case toPass == "gravitational force":
            showWorkTextView.text = "Step \(pgNumber): Identify the knowns and unknown and match them with numbers and units." + "\n" + "In this case, here are the known variables:" + "\n" + "•\(listOfVars[0].getRealName()) = \(listOfVars[0].unConvertedValue) \(listOfVars[0].unit)" + "\n" + "•\(listOfVars[1].getRealName()) = \(listOfVars[1].unConvertedValue) \(listOfVars[1].unit)" + "\n" + "•\(listOfVars[2].getRealName()) = \(listOfVars[2].unConvertedValue) \(listOfVars[2].unit)" + "\n" + "The variable that will be solved for (unknown) is:" + "\n" + "•\(listOfVars[3].getRealName()) = ?"
        default:
            print("error w/ page1 function")
        }
        
    }
    
    func page1_5() {
        imageView.isHidden = true
        var c = 2
        if toPass == "kinematics" {
            c += 1
        }
        
        var theText = "Step \(pgNumber): Convert units of known values to SI (base) units." + "\n"
        for i in 0...listOfVars.count-c {
            if listOfVars[i].getSIUnits() != listOfVars[i].unit {
                
                var tempList: [String] = [String]()
                var factorTempList: [Double] = [Double]()
                for j in Helper.GET_UNIT_FACTOR_LIST() {
                    tempList.append(j.name)
                    factorTempList.append(j.value)
                }
                var theInd = -1
                if let index = tempList.firstIndex(where: { $0.hasPrefix(listOfVars[i].unit) }) {
                    theInd = index
                }
                
                theText += "Since \(listOfVars[i].getRealName()) has units of \(listOfVars[i].unit) for its current value, it must be converted to \(listOfVars[i].getSIUnits())."
                theText += "\n"
                theText += "After multiplying the original value, \(listOfVars[i].unConvertedValue), by the conversion factor, \(factorTempList[theInd]), the new value is \(listOfVars[i].value)."
                theText += "\n"
            }
        }
        if !theText.contains("new value") {
            theText += "Since all values are currently in SI (base) units, no conversions are necessary."
        }
        showWorkTextView.text = theText
    }
    
    //include all the knowns written together w/ numbers and converted values
    func page1_7() {
    
    }
    
    func page2() {
        if self.view.frame.width < 500 {
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE()+4)
        }
        imageView.isHidden = true
        switch true {
        case toPass == "kinematics":
            showWorkTextView.text = "Step \(pgNumber): Pick an unknown to solve for." + "\n" + "In this case, the unknown that will be solved for is \(listOfVars[3].getRealName())"
        case toPass == "forces" || toPass == "kinetic energy" || toPass == "gravitational force":
            showWorkTextView.text = "Step \(pgNumber): Pick an unknown to solve for." + "\n" + "In this case, since there is only 1 unknown, the unknown that will be solved for is \(listOfVars[2].getRealName())"
        default:
            print("error w/ page2 function")
        }
    }
    func page3() {
        if self.view.frame.width < 500 {
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE())
        }
        imageView.isHidden = false
        switch true {
        case toPass == "kinematics":
            showWorkTextView.text = "Step \(pgNumber): Pick the right equation to solve for the unknown chosen." + "\n" + "In order to select the right equation, look at the 5 Kinematic Equations and find which one has three known variables and the one unknown variable being the one to solve for." + "\n" + "In this case, select the following equation to solve for \(listOfVars[3].getRealName()):"
            imageView.image = listOfKImages[KinematicsEquations.GET_EQUATION(listOfVars: listOfVars)-1]
            configureImage(imageNum: KinematicsEquations.GET_EQUATION(listOfVars: listOfVars))
        case toPass == "forces" || toPass == "kinetic energy" || toPass == "gravitational force" || toPass == "gravitational potential energy":
            showWorkTextView.text = "Step \(pgNumber): Pick the right equation to solve for the unknown." + "\n" + "Since there is only 1 equation suitable, the equation would be the one below:"
            imageView.image = listOfImages[n] //Fatal error: index out of range. Happened with Gravitational Force Show Work
            configureImage(imageNum: n)
        default:
            print("error w/ page3 function")
        }
    }
    func page4() {
        if self.view.frame.width < 500 {
            showWorkTextView.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE()+5)
        }
        
        imageView.isHidden = true
        switch true {
        case toPass == "kinematics":
            showWorkTextView.text = "Step \(pgNumber): Isolate the unknown variable." + "\n" + "Using Algebra, put all of the known variables and constants on one side of the equation, and the lone unknown variable on the other side of the equation." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolateK(listV: listOfVars, withValues: false))"
        case toPass == "forces" || toPass == "kinetic energy" || toPass == "gravitational force":
            showWorkTextView.text = "Step \(pgNumber): Isolate the unknown variable." + "\n" + "Using Algebra, put all of the known variables and constants on one side of the equation, and the lone unknown variable on the other side of the equation." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolate(withValues: false))"
        default:
            print("error w/ page4 function")
        }
    }
    func page5() {
        switch true {
        case toPass == "kinematics":
            showWorkTextView.text = "Step \(pgNumber): Plug in known variable values into the equation chosen." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolateK(listV: listOfVars, withValues: true))"
        case toPass == "forces" || toPass == "kinetic energy" || toPass == "gravitational force":
            showWorkTextView.text = "Step \(pgNumber): Plug in known variable values into the equation chosen." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolate(withValues: true))"
        default:
            print("error w/ page5 function")
        }
    }
    //find a nice way to end it; like a congrats, or some cute party like image, idk...
    func page6() {
        switch true {
        case toPass == "kinematics" || toPass == "gravitational force":
            showWorkTextView.text = "Step \(pgNumber): Solve!" + "\n" +  "After performing these calculations, the answer would work out to be this:" + "\n" + "\(listOfVars[3].value) \(listOfVars[3].unit)"
        case toPass == "forces" || toPass == "kinetic energy":
            showWorkTextView.text = "Step \(pgNumber): Solve!" + "\n" +  "After performing these calculations, the answer would work out to be this:" + "\n" + "\(listOfVars[2].value) \(listOfVars[2].unit)"
        default:
            print("error w/ page6 funciton")
        }
        nextButton.isEnabled = true
        
    }
    func page7() {
        imageView.isHidden = true
        //fix this to check for sig figs and decimals (like show decimal rounding if sig figs are not enabled)...
        let decimalPointNum = Int(UserDefaults.standard.getDecimalPointNum())
        let sigFigNum = Int(UserDefaults.standard.getSigFigNum())
        switch true {
        case toPass == "kinematics" && !UserDefaults.standard.getEnableSigFigs():
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Decimal Points shown is set to \(decimalPointNum), the answer will be rounded to \(listOfVars[3].getRoundedAns()) \(listOfVars[3].getSIUnits())."
        case toPass == "kinematics" && UserDefaults.standard.getEnableSigFigs():
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Significant Figures used is set to \(sigFigNum), the answer will be rounded to \(listOfVars[3].getRoundedAns()) \(listOfVars[3].getSIUnits())."
        case toPass != "kinematics" && !UserDefaults.standard.getEnableSigFigs():
            let r: String = (listOfVars.last?.getRoundedAns())!
            let u: String = (listOfVars.last?.getSIUnits())!
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Decimal Points shown is set to \(decimalPointNum), the answer will be rounded to \(r) \(u)."
        case toPass != "kinematics" && UserDefaults.standard.getEnableSigFigs():
            let r: String = (listOfVars.last?.getRoundedAns())!
            let u: String = (listOfVars.last?.getSIUnits())!
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Sig Figs used is set to \(sigFigNum), the answer will be rounded to \(r) \(u)."
        default:
            print("FATAL ERROR")
        }
        if toPass != "kinematics" {
            nextButton.isEnabled = false
        }
        
    }
    func page8() {
        imageView.isHidden = false
        showWorkTextView.text = "Step \(pgNumber): Pick an equation to solve for the second unknown variable." + "\n" + "Since there is only 1 unknown left, any equation with the unknown variable would suffice." + "\n" + "In this case, the following equation will be used:"
        var rando = Int(arc4random_uniform(4)) + 1
        while rando == KinematicsEquations.GET_EQUATION(listOfVars: listOfVars) {
            rando = Int(arc4random_uniform(4)) + 1
        }
        if n == -1 {
            n = rando
        }
        imageView.image = listOfKImages[n-1]
        configureImage(imageNum: n)
        
    }
    func page9() {
        imageView.isHidden = true
        var tempList: [PhysicsVariable] = [PhysicsVariable]()
        for i in listOfVars {
            tempList.append(i)
        }
        tempList.remove(at: 3)
        showWorkTextView.text = "Step \(pgNumber): Isolate the unknown variable." + "\n" + "Using Algebra, put all of the known variables and constants on one side of the equation, and the lone unknown variable on the other side of the equation." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolateK(listV: tempList, withValues: false))"
    }
    func page10() {
        var tempList: [PhysicsVariable] = [PhysicsVariable]()
        for i in listOfVars {
            tempList.append(i)
        }
        tempList.remove(at: 3)
        showWorkTextView.text = "Step \(pgNumber): Plug in known variable values into the equation chosen." + "\n" + "In this case, it would look like this:" + "\n" + "\(isolateK(listV: tempList, withValues: true))"
    }

    func page11() {
        showWorkTextView.text = "Step \(pgNumber): Solve!" + "\n" +  "After performing these calculations, the answer would work out to be this:" + "\n" + "\(listOfVars[4].value) \(listOfVars[4].unit)"
    }
    
    func page12() {
        if UserDefaults.standard.getEnableSigFigs() {
            let sigFigNum = Int(UserDefaults.standard.getSigFigNum())
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Sig Figs used is set to \(sigFigNum), the answer will be rounded to \(listOfVars[4].getRoundedAns()) \(listOfVars[4].getSIUnits())."
        } else {
            let decimalPointNum = Int(UserDefaults.standard.getDecimalPointNum())
            showWorkTextView.text = "Step \(pgNumber): Round" + "\n" +  "Since the number of Decimal Points shown is set to \(decimalPointNum), the answer will be rounded to \(listOfVars[4].getRoundedAns()) \(listOfVars[4].getSIUnits())."
        }
        
    }
    
    func configureImage(imageNum: Int) {
        
        if toPass != "kinematics" {
            switch imageNum {
            case 0:
                //101 428
                if imageView.frame.width / 428 > imageView.frame.height / 101 {
                    let newWidth: CGFloat = imageView.frame.height * (428/101)
                    imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
                } else {
                    let newHeight: CGFloat = imageView.frame.width * (101/428)
                    imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
                }
            case 1:
                //209 605
                if imageView.frame.width / 605 > imageView.frame.height / 209 {
                    let newWidth: CGFloat = imageView.frame.height * (605/209)
                    imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
                } else {
                    let newHeight: CGFloat = imageView.frame.width * (209/605)
                    imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
                }
            case 2:
                //222 806
                if imageView.frame.width / 806 > imageView.frame.height / 22 {
                    let newWidth: CGFloat = imageView.frame.height * (806/22)
                    imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
                } else {
                    let newHeight: CGFloat = imageView.frame.width * (222/806)
                    imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
                }
            default:
                print("ERROR W/ CONFIGURING IMAGE")
            }
            return
        }
        
        //only for kinematics:
        switch imageNum {
        case 1:
            //116 673
            if imageView.frame.width / 673 > imageView.frame.height / 116 {
                let newWidth: CGFloat = imageView.frame.height * (673/116)
                imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
            } else {
                let newHeight: CGFloat = imageView.frame.width * (116/673)
                imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
            }
        case 2:
            //209 1069
            if imageView.frame.width / 1069 > imageView.frame.height / 209 {
                let newWidth: CGFloat = imageView.frame.height * (1069/209)
                imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
            } else {
                let newHeight: CGFloat = imageView.frame.width * (209/1069)
                imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
            }
        case 3:
            //142 1037
            if imageView.frame.width / 1037 > imageView.frame.height / 142 {
                let newWidth: CGFloat = imageView.frame.height * (1017/142)
                imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
            } else {
                let newHeight: CGFloat = imageView.frame.width * (142/1037)
                imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
            }
        case 4:
            //230 837
            if imageView.frame.width / 837 > imageView.frame.height / 230 {
                let newWidth: CGFloat = imageView.frame.height * (837/230)
                imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
            } else {
                let newHeight: CGFloat = imageView.frame.width * (230/837)
                imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
            }
        case 5:
            //209 1097
            if imageView.frame.width / 1097 > imageView.frame.height / 209 {
                let newWidth: CGFloat = imageView.frame.height * (1097/209)
                imageView.frame = CGRect(x: self.view.frame.midX - newWidth/2, y: imageView.frame.minY, width: newWidth, height: imageView.frame.height)
            } else {
                let newHeight: CGFloat = imageView.frame.width * (209/1097)
                imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: newHeight)
            }
        default:
            print("ERROR W/ CONFIGURING IMAGE")
        }
    }
    
    func isolate(withValues: Bool) -> String {
        var eq: String = ""
        switch toPass {
        case "forces":
            eq = ForceEquations.GET_ISOLATED_EQ(listOfVars: listOfVars, withValues: withValues)
        case "kinetic energy":
            eq = KineticEnergyEquations.GET_ISOLATED_EQ(listOfVars: listOfVars, withValues: withValues)
        case "gravitational force":
            eq = GravitationalForceEquation.GET_ISOLATED_EQ(listOfVars: listOfVars, withValues: withValues)
        default:
            print("error w/ isolating")
        }
        return eq
    }
    
    func isolateK(listV: [PhysicsVariable], withValues: Bool) -> String {
        if n != -1 {
            return KinematicsEquations.GET_ISOLATED_EQ(listOfVars: listV, unknownNum: n, withValues: withValues)
        }
        let a = KinematicsEquations.GET_EQUATION(listOfVars: listV)
        return KinematicsEquations.GET_ISOLATED_EQ(listOfVars: listV, unknownNum: a, withValues: withValues)
    }
    
    func denyMode() {
        let saveQuestionAlert = UIAlertController(title: "Show Work- Need Saved Problems!", message: "You have no problems saved for Show Work! Save a Physics problem in the Calculator, Practice Problem, or Quiz sections to see its work here.", preferredStyle: .alert)
        
        let saveQuestionAction = UIAlertAction(title: "Got it!", style: .cancel, handler: { (ACTION: UIAlertAction) in
            self.performSegue(withIdentifier: "options", sender: self)
        })
        saveQuestionAlert.addAction(saveQuestionAction)
        
        present(saveQuestionAlert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return savedProblems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return savedProblems[row].getSavedProblemName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenSavedProblem = savedProblems[row]
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
        pickerLabel?.text = savedProblems[row].getSavedProblemName()
        
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
    
    func helpMode() {
        //could use something to tell users that they are in Help Mode...
        //like a label at the top or whereever it would fit that says help mode
        //or it can be a banner at top that can just be dismissed with an x... idk
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
        showWorkNavBar.isUserInteractionEnabled = true
        
        /*for i in (showWorkNavBar?.items)! {
            
        }*/
    }
    
    func setUpInvisibleBtns() {
        var listOfBtns: [UIButton] = [UIButton]()
        listOfBtns.append(UIButton(frame: titleLabel.frame))
        
        listOfBtns.append(UIButton(frame: returnBtn.frame))
        listOfBtns.append(UIButton(frame: showWorkTextView.frame))
        
        listOfBtns.append(UIButton(frame: CGRect(x: 0, y: showWorkNavBar.frame.minY, width: 100, height: showWorkNavBar.frame.height)))
        listOfBtns.append(UIButton(frame: CGRect(x: self.view.frame.width - 100, y: showWorkNavBar.frame.minY, width: 100, height: showWorkNavBar.frame.height)))
        listOfBtns.append(UIButton(frame: CGRect(x: 100, y: showWorkNavBar.frame.minY, width: self.view.frame.width - 200, height: showWorkNavBar.frame.height)))
        //create left and right buttons (prev and next arrow btns) in the method shown on
        //stack overflow.... and have the middle one normal, but have its invis button have dimensions based on teh frames of the left and right arrows...
        listOfBtns.append(UIButton(frame: selectSaveProblemBtn.frame))
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
        popUp.text = HelpPopups.SHOWORK[sender.tag]
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
        exitHelpMode = false
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    @objc func nextView(_ sender: UIButton) {
        performSegue(withIdentifier: "show equation", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "prev", sender: self)
    }

}
