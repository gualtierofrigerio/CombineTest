//
//  RegistrationViewController.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 12/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    private var registerButtonSubscriber:AnyCancellable?
    private var viewModel = RegistrationViewModel()
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButtonSubscriber = viewModel.validCredential
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: registerButton)
        
    }

    @IBAction func usernameDidChange(_ sender: UITextField) {
        viewModel.username = sender.text ?? ""
    }
    
    @IBAction func passwordDidChange(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }
    
    @IBAction func passwordRepeatDidChange(_ sender: UITextField) {
        viewModel.passwordRepeat = sender.text ?? ""
    }
}

