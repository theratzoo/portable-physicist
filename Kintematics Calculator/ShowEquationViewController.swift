//
//  ShowEquationViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 6/10/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class ShowEquationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var toPass: String = ""
    var listOfImages: [UIImage] = [UIImage(named: "kinematics1.gif")!, UIImage(named: "force.gif")!, UIImage(named: "kineticenergyeq.gif")!, UIImage(named: "gravitationalforceeq.gif")!]
    var listOfKImages: [UIImage] = [UIImage(named: "kinematics1.gif")!, UIImage(named: "kinematics2.gif")!, UIImage(named: "kinematics3.gif")!, UIImage(named: "kinematics4.gif")!, UIImage(named: "kinematics5.gif")!]

    @IBOutlet weak var imageViewA: UIImageView!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var selectEqsBtn: UIButton!

    @IBOutlet weak var listOfEqsView: UIView!
    @IBOutlet weak var listOfEqsPickerView: UIPickerView!
    @IBOutlet weak var titleLabel: PaddingLabel!
    
    var listOfEqs: [String] = [String]()
    var chosenEquation: String = ""
    
    var exitHelpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatButtonsAndLabels()
        listOfEqsView.isHidden = true
        if Helper.MODE == "Help" {
            selectEqsBtn.frame = CGRect(x: selectEqsBtn.frame.minX, y: selectEqsBtn.frame.minY - 50, width: selectEqsBtn.frame.width, height: selectEqsBtn.frame.height)
            helpMode()
            return
        }
        
        chosenEquation = toPass
        
        for i in Helper.GET_LIST_OF_EQS() {
            if chosenEquation.contains(i.lowercased()) {
                chosenEquation = i.lowercased()
            }
        }
        
        self.listOfEqsPickerView.delegate = self
        self.listOfEqsPickerView.dataSource = self
        for i in 0...Helper.GET_LIST_OF_EQS().count {
            if i == 0 {
                listOfEqs.append("Select an equation...")
            } else {
                let x = Helper.GET_LIST_OF_EQS()[i-1].capitalized
                listOfEqs.append(x)
            }
        }
        setUpImages()
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
        let svc = segue.destination as! OptionsViewController
        svc.toPass = toPass
    }
    
    func formatButtonsAndLabels() {
        let isIphoneX = Helper.IS_IPHONE_X()
        let smallestDimension: CGFloat = CGFloat(UserDefaults.standard.getButtonSize())
        if isIphoneX {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: 42, width: smallestDimension, height: smallestDimension)
        } else {
            returnBtn.frame = CGRect(x: returnBtn.frame.minX, y: returnBtn.frame.minY, width: smallestDimension, height: smallestDimension)
        }
        
        
        let doneButton: DoneButton = DoneButton(frame: CGRect(x: self.view.frame.width - Helper.GET_DONE_BTN_WIDTH() - 5, y: 5, width: Helper.GET_DONE_BTN_WIDTH(), height: Helper.GET_DONE_BTN_HEIGHT()))
        doneButton.addTarget(self, action: #selector(hideBottomView), for: .touchUpInside)
        self.listOfEqsView.addSubview(doneButton)
    }
    
    func setUpImages() {
        if chosenEquation.lowercased() == "kinematics" {
            var x = imageViewA.frame.minX / 2
            var dh: CGFloat = 40
            var y: CGFloat = titleLabel.frame.maxY + 20
            if self.view.frame.width > 500 {
                x = x * 2
                dh = 80
            }
            var width: CGFloat = 1097 //5th
            let bounds: CGFloat = self.view.frame.width - x * 2
            if width > bounds {
                width = bounds
            }

            
            //let height: CGFloat = (self.view.frame.height / 5) - 140
            //height = largest of 5 image heights (can know this beforehand)
            //if height > view.width/5 - "140" then make it equal to that value
            //all will have same height
            //all widths will be adjusted based on height
            //y will be determined by stuff
            //x will be determined on self.view.width and width of img. tl;dr it will center the images
            
            var heightA: CGFloat = (width * 116) / 673
            var heightB: CGFloat = (width * 209.0) / 1069.0
            var heightC: CGFloat = (width * 142.0) / 1017.0
            var heightD: CGFloat = (width * 230.0) / 837.0
            var heightE: CGFloat = (width * 209.0) / 1097.0
            if self.view.frame.width < 500 {
                heightA = heightA * 0.7
                heightB = heightB * 0.7
                heightC = heightC * 0.7
                heightD = heightD * 0.7
                heightE = heightE * 0.7
                width = width * 0.7
            }
            let imageA: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: y, width: width, height: heightA))
            imageA.image = listOfKImages[0]
            self.view.addSubview(imageA)
            let backViewA: UIView = UIView(frame: CGRect(x: imageA.frame.minX - 10, y: imageA.frame.minY - 10, width: imageA.frame.width + 20, height: imageA.frame.height + 20))
            backViewA.backgroundColor = UIColor.white
            backViewA.layer.masksToBounds = true
            backViewA.layer.cornerRadius = 15
            self.view.addSubview(backViewA)
            self.view.bringSubview(toFront: imageA)
            
            let imageB: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: imageA.frame.maxY + dh, width: width, height: heightB))
            imageB.image = listOfKImages[1]
            self.view.addSubview(imageB)
            let backViewB: UIView = UIView(frame: CGRect(x: imageB.frame.minX - 10, y: imageB.frame.minY - 10, width: imageB.frame.width + 20, height: imageB.frame.height + 20))
            backViewB.backgroundColor = UIColor.white
            backViewB.layer.masksToBounds = true
            backViewB.layer.cornerRadius = 15
            self.view.addSubview(backViewB)
            self.view.bringSubview(toFront: imageB)
            
            let imageC: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: imageB.frame.maxY + dh, width: width, height: heightC))
            imageC.image = listOfKImages[2]
            self.view.addSubview(imageC)
            let backViewC: UIView = UIView(frame: CGRect(x: imageC.frame.minX - 10, y: imageC.frame.minY - 10, width: imageC.frame.width + 20, height: imageC.frame.height + 20))
            backViewC.backgroundColor = UIColor.white
            backViewC.layer.masksToBounds = true
            backViewC.layer.cornerRadius = 15
            self.view.addSubview(backViewC)
            self.view.bringSubview(toFront: imageC)
            
            let imageD: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: imageC.frame.maxY + dh, width: width, height: heightD))
            imageD.image = listOfKImages[3]
            self.view.addSubview(imageD)
            let backViewD: UIView = UIView(frame: CGRect(x: imageD.frame.minX - 10, y: imageD.frame.minY - 10, width: imageD.frame.width + 20, height: imageD.frame.height + 20))
            backViewD.backgroundColor = UIColor.white
            backViewD.layer.masksToBounds = true
            backViewD.layer.cornerRadius = 15
            self.view.addSubview(backViewD)
            self.view.bringSubview(toFront: imageD)
            
            let imageE: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.width/2 - width/2, y: imageD.frame.maxY + dh, width: width, height: heightE))
            imageE.image = listOfKImages[4]
            self.view.addSubview(imageE)
            let backViewE: UIView = UIView(frame: CGRect(x: imageE.frame.minX - 10, y: imageE.frame.minY - 10, width: imageE.frame.width + 20, height: imageE.frame.height + 20))
            backViewE.backgroundColor = UIColor.white
            backViewE.layer.masksToBounds = true
            backViewE.layer.cornerRadius = 15
            self.view.addSubview(backViewE)
            self.view.bringSubview(toFront: imageE)
            backViewA.tag = -1
            backViewB.tag = -1
            backViewC.tag = -1
            backViewD.tag = -1
            backViewE.tag = -1
            imageA.tag = -1
            imageB.tag = -1
            imageC.tag = -1
            imageD.tag = -1
            imageE.tag = -1
            imageViewA.isHidden = true
        } else {
            imageViewA.isHidden = false
            setUpOtherImgs()
        }
    }
    
    func setUpOtherImgs() {
        var img: UIImage!
        
        for i in 0...Helper.GET_LIST_OF_EQS().count - 1 {
            if chosenEquation.lowercased() == Helper.GET_LIST_OF_EQS()[i] {
                print(i)
                img = listOfImages[i]
            }
        }
        var width: CGFloat = img.size.width
        var height: CGFloat = img.size.height
        let bounds: CGFloat = self.view.frame.width - imageViewA.frame.minX * 2
        if bounds < width {
            width = bounds
            height = (height * width) / img.size.width
        } else if self.view.frame.width > width * 2 {
            width = width * 1.5
            height = (height * width) / img.size.width
        }
        

        imageViewA.frame = CGRect(x: self.view.frame.width/2 - width/2, y: imageViewA.frame.minY, width: width, height: height)
        let backView: UIView = UIView(frame: CGRect(x: imageViewA.frame.minX - 10, y: imageViewA.frame.minY - 10, width: imageViewA.frame.width + 20, height: imageViewA.frame.height + 20))
        backView.tag = -1
        backView.backgroundColor = UIColor.white
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 15
        self.view.addSubview(backView)
        self.view.bringSubview(toFront: imageViewA)
        imageViewA.image = img
    }

    @IBAction func showPickerView(_ sender: UIButton) {
        listOfEqsView.isHidden = false
        selectEqsBtn.isHidden = true
        self.view.bringSubview(toFront: listOfEqsView)
        
    }
    
    @objc func hideBottomView(_ sender: UIButton) {
        listOfEqsView.isHidden = true
        listOfEqsPickerView.selectRow(0, inComponent: 0, animated: true)
        imageViewA.isHidden = true
        for i in self.view.subviews {
            if i.tag == -1 {
                if let viewWithTag = self.view.viewWithTag(i.tag) {
                    viewWithTag.removeFromSuperview()
                }
            }
        }
        setUpImages()
        selectEqsBtn.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfEqs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfEqs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if listOfEqs[row] as String != "Select an equation..." {
            chosenEquation = listOfEqs[row] as String
        }
        
        
        //saveChangesBtn.isEnabled = true
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
        pickerLabel?.text = listOfEqs[row]
        
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
        chosenEquation = "forces"
        setUpImages()
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
        listOfBtns.append(UIButton(frame: titleLabel.frame))
        listOfBtns.append(UIButton(frame: returnBtn.frame))
        listOfBtns.append(UIButton(frame: imageViewA.frame))
        listOfBtns.append(UIButton(frame: selectEqsBtn.frame))
        
       
        
        for i in 0...3 {
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
        popUp.text = HelpPopups.SHOWEQ[sender.tag]
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
        performSegue(withIdentifier: "unit converter", sender: self)
        //move to next view
    }
    @objc func prevView(_ sender: UIButton) {
        performSegue(withIdentifier: "show work", sender: self)
    }
}
