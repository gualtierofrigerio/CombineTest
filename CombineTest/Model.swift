//
//  Model.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 13/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation
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
