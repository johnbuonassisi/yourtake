//
//  LoginBaasBoxStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class LoginBaasBoxStore: LoginStoreProtocol {
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.login(username: username,
                            password: password,
                            completion: completion)
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.changePassword(oldPassword: oldPassword,
                                     newPassword: newPassword,
                                     completion: completion)
    }
    
}
