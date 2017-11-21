//
//  SignupBaasBoxStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class SignupBaasBoxStore: SignupStoreProtocol {
  
  func signup(emailAddress: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.register(username: username,
                           password: password,
                           email: emailAddress,
                           completion:completion)
  }

}
