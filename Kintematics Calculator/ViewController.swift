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


//"Official" title for app: Physics Portal (for students & professors)

//Alpha notes:

//iPhone X 30x30 btn size:
//Width: 35.0
//Height: 43.0
//so... make sure height = width whenever screen size changes... find a way!
import UIKit

class ViewController: UIViewController {

    var toPass: String = ""
    var eqName = "NAN"
    @IBOutlet weak var calculatorTitle: UILabel!
    
    @IBOutlet weak var selectCalculatorLabel: PaddingLabel!
    
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet weak var kinematicsBtn: UIButton!
    @IBOutlet weak var forceBtn: UIButton!
    @IBOutlet weak var kineticenergyBtn: UIButton!
    @IBOutlet weak var gravitationalforceBtn: UIButton!
    
    var exitHelpMode: Bool = false
    
    //can also have a little tutorial for first-time users. Show em around the app
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFirstLaunchSettings()
        formatStoryboardObjects()
        
        if Helper.MODE == "Help" {
            helpMode()
            return
        }
        UserDefaults.standard.setCurrentPhysicsEqPP(value: "None")
        
        // Do any additional setup after loading the view, typically from a nib.
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
        
        /*if enactTutorial {
         let svc = segue.destination as! HelpViewController;
         svc.toPass = "tutorial"
 
         }
 */
        //For the tutorial... make it mandatory for user first time... but also have the skip option available ASAP!!... make them start at a calculator view controller (the exact calculator depends on which bnt they click on)... if they skip, they go to that calculator... otherwise, tutorial guides them through and, unlike help, includes extras that describe the app as a whole and its functioNs!
        if eqName == "NAN" {
            let svc = segue.destination as! SettingsViewController;
            svc.toPass = "home"
        } else {
            let svc = segue.destination as! CalculatorViewController;
            
            svc.toPass = eqName
        }
        
    }
 
    func formatStoryboardObjects() {
        var cornerRadius:CGFloat = 10
        if self.view.frame.width > 500 {
            selectCalculatorLabel.topInset = 25
            cornerRadius = 25
        }
        calculatorTitle.layer.masksToBounds = true
        calculatorTitle.layer.cornerRadius = cornerRadius
        selectCalculatorLabel.layer.masksToBounds = true
        selectCalculatorLabel.layer.cornerRadius = cornerRadius
        
        let isIphoneX = Helper.IS_IPHONE_X()
        let length: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            //moreBtn.frame = CGRect(x: moreBtn.frame.minX, y: 42, width: length, height: length)
            settingsBtn.frame = CGRect(x: settingsBtn.frame.minX, y: 42, width: length, height: length)
        } else {
            //moreBtn.frame = CGRect(x: moreBtn.frame.minX, y: moreBtn.frame.minY, width: length, height: length)
            settingsBtn.frame = CGRect(x: settingsBtn.frame.minX, y: settingsBtn.frame.minY, width: length, height: length)
        }
        fixMainBtns()
    }
    
    func fixMainBtns() {
        if kinematicsBtn.frame.width/200 > kinematicsBtn.frame.height/40 {
            let newWidth: CGFloat = kinematicsBtn.frame.height * (200/40)
            let newX: CGFloat = self.view.frame.width/2 - newWidth/2
            kinematicsBtn.frame = CGRect(x: newX, y: kinematicsBtn.frame.minY, width: newWidth, height: kinematicsBtn.frame.height)
            forceBtn.frame = CGRect(x: newX, y: forceBtn.frame.minY, width: newWidth, height: forceBtn.frame.height)
            kineticenergyBtn.frame = CGRect(x: newX, y: kineticenergyBtn.frame.minY, width: newWidth, height: kineticenergyBtn.frame.height)
            gravitationalforceBtn.frame = CGRect(x: newX, y: gravitationalforceBtn.frame.minY, width: newWidth, height: gravitationalforceBtn.frame.height)
        } else {
            let newHeight: CGFloat = kinematicsBtn.frame.width * (40/200)
            kinematicsBtn.frame = CGRect(x: kinematicsBtn.frame.minX, y: kinematicsBtn.frame.minY, width: kinematicsBtn.frame.width, height: newHeight)
            forceBtn.frame = CGRect(x: forceBtn.frame.minX, y: forceBtn.frame.minY, width: forceBtn.frame.width, height: newHeight)
            kineticenergyBtn.frame = CGRect(x: kineticenergyBtn.frame.minX, y: kineticenergyBtn.frame.minY, width: kineticenergyBtn.frame.width, height: newHeight)
            gravitationalforceBtn.frame = CGRect(x: gravitationalforceBtn.frame.minX, y: gravitationalforceBtn.frame.minY, width: gravitationalforceBtn.frame.width, height: newHeight)
            
        }
    }
    
    @IBAction func kinematics(_ sender: UIButton) {
        eqName = "kinematics"
        //THIS CODE WILL BE IN ALL BTNS
        /*
         if enactTutorial {
         performSegue(withIdentifier: "tutorial", sender: self)
         
         }
 
 */
        performSegue(withIdentifier: "calculator", sender: self)
        
        
        
    }
    
    @IBAction func forces(_ sender: UIButton) {
        eqName = "forces"
        performSegue(withIdentifier: "calculator", sender: self)
    }
    
    @IBAction func kineticenergy(_ sender: UIButton) {
        eqName = "kinetic energy"
        performSegue(withIdentifier: "calculator", sender: self)
    }
    
    @IBAction func gravitationalforce(_ sender: UIButton) {
        eqName = "gravitational force"
        performSegue(withIdentifier: "calculator", sender: self)
    }
    
    func setUpFirstLaunchSettings() {
        if UserDefaults.standard.getButtonSize() == 0 {
            let smallestDimension = min(settingsBtn.frame.width, settingsBtn.frame.height)
            UserDefaults.standard.setButtonSize(value: Double(smallestDimension))
            //set up the initial values here ^^
            UserDefaults.standard.setShowUnitsPP(value: false)
            UserDefaults.standard.setProblemTypePP(value: "Multiple Choice")
            UserDefaults.standard.setProblemUnitsPP(value: "SI (base)")
            UserDefaults.standard.setEnableSciNot(value: false)
            UserDefaults.standard.setDecimalPointNum(value: 6.1)
            UserDefaults.standard.setEnableSigFigs(value: false)
            UserDefaults.standard.setSigFigNum(value: 4.1)
            UserDefaults.standard.setSavedProblemCounter(value: 1)
            UserDefaults.standard.setListOfSavedConversions(value: "")
            UserDefaults.standard.setUpdate1_1_0(value: true)
            //Helper.MODE = "Tutorial" //change to normal after tutorial is done/skipped
            //enactTutorial = true
            print("first launch!")
        } else if !UserDefaults.standard.getUpdate1_1_0() {
            let userDefaults = UserDefaults.standard
            if userDefaults.getSavedProblemCounter() == 1 {
                return
            }
            let decoded  = userDefaults.object(forKey: "savedProblems") as! Data
            let savedProblems = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [SavedProblem]
            var listOfPromptlessProblems: [String] = [String]()
            for i in savedProblems {
                i.fixPrompt()
                listOfPromptlessProblems.append(i.getSavedProblemName())
            }
            UserDefaults.standard.setListOfPromptlessProblems(value: listOfPromptlessProblems)
            print("hey")
            UserDefaults.standard.setUpdate1_1_0(value: true)
        }
    }
    //new stuff
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
    }
    
    func setUpInvisibleBtns() {
        var listOfBtns: [UIButton] = [UIButton]()
        listOfBtns.append(UIButton(frame: selectCalculatorLabel.frame))
        listOfBtns.append(UIButton(frame: settingsBtn.frame))
        listOfBtns.append(UIButton(frame: kinematicsBtn.frame))
        listOfBtns.append(UIButton(frame: forceBtn.frame))
        listOfBtns.append(UIButton(frame: kineticenergyBtn.frame))
        listOfBtns.append(UIButton(frame: gravitationalforceBtn.frame))
        
        for i in 0...5 {
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
        popUp.text = HelpPopups.HOME[sender.tag]
        popUp.tag = -64
        popUp.isEditable = false
        popUp.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        popUp.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE() + 1*factor)
        self.view.addSubview(popUp)
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        
        self.view.addGestureRecognizer(exitGesture)
        /*tag:
         0: titleLabel (select calculator)
         1: settingsBtn
         2: kinematics
         3: force
         4: kinetic
         5: grav
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
        performSegue(withIdentifier: "calculator", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "prev", sender: self)
    }
    
    
}
