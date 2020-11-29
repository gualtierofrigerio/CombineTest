//
//  RegistrationViewModel.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 13/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation
import Combine

/// View model class for the Registration VC
/// Combine is used to react to changes to the username and password
class RegistrationViewModel {
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var passwordRepeat:String = ""
    
    /// validCredential publishes a Bool value combining validUserName and validPassword
    var validCredential:AnyPublisher<Bool, Never> {
        return validUsername.combineLatest(validPassword) { (validUsername, validPassword) in
            return validUsername && validPassword
            }.eraseToAnyPublisher()
    }
    
    /// validPassword combines the published vars password and passwordRepeat
    /// and publishes a Bool that is true only if the two combined values are equal
    var validPassword:AnyPublisher<Bool, Never> {
        return $password.combineLatest($passwordRepeat) { (password, passwordRepeat)  in
            var isValid = false
            isValid = (password == passwordRepeat) && password.count > 3
            return isValid
            }.eraseToAnyPublisher()
    }
    
    /// validUsername publishes true is the username value is at least 4 characters long
    /// debounce is used to avoid publishing values too often while the variable is chaning
    var validUsername:AnyPublisher<Bool, Never> {
        return $username
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{$0.count > 3 ? true : false}
            .eraseToAnyPublisher()
    }
}
