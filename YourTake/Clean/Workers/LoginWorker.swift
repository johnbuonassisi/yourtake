//
//  LoginWorker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class LoginWorker: NSObject {
    
    var loginStore: LoginStoreProtocol
    
    init(loginStore: LoginStoreProtocol) {
        self.loginStore = loginStore
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        loginStore.login(username: username, password: password, completion: completion)
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        loginStore.changePassword(oldPassword: oldPassword, newPassword: newPassword, completion: completion)
    }
    
}

protocol LoginStoreProtocol {
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Bool) -> Void)
    
}
