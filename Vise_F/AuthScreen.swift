//
//  AuthScreen.swift
//  Vise
//
//  Created by MBP on 10/5/17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import UIKit

class AuthScreen: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
    }

    @IBAction func startButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(initialViewController, animated: true, completion: nil)
    }
}
