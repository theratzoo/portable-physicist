//
//  QuizOverviewViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 7/23/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class QuizOverviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var selectProblemBtn: MenuButton!
    @IBOutlet weak var overviewView: UIView!
    
    var toPass: String = ""
    var listOfCorrectAnswers: [PhysicsVariable] = [PhysicsVariable]()
    var listOfUserAnswers: [String] = [String]()
    var listOfWrongProblemNumbers: [Int] = [Int]()
    var numberOfCorrectAnswers: Double = -1
    var listOfQuestions:[SavedProblem] = [SavedProblem]() //for show work!
    
    var totalNumberOfProblems: Double = -1
    
    var bottomView: UIView!
    var problemChosen: SavedProblem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectProblemBtn.addTarget(self, action: #selector(showBottomView), for: .touchUpInside)
        totalNumberOfProblems = Double(listOfCorrectAnswers.count)
        problemChosen = listOfQuestions.first
        formatButtonsAndLabels()
        addTitleLabel()
        setUpBottomView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Helper.MODE == "Help" {
            return
        }
        switch segue.identifier {
        case "options":
            let svc = segue.destination as! OptionsViewController
            svc.toPass = toPass
        case "quiz setup":
            let svc = segue.destination as! QuizSetupViewController
            svc.toPass = toPass
        case "showwork":
            let svc = segue.destination as! ShowWorkViewController
            svc.toPass = "overview"
            svc.listOfUserAnswers = listOfUserAnswers
            svc.listOfCorrectAnswers = listOfCorrectAnswers
            svc.listOfWrongProblemNumbers = listOfWrongProblemNumbers
            svc.numberOfCorrectAnswers = numberOfCorrectAnswers
            svc.listOfQuestions = listOfQuestions
            svc.quizChosenProblem = problemChosen
            //add other stuff necessary to reload quiz overview after they return here
        default:
            print("FATAL ERROR")
        }
        
    }
    
    func formatButtonsAndLabels() {
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        
        if isIphoneX {
            exitBtn.frame = CGRect(x: exitBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
        } else {
            exitBtn.frame = CGRect(x: exitBtn.frame.minX, y: exitBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        }
        
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - Helper.GET_BOTTOM_VIEW_HEIGHT(), width: self.view.frame.width, height: Helper.GET_BOTTOM_VIEW_HEIGHT()))
        bottomView.backgroundColor = UIColor(displayP3Red: 93/255, green: 188/255, blue: 210/255, alpha: 1)
        bottomView.tag = 111
        self.view.addSubview(bottomView)
        bottomView.isHidden = true
        

        let bottomPicker:UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: self.bottomView.frame.height))
        bottomPicker.delegate = self
        bottomPicker.dataSource = self
        self.bottomView.addSubview(bottomPicker)
        let doneBtn = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneBtn.tag = -10
        doneBtn.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.bottomView.addSubview(doneBtn)
        self.view.bringSubview(toFront: bottomView)
    }
    
    @objc func showBottomView(_ sender: MenuButton) {
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
        for i in overviewView.subviews {
            if i.tag == -1 {
                if let viewWithTag = self.overviewView.viewWithTag(i.tag) {
                    viewWithTag.removeFromSuperview()
                }
            }
        }
        bottomView.isHidden = true
        selectProblemBtn.setTitle(problemChosen.getSavedProblemName(), for: .normal)
        setUpView()
    }
    
    func addTitleLabel() {
        let fontSize: CGFloat = CGFloat(14 + Double(self.view.frame.height / 100.0))
        var temp: String = ""
        let width: CGFloat = self.view.frame.width - exitBtn.frame.width * 2.9
        let label: UILabel = UILabel.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: exitBtn.frame.minY, width: width, height: 0.120 * self.view.frame.height))
        var perc: Double = numberOfCorrectAnswers / totalNumberOfProblems
        perc = Helper.ROUND_BY_DECIMAL_POINTS(value: perc, roundBy: 2)
        perc *= 100
        var cornerRadius:CGFloat = 10
        if self.view.frame.width > 500 {
            cornerRadius = 25
        }
        temp = "Overview" + "\n" + "Score: \(perc)%"
        label.text = temp
        label.numberOfLines = 2
        label.font = UIFont(name: "Menlo", size: fontSize)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(displayP3Red: 1/255, green: 75/255, blue: 116/255, alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = cornerRadius
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        temp.removeAll()
    }
    
    func setUpView() {
        
        //if this string is too big... can divide it into a ton of strings put in an array, add this text to array at spot i, and then do a for loop to add the text to the overview or at least make it so the user can click arrows to go to other info or when they scroll down it renders more (idk)
        
        let describingLabel = UILabel(frame: CGRect(x: 10, y: 10, width: overviewView.frame.width-20, height: overviewView.frame.height*0.7))
        describingLabel.font = UIFont(name: "Menlo", size: Helper.GET_FONT_SIZE() + 4)
        for i in 0...listOfQuestions.count-1 {
            if listOfQuestions[i].getSavedProblemName() == problemChosen.getSavedProblemName() {
                if listOfWrongProblemNumbers.contains(i+1) {
                    
                    var temp = "Problem \(i+1) (\(listOfQuestions[i].getEquationName())): Incorrect."
                    temp += "\n" + "\n" + "Your answer: \(listOfUserAnswers[i])" + "\n" + "Correct answer: \(listOfCorrectAnswers[i].getRoundedAns()) \(listOfCorrectAnswers[i].unit)" + "\n"
                    describingLabel.text = temp
                } else {
                    var temp = "Problem \(i+1) (\(listOfQuestions[i].getEquationName())): Correct."
                    temp += "\n" + "\n" + "Your answer: \(listOfUserAnswers[i])" + "\n"
                    describingLabel.text = temp
                }
            }
        }
        describingLabel.numberOfLines = 10
        describingLabel.tag = -1
        overviewView.addSubview(describingLabel)

        let showWorkBtn = UIButton(frame: CGRect(x: overviewView.frame.width/2 - selectProblemBtn.frame.width/2, y: describingLabel.frame.maxY + 20, width: selectProblemBtn.frame.width, height: selectProblemBtn.frame.height))
        showWorkBtn.setBackgroundImage(UIImage(named: "button_show-work.gif"), for: .normal)
        showWorkBtn.tag = -1
        showWorkBtn.addTarget(self, action: #selector(showWork), for: .touchUpInside)
        overviewView.addSubview(showWorkBtn)
        
    }
    
    @objc func showWork(_ sender: UIButton) {
        performSegue(withIdentifier: "showwork", sender: self)
    }

    //UIPickerView Stuff:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfQuestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfQuestions[row].getSavedProblemName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        problemChosen = listOfQuestions[row]
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
        pickerLabel?.text = listOfQuestions[row].getSavedProblemName()
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
