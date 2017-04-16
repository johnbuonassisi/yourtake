//
//  SignupUserPresenter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SignupUserPresenterInput
{
  func presentSignup(response: SignupUser.Signup.Response)
}

protocol SignupUserPresenterOutput: class
{
  func displaySignup(viewModel: SignupUser.Signup.ViewModel)
}

class SignupUserPresenter: SignupUserPresenterInput
{
  weak var output: SignupUserPresenterOutput!
  
  private let SYSTEM_BLUE_COLOUR = UIColor(red: 0.0,
                                           green: 122.0/255.0,
                                           blue: 255.0/255.0,
                                           alpha: 1.0)
  private let SYSTEM_LIGHT_GRAY_COLOUR = UIColor(red: 180.0/255.0,
                                                 green: 180.0/255.0,
                                                 blue: 180.0/255.0,
                                                 alpha: 1.0)
  
  // MARK: - Presentation logic
  
  func presentSignup(response: SignupUser.Signup.Response)
  {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    let isSignupButtonEnabled = response.isEmailValid && response.isUserNameValid && response.isPasswordValid
    let signupButtonColour = isSignupButtonEnabled ? SYSTEM_BLUE_COLOUR : SYSTEM_LIGHT_GRAY_COLOUR
    let viewModel = SignupUser.Signup.ViewModel(isEmailSwitchOn: response.isEmailValid,
                                                isUsernameSwitchOn: response.isUserNameValid,
                                                isPasswordSwitchOn: response.isPasswordValid,
                                                isSignupButtonEnabled: isSignupButtonEnabled,
                                                signupButtonColour: signupButtonColour)
    output.displaySignup(viewModel: viewModel)
  }
}
