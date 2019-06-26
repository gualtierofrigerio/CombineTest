//
//  ViewController.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 12/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import UIKit
import Combine

struct ViewModel {
    
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var passwordRepeat:String = ""
    
    var validCredential:AnyPublisher<Bool, Never> {
        return validUsername.combineLatest(validPassword) { (validUsername, validPassword) in
            return validUsername && validPassword
            }.eraseToAnyPublisher()
    }
    
    var validPassword:AnyPublisher<Bool, Never> {
        return $password.combineLatest($passwordRepeat) { (password, passwordRepeat)  in
            var isValid = false
            isValid = (password == passwordRepeat) && password.count > 3
            return isValid
            }.eraseToAnyPublisher()
    }
    
    var validUsername:AnyPublisher<Bool, Never> {
        return $username
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{$0.count > 3 ? true : false}
            .eraseToAnyPublisher()
    }
}

class ViewController: UIViewController {
    
    private var registerButtonSubscriber:AnyCancellable?
    private var viewModel = ViewModel()
    
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



