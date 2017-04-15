//
//  SignupUserViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SignupUserViewControllerInput
{
  func displaySomething(viewModel: SignupUser.Something.ViewModel)
}

protocol SignupUserViewControllerOutput
{
  func doSomething(request: SignupUser.Something.Request)
}

class SignupUserViewController: UIViewController, SignupUserViewControllerInput
{
  var output: SignupUserViewControllerOutput!
  var router: SignupUserRouter!
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var emailAddressSwitch: UISwitch!
  @IBOutlet weak var displayNameSwitch: UISwitch!
  @IBOutlet weak var passwordSwitch: UISwitch!
  
  // MARK: - Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    SignupUserConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  // MARK: - Event handling
  
  func doSomethingOnLoad()
  {
    // NOTE: Ask the Interactor to do some work
    
    let request = SignupUser.Something.Request()
    output.doSomething(request: request)
  }
  
  // MARK: - Display logic
  
  func displaySomething(viewModel: SignupUser.Something.ViewModel)
  {
    // NOTE: Display the result from the Presenter
    
    // nameTextField.text = viewModel.name
  }
}
