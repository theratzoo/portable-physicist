//
//  AdvancedOptionsViewController.swift
//  Kintematics Calculator
//
//  Created by Luke Deratzou on 5/14/18.
//  Copyright © 2018 Luke Deratzou. All rights reserved.
//

import UIKit

class AdvancedOptionsViewController: UIViewController {

    struct TypeOfAdvancedOptions {
        
    }
    
    @IBOutlet weak var directionTypeNone: UIButton!
    @IBOutlet weak var directionTypeEveryday: UIButton!
    @IBOutlet weak var directionTypeCompass: UIButton!
    @IBOutlet weak var directionTypeAngle: UIButton!
    
    var listOfOptions: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "options") {
            let svc = segue.destination as! OptionsViewController;
            svc.toPass = "forces"
        }
        
    }
    
    @IBAction func selectDirectionTypeNone(_ sender: UIButton) {
        directionTypeNone.isEnabled = false
        //directionTypeNone.title = "None (selected)"
    }
    
    @IBAction func selectDirectionTypeEveryday(_ sender: UIButton) {
    }
    
    @IBAction func selectDirectionTypeCompass(_ sender: UIButton) {
    }
    
    @IBAction func selectDirectionTypeAngle(_ sender: UIButton) {
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
