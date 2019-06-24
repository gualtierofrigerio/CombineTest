//
//  ViewController.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 12/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import UIKit
import Combine


class ViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var username:String = ""
    var password:String = ""
    var passwordRepeat:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func usernameDidChange(_ sender: UITextField) {
        
    }
    
    @IBAction func passwordDidChange(_ sender: UITextField) {
    }
    
    @IBAction func passwordRepeatDidChange(_ sender: UITextField) {
    }
}

