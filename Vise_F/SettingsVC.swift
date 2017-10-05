//
//  SettingsVC.swift
//  Vise
//
//  Created by MBP on 10/5/17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var setController: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if  UserDefaults.standard.string(forKey: "Ln") == "english"{
            
            setController.selectedSegmentIndex = 0

        }
        
        if  UserDefaults.standard.string(forKey: "Ln") == "rus"{
            
            setController.selectedSegmentIndex = 1

        }
        
        if  UserDefaults.standard.string(forKey: "Ln") == "ukrain"{
            
            setController.selectedSegmentIndex = 2

        }
      
    }
    
    @IBAction func selectLanguage(_ sender: UISegmentedControl) {
        
        switch setController.selectedSegmentIndex
        {
        case 0:
            setController.selectedSegmentIndex = 0
            UserDefaults.standard.set("english", forKey: "Ln")
        case 1:
            setController.selectedSegmentIndex = 1
            UserDefaults.standard.set("rus", forKey: "Ln")

        case 2:
            setController.selectedSegmentIndex = 2
            UserDefaults.standard.set("ukrain", forKey: "Ln")

        default:
            break;
        }
    }
}
