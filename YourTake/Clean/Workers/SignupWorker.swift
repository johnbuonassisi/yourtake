//
//  SignupWorker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class SignupWorker: NSObject {

  var signupStore: SignupStoreProtocol
  
  init(signupStore: SignupStoreProtocol) {
    self.signupStore = signupStore
  }
  
  func signup(emailAddress: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
    signupStore.signup(emailAddress: emailAddress,
                      username: username,
                      password: password,
                      completion: completion)
  }
  
}

protocol SignupStoreProtocol {
  
  func signup(emailAddress: String,
              username: String,
              password: String,
              completion: @escaping (Bool) -> Void)
  
}

