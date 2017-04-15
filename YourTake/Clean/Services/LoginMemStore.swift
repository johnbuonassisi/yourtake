//
//  LoginMemStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class LoginMemStore: LoginStoreProtocol {
  
  func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
    completion(true)
  }

}
