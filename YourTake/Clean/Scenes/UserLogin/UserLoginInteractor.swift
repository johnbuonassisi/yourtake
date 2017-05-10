//
//  UserLoginInteractor.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol UserLoginInteractorInput
{
  func login(request: UserLogin.Login.Request, completion: ((Bool) -> Void)?)
}

protocol UserLoginInteractorOutput
{
  func presentLogin(response: UserLogin.Login.Response)
}

class UserLoginInteractor: UserLoginInteractorInput
{
  var output: UserLoginInteractorOutput!
  var worker = LoginWorker(loginStore: LoginBaasBoxStore())
  
  private let MINIMUM_PASSWORD_SIZE = 8
  
  // MARK: - Business logic
  
  // NOTE: - Completion will be executed when request type is "LoginRequest"
  func login(request: UserLogin.Login.Request, completion: ((Bool) -> Void)?)
  {
    switch request.requestType {
    case .loginRequest:
      if isValidUserName(request.username) == false ||
        isValidPassword(request.password) == false {
        print("Login form not properly filled by user")
        print("username: \(request.username), password: \(request.password)")
        return
      }
      worker.login(username: request.username,
                   password: request.password,
                   completion: { (isSuccess) -> Void in
                    if isSuccess {
                      
                      // Save username and password to the keychain
                      let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                              account: request.username,
                                                              accessGroup: KeychainConfiguration.accessGroup)
                      do {
                        try passwordItem.savePassword(request.password)
                      } catch {
                        fatalError("Error saving password - \(error)")
                      }
                      
                      let response = UserLogin.Login.Response(isUserNameEntered: true,
                                                              isPasswordValid: true,
                                                              isUserLoggedIn: true)
                      self.output.presentLogin(response: response)
                      completion!(true)
                      
                    } else {
                      let response = UserLogin.Login.Response(isUserNameEntered: true,
                                                              isPasswordValid: true,
                                                              isUserLoggedIn: false)
                      self.output.presentLogin(response: response)
                      completion!(false)
                    }
      })

    case .updateView:
      let isUserNameEntered = isValidUserName(request.username)
      let isPasswordValid = isValidPassword(request.password)
      let response = UserLogin.Login.Response(isUserNameEntered: isUserNameEntered,
                                              isPasswordValid: isPasswordValid,
                                              isUserLoggedIn: false)
      output.presentLogin(response: response)
    }
  }
  
  private func isValidUserName(_ username: String) -> Bool {
    return username.characters.count > 0
  }
  
  private func isValidPassword(_ password: String) -> Bool {
    return password.characters.count >= MINIMUM_PASSWORD_SIZE
  }
}
