//
//  OptionsViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/5/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

//Need to find way for this view controller to receive data from other view controller after it pushes settings button to know where to return to after hitting return/ knowing where to go after hitting practice problem/unit converter/etc (or maybe it sends message to those viewControllers to set up problems/unit options based on what view controller its coming from... hmmm)

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var otherCalculatorsBtn: UIButton!
    @IBOutlet weak var showWorkBtn: UIButton!
    @IBOutlet weak var showEquationBtn: UIButton!
    @IBOutlet weak var unitConverterBtn: UIButton!
    @IBOutlet weak var practiceProblemsBtn: UIButton!
    @IBOutlet weak var quizBtn: UIButton!
    
    
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var additionalToolsLabel: UILabel!
    
    var toPass: String = ""
    
    var exitHelpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatButtonsAndLabels()
        
        if Helper.MODE == "Help" {
            helpMode()
            return
        }
        
        if toPass.contains("PP") || toPass.contains("calculator") {
            
        } else {
            returnBtn.isHidden = true
        }
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
        switch segue.identifier {
        case "practice":
            let svc = segue.destination as! PracticeProblemsViewController;
            svc.toPass = toPass
        case "calculator":
            let svc = segue.destination as! CalculatorViewController;
            svc.toPass = toPass
        case "show work":
            let svc = segue.destination as! ShowWorkViewController
            svc.toPass = toPass
        case "show equation":
            let svc = segue.destination as! ShowEquationViewController
            svc.toPass = toPass
        case "quiz start":
            let svc = segue.destination as! QuizSetupViewController
            svc.toPass = toPass
        case "unit converter":
            let svc = segue.destination as! UnitConverterViewController
            svc.toPass = toPass
        default:
            break
        }
        
    }
    
    func formatButtonsAndLabels() {
        var cornerRadius: CGFloat = 10
        if self.view.frame.width > 500 {
            cornerRadius = 25
        }
        additionalToolsLabel.layer.masksToBounds = true
        additionalToolsLabel.layer.cornerRadius = cornerRadius
        let isIphoneX = Helper.IS_IPHONE_X()
        let length: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: 42, width: length, height: length)
        } else {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: returnBtn.frame.minY, width: length, height: length)
        }
        fixMainBtns()
    }
    
    func fixMainBtns() {
        if otherCalculatorsBtn.frame.width/200 > otherCalculatorsBtn.frame.height/40 {
            let newWidth: CGFloat = otherCalculatorsBtn.frame.height * (200/40)
            let newX: CGFloat = self.view.frame.width/2 - newWidth/2
            otherCalculatorsBtn.frame = CGRect(x: newX, y: otherCalculatorsBtn.frame.minY, width: newWidth, height: otherCalculatorsBtn.frame.height)
            showWorkBtn.frame = CGRect(x: newX, y: showWorkBtn.frame.minY, width: newWidth, height: showWorkBtn.frame.height)
            showEquationBtn.frame = CGRect(x: newX, y: showEquationBtn.frame.minY, width: newWidth, height: showEquationBtn.frame.height)
            unitConverterBtn.frame = CGRect(x: newX, y: unitConverterBtn.frame.minY, width: newWidth, height: unitConverterBtn.frame.height)
            practiceProblemsBtn.frame = CGRect(x: newX, y: practiceProblemsBtn.frame.minY, width: newWidth, height: practiceProblemsBtn.frame.height)
            quizBtn.frame = CGRect(x: newX, y: quizBtn.frame.minY, width: newWidth, height: quizBtn.frame.height)
        } else {
            let newHeight: CGFloat = otherCalculatorsBtn.frame.width * (40/200)
            otherCalculatorsBtn.frame = CGRect(x: otherCalculatorsBtn.frame.minX, y: otherCalculatorsBtn.frame.minY, width: otherCalculatorsBtn.frame.width, height: newHeight)
            showWorkBtn.frame = CGRect(x: showWorkBtn.frame.minX, y: showWorkBtn.frame.minY, width: showWorkBtn.frame.width, height: newHeight)
            showEquationBtn.frame = CGRect(x: showEquationBtn.frame.minX, y: showEquationBtn.frame.minY, width: showEquationBtn.frame.width, height: newHeight)
            unitConverterBtn.frame = CGRect(x: unitConverterBtn.frame.minX, y: unitConverterBtn.frame.minY, width: unitConverterBtn.frame.width, height: newHeight)
            practiceProblemsBtn.frame = CGRect(x: practiceProblemsBtn.frame.minX, y: practiceProblemsBtn.frame.minY, width: practiceProblemsBtn.frame.width, height: newHeight)
            quizBtn.frame = CGRect(x: quizBtn.frame.minX, y: quizBtn.frame.minY, width: quizBtn.frame.width, height: newHeight)
        }
    }
    
    //fix her up
    @IBAction func exitOptionScreen(_ sender: UIButton) {
        switch true {
        case toPass.contains("calculator"):
            performSegue(withIdentifier: "calculator", sender: self)
        case toPass.contains("PP"):
            performSegue(withIdentifier: "practice", sender: self)
        default:
            print("error w/ return btn")
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
        listOfBtns.append(UIButton(frame: additionalToolsLabel.frame))
        
        listOfBtns.append(UIButton(frame: returnBtn.frame))
        listOfBtns.append(UIButton(frame: otherCalculatorsBtn.frame))
        listOfBtns.append(UIButton(frame: showWorkBtn.frame))
        listOfBtns.append(UIButton(frame: showEquationBtn.frame))
        listOfBtns.append(UIButton(frame: unitConverterBtn.frame))
        listOfBtns.append(UIButton(frame: practiceProblemsBtn.frame))
        listOfBtns.append(UIButton(frame: quizBtn.frame))
        
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
        popUp.text = HelpPopups.OPT[sender.tag]
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
        performSegue(withIdentifier: "show work", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "prev", sender: self)
    }
    

}
